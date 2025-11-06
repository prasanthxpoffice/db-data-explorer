// Graph module: Cytoscape init and helpers, exported via window.App.Graph
(function(){
  window.App = window.App || {};

  function defaultStyle(){
    return [
      { selector: 'node', style: {
          label: 'data(label)', 'text-wrap': 'wrap', 'text-max-width': 120, 'font-size': 12,
          'background-color': (ele)=> ele.data('color') || '#64748b', 'border-width': 1,
          'border-color': '#0f172a', width: 'label', height: 'label', padding: '10px',
          shape: 'round-rectangle', 'text-valign': 'center', 'text-halign': 'center', color: '#e5e7eb'
      }},
      { selector: 'edge', style: {
          width: 2, 'line-color': '#475569', 'target-arrow-color': '#475569',
          'target-arrow-shape': 'triangle', 'curve-style': 'bezier'
      }},
      { selector: 'edge[bidirectional]', style: { 'source-arrow-shape': 'triangle' }},
      { selector: ':selected', style: { 'border-width': 2, 'border-color': '#f59e0b' }},
      { selector: 'node.hub', style: { 'border-width': 3, 'border-color': '#f59e0b' }},
      { selector: 'node.leaf', style: { opacity: 0.85 }},
      { selector: 'node.search-hit', style: { 'border-width': 4, 'border-color': '#3b82f6' }},
      { selector: 'node.search-blinkA', style: { opacity: 1 }},
      { selector: 'node.search-blinkB', style: { opacity: 0.35 }},
      { selector: 'node.sp', style: { 'border-width': 3, 'border-color': '#06b6d4' }},
      { selector: 'node.sp-start', style: {
          'border-width': 4, 'border-color': '#22c55e',
          'background-image': "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='%2322c55e'><path d='M5 3v18'/><path d='M7 4h10l-2 3 2 3H7z'/></svg>",
          'background-fit': 'none', 'background-width': 16, 'background-height': 16,
          'background-position-x': 4, 'background-position-y': 4, 'background-repeat': 'no-repeat'
      }},
      { selector: 'node.sp-end', style: {
          'border-width': 4, 'border-color': '#ef4444',
          'background-image': "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='%23ef4444'><path d='M12 2l4 4-4 4-4-4 4-4z'/><circle cx='12' cy='18' r='3'/></svg>",
          'background-fit': 'none', 'background-width': 16, 'background-height': 16,
          'background-position-x': 4, 'background-position-y': 4, 'background-repeat': 'no-repeat'
      }},
      { selector: 'edge.sp', style: {
          width: 4, 'line-color': '#f59e0b', 'target-arrow-color': '#f59e0b', 'source-arrow-color': '#f59e0b',
          'curve-style': 'bezier', 'target-arrow-shape': 'none', 'source-arrow-shape': 'none', 'arrow-scale': 1.4
      }},
      { selector: 'edge.sp.sp-blinkA', style: { opacity: 1 }},
      { selector: 'edge.sp.sp-blinkB', style: { opacity: 0.25 }},
      { selector: "edge.sp[spDir = 'forward']", style: { 'target-arrow-shape': 'triangle', 'source-arrow-shape': 'none' }},
      { selector: "edge.sp[spDir = 'reverse']", style: { 'source-arrow-shape': 'triangle', 'target-arrow-shape': 'none' }}
    ];
  }

  function init({ container, layoutName='cose', isAnimate=()=>true, legendCb }){
    const cy = cytoscape({ container, style: defaultStyle(), layout: { name: layoutName }, wheelSensitivity: 0.15 });
    const ensureLegend = typeof legendCb === 'function' ? legendCb : ()=>{};

    function nodeId(col,val){ return `${col}:${val}`; }
    function edgeId(fcol,fval,tcol,tval){ return `${fcol}:${fval}->${tcol}:${tval}`; }

    function ensureNode({ col, val, text, color, type }){
      const id = nodeId(col,val);
      const existing = cy.getElementById(id);
      if(!existing.empty()){
        try{
          const d = existing.data();
          if (type != null && (d.type == null || d.type === '')) existing.data('type', type);
          if (color && (d.color == null || d.color === '')) existing.data('color', color);
          if (text && (d.label == null || d.label === String(d.val))) existing.data('label', text);
        } catch {}
        return existing;
      }
      const label = text || String(val);
      const ele = cy.add({ group:'nodes', data:{ id, col, val, label, color, type }});
      try { ensureLegend(type, color); } catch {}
      return ele;
    }

    function ensureEdge(row){
      const source = nodeId(row.from_col, row.from_val);
      const target = nodeId(row.to_col, row.to_val);
      ensureNode({ col: row.from_col, val: row.from_val, text: row.from_text, color: row.from_color, type: row.from_type });
      ensureNode({ col: row.to_col, val: row.to_val, text: row.to_text, color: row.to_color, type: row.to_type });
      const id = edgeId(row.from_col, row.from_val, row.to_col, row.to_val);
      const revId = edgeId(row.to_col, row.to_val, row.from_col, row.from_val);
      let e = cy.getElementById(id);
      if(!e.empty()){
        try{ if (row.views_count != null) e.data('views_count', Number(row.views_count)); if (row.views_list != null) e.data('views_list', String(row.views_list)); } catch {}
        return e;
      }
      const rev = cy.getElementById(revId);
      if(!rev.empty()){
        try{ rev.data('bidirectional', true); if (row.views_count != null) rev.data('views_count', Number(row.views_count)); if (row.views_list != null) rev.data('views_list', String(row.views_list)); } catch {}
        return rev;
      }
      const data = { id, source, target };
      if (row.views_count != null) data.views_count = Number(row.views_count);
      if (row.views_list != null) data.views_list = String(row.views_list);
      return cy.add({ group: 'edges', data });
    }

    let layoutTimer = null;
    function relayout(){
      clearTimeout(layoutTimer);
      layoutTimer = setTimeout(()=>{ cy.layout({ name: cy._layoutName || 'cose', animate: !!isAnimate(), fit:true, padding:20 }).run(); }, 50);
    }

    function setEdgeStyleForSize(){
      const many = cy.edges().length > 1000;
      cy.style()
        .selector('edge')
        .style({ width: 'mapData(views_count, 1, 6, 2, 8)', 'curve-style': many ? 'haystack' : 'bezier', 'target-arrow-shape': many ? 'none' : 'triangle', 'line-color': 'mapData(views_count, 1, 6, #94a3b8, #f59e0b)', 'target-arrow-color': 'mapData(views_count, 1, 6, #94a3b8, #f59e0b)' })
        .selector('edge[bidirectional]')
        .style({ 'source-arrow-shape': many ? 'none' : 'triangle' })
        .selector('edge.sp').style({ width:4, 'curve-style': 'bezier', 'line-color':'#f59e0b', 'target-arrow-color':'#f59e0b', 'source-arrow-color':'#f59e0b', 'target-arrow-shape':'none', 'source-arrow-shape':'none', 'arrow-scale':1.4 })
        .selector('edge.sp.sp-blinkA').style({ opacity:1 })
        .selector('edge.sp.sp-blinkB').style({ opacity:0.25 })
        .selector("edge.sp[spDir = 'forward']").style({ 'target-arrow-shape':'triangle', 'source-arrow-shape':'none' })
        .selector("edge.sp[spDir = 'reverse']").style({ 'source-arrow-shape':'triangle', 'target-arrow-shape':'none' })
        .update();
    }

    let labelHideThreshold = 1500;
    function adjustLabels(){
      const many = cy.nodes().length > labelHideThreshold;
      cy.style().selector('node').style({ label: many ? '' : 'data(label)', 'min-zoomed-font-size': many ? 8 : 0 }).update();
    }

    return { cy, nodeId, edgeId, ensureNode, ensureEdge, relayout, setEdgeStyleForSize, adjustLabels };
  }

  App.Graph = { init };
})();
