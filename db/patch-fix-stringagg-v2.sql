/*
  Patch v2: Remove literal \n in dynamic SQL strings that caused syntax errors
  and keep NVARCHAR(MAX) casting for STRING_AGG fragments.
*/

USE [IAS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Re-alter [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang] with clean dynamic SQL */
ALTER PROCEDURE [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang]
(
    @ViewID              INT,
    @Frontier            dbgraph.ColValPair READONLY,
    @Depth               INT,
    @ExcludeForThisView  dbgraph.ColValPair READONLY,
    @Lang                NVARCHAR(2) = N'en',
    @MaxFanout           INT = NULL,
    @ReturnMode          NVARCHAR(8) = N'EDGES'
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @db SYSNAME, @sch SYSNAME, @vw SYSNAME;
    SELECT
        @db  = ViewDB,
        @sch = ViewSchema,
        @vw  = CASE WHEN @Lang = N'ar' THEN ViewNameAr ELSE ViewNameEn END
    FROM dbgraph.ViewRegistry
    WHERE ViewID = @ViewID;

    IF @db IS NULL OR @sch IS NULL OR @vw IS NULL
    BEGIN RAISERROR('dbgraph: ViewID %d not found or language mapping missing.',16,1,@ViewID); RETURN; END;

    DECLARE @three NVARCHAR(512) = QUOTENAME(@db)+N'.'+QUOTENAME(@sch)+N'.'+QUOTENAME(@vw);

    IF OBJECT_ID('tempdb..#F') IS NOT NULL DROP TABLE #F;
    CREATE TABLE #F
    (
        col  SYSNAME NOT NULL,
        val  NVARCHAR(4000) NOT NULL,
        val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), val)))
    );
    CREATE UNIQUE NONCLUSTERED INDEX UX_F ON #F(col, val_hash) INCLUDE (val);
    INSERT #F(col,val)
    SELECT col, LTRIM(RTRIM(val))
    FROM @Frontier
    WHERE val IS NOT NULL
    GROUP BY col, LTRIM(RTRIM(val));

    IF OBJECT_ID('tempdb..#X') IS NOT NULL DROP TABLE #X;
    CREATE TABLE #X
    (
        col  SYSNAME NOT NULL,
        val  NVARCHAR(4000) NOT NULL,
        val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), val)))
    );
    CREATE UNIQUE NONCLUSTERED INDEX UX_X ON #X(col, val_hash) INCLUDE (val);
    INSERT #X(col,val)
    SELECT col, LTRIM(RTRIM(val))
    FROM @ExcludeForThisView
    WHERE val IS NOT NULL
    GROUP BY col, LTRIM(RTRIM(val));

    IF OBJECT_ID('tempdb..#Pairs') IS NOT NULL DROP TABLE #Pairs;
    CREATE TABLE #Pairs
    (
        grp       NVARCHAR(128) PRIMARY KEY,
        id_col    SYSNAME NOT NULL,
        text_col  SYSNAME NOT NULL,
        color_col SYSNAME NOT NULL,
        nt_col    SYSNAME NOT NULL
    );

    DECLARE @objId INT = OBJECT_ID(@three);
    IF @objId IS NULL BEGIN RAISERROR('dbgraph: View not found: %s',16,1,@three); RETURN; END;

    ;WITH C AS (SELECT name FROM sys.columns WHERE object_id=@objId),
    NT AS (SELECT SUBSTRING(name,4,4000) grp, name nt_col FROM C WHERE name LIKE N'NT\_%' ESCAPE '\'),
    ID AS (SELECT LEFT(SUBSTRING(name,4,4000), LEN(SUBSTRING(name,4,4000))-2) grp, name id_col
           FROM C WHERE name LIKE N'ID\_%' ESCAPE '\' AND RIGHT(name,2)='ID'),
    TX AS (SELECT LEFT(SUBSTRING(name,6,4000), LEN(SUBSTRING(name,6,4000))-4) grp, name text_col
           FROM C WHERE name LIKE N'TEXT\_%' ESCAPE '\' AND RIGHT(name,4)='TEXT'),
    CL AS (SELECT SUBSTRING(name,7,4000) grp, name color_col FROM C WHERE name LIKE N'COLOR\_%' ESCAPE '\')
    INSERT #Pairs(grp, id_col, text_col, color_col, nt_col)
    SELECT N.grp, I.id_col, T.text_col, L.color_col, N.nt_col
    FROM NT N JOIN ID I ON I.grp=N.grp JOIN TX T ON T.grp=N.grp JOIN CL L ON L.grp=N.grp;

    IF NOT EXISTS (SELECT 1 FROM #Pairs)
    BEGIN RAISERROR('dbgraph: No NT/ID/TEXT/COLOR groups in %s',16,1,@three); RETURN; END

    DECLARE @Base NVARCHAR(MAX) =
    (
        SELECT STRING_AGG(
          CAST(
          N'SELECT t.*, '
          + N'''' + p.id_col + N''' AS cur_id_col, '
          + N'CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N'))) AS cur_id_hash '
          + N'FROM ' + @three + N' AS t '
          + N'WHERE EXISTS ( '
          + N'  SELECT 1 FROM #F f '
          + N'  WHERE f.col = ''' + p.id_col + N''' '
          + N'    AND f.val_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N'))) '
          + N')'
          AS NVARCHAR(MAX)),
          N' UNION ALL '
        )
        FROM #Pairs p
        WHERE EXISTS (SELECT 1 FROM #F WHERE col = p.id_col)
    );
    IF @Base IS NULL
        SET @Base = N'SELECT t.*, CAST(NULL AS SYSNAME) cur_id_col, CAST(NULL AS VARBINARY(32)) cur_id_hash FROM ' + @three + N' t WHERE 1=0';

    DECLARE @CurUnion NVARCHAR(MAX) =
    (
      SELECT STRING_AGG(
        CAST(
        N'SELECT '
        + N'''' + p.id_col + N''' AS cur_col, '
        + N'CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N') AS cur_val, '
        + N't.' + QUOTENAME(p.text_col)  + N' AS cur_text, '
        + N't.' + QUOTENAME(p.color_col) + N' AS cur_color, '
        + N't.' + QUOTENAME(p.nt_col)    + N' AS cur_type, '
        + N't.row_id AS row_id '
        + N'FROM Base t'
        AS NVARCHAR(MAX)),
        N' UNION ALL '
      )
      FROM #Pairs p
    );
    DECLARE @NxtUnion NVARCHAR(MAX) = @CurUnion;

    DECLARE @sqlCte NVARCHAR(MAX) = N'
WITH Base0 AS ( ' + @Base + N' ),
Base AS (
  SELECT Base0.*, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS row_id
  FROM Base0
),
Cur AS ( ' + @CurUnion + N' ),
Fanout AS (
  SELECT
    c.cur_col, c.cur_val,
    c.cur_text, c.cur_color, c.cur_type,
    n.cur_col AS nxt_col, n.cur_val AS nxt_val,
    n.cur_text AS nxt_text, n.cur_color AS nxt_color, n.cur_type AS nxt_type,
    ROW_NUMBER() OVER (PARTITION BY c.cur_col, c.cur_val ORDER BY n.cur_col, n.cur_val) AS rn
  FROM Cur c
  JOIN Base b
    ON b.cur_id_col = c.cur_col
   AND b.cur_id_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), c.cur_val)))
   AND b.row_id = c.row_id
  JOIN (' + @NxtUnion + N') n
    ON n.row_id = b.row_id
  WHERE n.cur_val IS NOT NULL
    AND NOT (n.cur_col = c.cur_col AND ISNULL(n.cur_val, '''') = ISNULL(c.cur_val, ''''))
),
Pruned AS (
  SELECT *
  FROM Fanout
  WHERE (@MaxFanout IS NULL OR rn <= @MaxFanout)
    AND NOT EXISTS (
      SELECT 1 FROM #X x
      WHERE x.col = nxt_col
        AND x.val_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), nxt_val)))
    )
),
Agg AS (
  SELECT
    cur_col, cur_val, nxt_col, nxt_val,
    MIN(cur_type)  AS cur_type,
    MIN(cur_text)  AS cur_text,
    MIN(cur_color) AS cur_color,
    MIN(nxt_type)  AS nxt_type,
    MIN(nxt_text)  AS nxt_text,
    MIN(nxt_color) AS nxt_color
  FROM Pruned
  GROUP BY cur_col, cur_val, nxt_col, nxt_val
)
';

    DECLARE @sql NVARCHAR(MAX);
    IF @ReturnMode = N'NEXT'
        SET @sql = @sqlCte + N'
SELECT DISTINCT col = nxt_col, val = nxt_val
FROM Agg
ORDER BY col, val
OPTION (RECOMPILE);';
    ELSE
        SET @sql = @sqlCte + N'
SELECT
  view_id    = @ViewID,
  depth      = @Depth,
  from_col   = cur_col,
  from_val   = cur_val,
  from_type  = cur_type,
  from_text  = cur_text,
  from_color = cur_color,
  to_col     = nxt_col,
  to_val     = nxt_val,
  to_type    = nxt_type,
  to_text    = nxt_text,
  to_color   = nxt_color,
  path       = CONCAT(cur_col, N''='', cur_val, N'' -> '', nxt_col, N''='', nxt_val)
FROM Agg
ORDER BY from_col, from_val, to_col, to_val
OPTION (RECOMPILE);';

    EXEC sp_executesql
      @sql,
      N'@ViewID int, @Depth int, @MaxFanout int',
      @ViewID=@ViewID, @Depth=@Depth, @MaxFanout=@MaxFanout;
END
GO

