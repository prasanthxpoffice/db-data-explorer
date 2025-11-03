# db-data-explorer

This project is a **SQL Server (LocalDB) + HTML/JS front‑end + Node.js API** for
exploring data relationships across database views and rendering them in **Cytoscape.js**
as a graph (nodes + edges).  
Supports **multi‑view traversal**, **multi‑depth exploration**, and **English/Arabic** field names.

---

## ✅ Project Structure

```
db-data-explorer/
│
├── db/
│   ├── export-bacpac.ps1      # Manual DB export (creates IAS.bacpac)
│   ├── import-bacpac.ps1      # Manual DB import (restore IAS.bacpac)
│   └── (ignored) *.mdf / *.ldf / *.bacpac
│
├── server/
│   └── server.js              # Node.js API (calls stored proc)
│
├── wwwroot/
│   └── index.html             # Front-end + Cytoscape.js
│
├── README.md
└── .gitignore
```

---

## 🧠 What it does

- Allows user to pick one or more views
- Starts from one or more seed nodes (column + value)
- Traverses relations (A → B → C … based on matching ID/Text columns)
- Returns `nodes` and `edges` to render in Cytoscape.js
- Avoids duplicates automatically
- Fast execution using snapshot isolation + temporary hashed sets

---

## ⚠ Database files are NOT tracked

`db/IAS.mdf`, `db/IAS_log.ldf`, and `db/*.bacpac` are ignored to prevent:

- lock issues
- large file commits
- merge conflicts

Instead, you **manually export/import** using BACPAC.

---

## 📦 Manual DB Export (one PC → GitHub)

> Use when you want to sync DB changes

Open PowerShell inside project root:

```ps1
db/export-bacpac.ps1
git add db/IAS.bacpac
git commit -m "DB snapshot update"
git push
```

This creates:

```
db/IAS.bacpac
```

and pushes it.

---

## 📥 Manual DB Import (GitHub → second PC)

Open PowerShell:

```ps1
db/import-bacpac.ps1
```

Or manually using **SQL Server Management Studio**:

```
Right-click Databases → Import Data‑tier Application → Select IAS.bacpac
```

---

## 🌐 Configure SQL LocalDB

Ensure LocalDB exists:

```
sqllocaldb create "MSSQLLocalDB"
sqllocaldb start "MSSQLLocalDB"
```

Connection string example (server.js):

```
Server=(localdb)\MSSQLLocalDB;
Database=IAS;
Trusted_Connection=True;
MultipleActiveResultSets=True;
```

---

## 🧪 Test DB Connection

```ps1
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT DB_NAME()"
```

If output is `IAS`, you're good.

---

## 🚀 Running the project

```
cd server
npm install
node server.js
```

Open browser:

```
http://localhost:3000
```

---

## 🗂 .gitignore

```
db/*.mdf
db/*.ldf
db/*.bacpac
```

---

## 💡 Workflow Summary

| Action | You do |
|--------|--------|
| DB changed and you want to sync? | ✅ Run export-bacpac.ps1 manually |
| Code changed? | ✅ Commit & push normally |
| Working on another PC? | ✅ Run import-bacpac.ps1 |

---

## ✨ No automation — full control

You decided **not to automate DB export in commits**, so nothing happens unless you explicitly export.

---

## 🧑‍💻 Future enhancements (optional)

Just tell me when you want any of these:

- Auto detect schema diffs
- Option to push bacpac only on tagged releases
- Remote shared SQL DB

---

### Need help next?
Just say: **"Next step"** 😊
