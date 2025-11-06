import { state } from '../core/state.js';
import { cy } from '../core/cy-init.js';

export function ensureLegendForType(type, color) {
  if (type == null) return;
  const key = String(type).trim(); if (!key) return;
  if (!state.typeVisibility.has(key)) {
    const master = document.getElementById('legend-select-all');
    const defaultChecked = master ? !!master.checked : true;
    state.typeVisibility.set(key, defaultChecked);
  }
  if (color && !state.typeColor.has(key)) state.typeColor.set(key, color);
  renderLegendList();
}

function updateLegendSelectAllState() {
  const master = document.getElementById('legend-select-all'); if (!master) return;
  const keys = Array.from(state.typeVisibility.keys());
  if (keys.length === 0) { master.checked = true; master.indeterminate = false; return; }
  const allTrue = keys.every(k => state.typeVisibility.get(k) === true);
  const anyTrue = keys.some(k => state.typeVisibility.get(k) === true);
  master.checked = allTrue; master.indeterminate = !allTrue && anyTrue;
}

export function renderLegendList() {
  const cont = document.getElementById('legend-types'); if (!cont) return;
  cont.innerHTML = '';
  const keys = Array.from(state.typeVisibility.keys()).sort((a,b)=> a.localeCompare(b, undefined, { sensitivity: 'base' }));
  keys.forEach(key => {
    const wrap = document.createElement('div'); wrap.className = 'legend-item';
    const cb = document.createElement('input'); cb.type = 'checkbox'; cb.checked = !!state.typeVisibility.get(key);
    cb.addEventListener('change', ()=>{ state.typeVisibility.set(key, !!cb.checked); applyTypeFilter(); updateEdgeVisibility(); updateLegendSelectAllState(); });
    const sw = document.createElement('span'); sw.className = 'legend-swatch'; sw.style.background = state.typeColor.get(key) || '#64748b';
    const lbl = document.createElement('span'); lbl.className = 'legend-label'; lbl.textContent = key;
    wrap.append(cb, sw, lbl);
    cont.appendChild(wrap);
  });
  updateLegendSelectAllState();
}

export function recomputeHubsLeaves() {
  cy.nodes().removeClass('hub leaf');
  cy.nodes().forEach(n => { const deg = n.degree(); if (deg === 1) n.addClass('leaf'); if (deg >= state.hubDeg) n.addClass('hub'); });
}

export function applyTypeFilter() {
  const pathNodes = (state.stayOnPath && state.currentPathEles) ? state.currentPathEles.filter('node') : null;
  cy.nodes().forEach(n => {
    if (pathNodes) { n.style('display', pathNodes.has(n) ? 'element' : 'none'); return; }
    const t = (n.data('type') ?? '').toString().trim();
    const typeAllowed = !t || !state.typeVisibility.has(t) || state.typeVisibility.get(t) === true;
    const leafBlocked = state.hideLeaves && n.hasClass('leaf');
    n.style('display', (typeAllowed && !leafBlocked) ? 'element' : 'none');
  });
}

export function applyFanoutLimitScratch() {
  cy.edges().forEach(e => e.scratch('_hideFanout', false));
  if (state.currentFanoutLimit == null) return;
  const bySrc = new Map();
  cy.edges().forEach(e => { const s = e.data('source'); if (!bySrc.has(s)) bySrc.set(s, []); bySrc.get(s).push(e); });
  bySrc.forEach(list => {
    list.sort((a,b)=> (a.id() < b.id() ? -1 : 1));
    for (let i=0;i<list.length;i++) { const e = list[i]; if (i >= state.currentFanoutLimit) e.scratch('_hideFanout', true); }
  });
}

export function updateEdgeVisibility() {
  const pathEdges = (state.stayOnPath && state.currentPathEles) ? state.currentPathEles.filter('edge') : null;
  cy.edges().forEach(e => {
    let show = true;
    if (pathEdges) show = pathEdges.has(e);
    const vc = e.data('views_count');
    if (show && vc != null && Number(vc) < state.minSupport) show = false;
    if (show && e.scratch('_hideFanout')) show = false;
    if (show) { try { if (!e.source().visible() || !e.target().visible()) show = false; } catch {} }
    e.style('display', show ? 'element' : 'none');
  });
}

export function setEdgeStyleForSize() {
  const many = cy.edges().length > 1000;
  cy.style()
    .selector('edge').style({
      width: 'mapData(views_count, 1, 6, 2, 8)',
      'curve-style': many ? 'haystack' : 'bezier',
      'target-arrow-shape': many ? 'none' : 'triangle',
      'line-color': 'mapData(views_count, 1, 6, #94a3b8, #f59e0b)',
      'target-arrow-color': 'mapData(views_count, 1, 6, #94a3b8, #f59e0b)',
    })
    .selector('edge[bidirectional]').style({ 'source-arrow-shape': many ? 'none' : 'triangle' })
    .selector('edge.sp').style({ width: 4, 'curve-style': 'bezier', 'line-color': '#f59e0b', 'target-arrow-color': '#f59e0b', 'source-arrow-color': '#f59e0b', 'target-arrow-shape': 'none', 'source-arrow-shape': 'none', 'arrow-scale': 1.4 })
    .selector('edge.sp.sp-blinkA').style({ opacity: 1 })
    .selector('edge.sp.sp-blinkB').style({ opacity: 0.25 })
    .selector("edge.sp[spDir = 'forward']").style({ 'target-arrow-shape': 'triangle', 'source-arrow-shape': 'none' })
    .selector("edge.sp[spDir = 'reverse']").style({ 'source-arrow-shape': 'triangle', 'target-arrow-shape': 'none' })
    .update();
}

export function adjustLabels() {
  const many = cy.nodes().length > state.labelHideThreshold;
  cy.style().selector('node').style({ label: many ? '' : 'data(label)', 'min-zoomed-font-size': many ? 8 : 0 }).update();
}

export function reapplyFilters() {
  applyFanoutLimitScratch();
  recomputeHubsLeaves();
  applyTypeFilter();
  updateEdgeVisibility();
  setEdgeStyleForSize();
  adjustLabels();
}

export function initFilterControls() {
  document.getElementById('minSupport').addEventListener('input', (e)=>{ state.minSupport = parseInt(e.target.value, 10) || 1; updateEdgeVisibility(); });
  document.getElementById('hideLeaves').addEventListener('change', (e)=>{ state.hideLeaves = !!e.target.checked; recomputeHubsLeaves(); applyTypeFilter(); updateEdgeVisibility(); });
  document.getElementById('hubDeg').addEventListener('change', (e)=>{ state.hubDeg = Math.max(2, parseInt(e.target.value||'6',10)); recomputeHubsLeaves(); });
  document.getElementById('labelThresh').addEventListener('change', (e)=>{ state.labelHideThreshold = Math.max(0, parseInt(e.target.value||'1500',10)); adjustLabels(); });
  const fanoutInput = document.getElementById('fanoutLimit');
  function applyFanoutFromInput(){ const v = parseInt(fanoutInput.value||'', 10); state.currentFanoutLimit = isNaN(v) ? null : Math.max(1, v); reapplyFilters(); }
  let fanoutTimer = null; fanoutInput.addEventListener('change', applyFanoutFromInput); fanoutInput.addEventListener('input', ()=>{ clearTimeout(fanoutTimer); fanoutTimer = setTimeout(applyFanoutFromInput, 300); });
  const master = document.getElementById('legend-select-all');
  if (master) master.addEventListener('change', ()=>{ const checked = !!master.checked; Array.from(state.typeVisibility.keys()).forEach(k => state.typeVisibility.set(k, checked)); document.querySelectorAll('#legend-types input[type="checkbox"]').forEach(inp => { inp.checked = checked; }); master.indeterminate = false; applyTypeFilter(); updateEdgeVisibility(); });
}
