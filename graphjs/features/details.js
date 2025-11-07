import { cy, nodeId } from '../core/cy-init.js';
import { state } from '../core/state.js';
import { qs, el, setText } from '../core/dom.js';
import { showShortestPath, clearShortestPath } from './path.js';
import { reapplyFilters } from './filters.js';

export function renderNodeDetails(n) {
  const panel = qs('#node-details');
  if (!n) { setText(panel, 'No node selected.'); return; }
  const id = nodeId(n.col, n.val); const node = cy.getElementById(id);
  const deg = !node.empty() ? node.degree() : 0; const indeg = !node.empty() ? node.indegree() : 0; const outdeg = !node.empty() ? node.outdegree() : 0;
  const color = n.color || '#64748b'; const type = n.type || ''; const label = (n.label ?? '').toString();
  const startText = state.pathStartId ? (() => { const e = cy.getElementById(state.pathStartId); return (!e || e.empty()) ? state.pathStartId : (e.data('label') ?? String(e.data('val') ?? state.pathStartId)); })() : '—';
  const endText   = state.pathEndId   ? (() => { const e = cy.getElementById(state.pathEndId);   return (!e || e.empty()) ? state.pathEndId   : (e.data('label') ?? String(e.data('val') ?? state.pathEndId)); })()   : '—';

  panel.innerHTML = '';
  panel.append(
    el('div', { style: { display:'flex', alignItems:'center', gap:'10px' } },
      el('div', { style: { width:'14px',height:'14px',borderRadius:'3px',background:color,border:'1px solid #0f172a' } }),
      el('div', { style: { fontWeight:'600' } }, label || String(n.val))
    ),
    el('div', { style: { marginTop:'8px' } },
      el('div', {}, el('span', { class:'tag' }, 'Column'), ' ', n.col),
      el('div', {}, el('span', { class:'tag' }, 'Value'),  ' ', String(n.val)),
      type ? el('div', {}, el('span', { class:'tag' }, 'Type'), ' ', type) : null,
      el('div', { style: { marginTop:'6px' } }, el('span', { class:'tag' }, 'Degree'), ` ${deg} (in ${indeg} | out ${outdeg})`)
    ),
    el('div', { class:'btns', style:{ marginTop:'8px', display:'flex', gap:'8px', flexWrap:'wrap' } },
      el('button', { id:'set-start', type:'button', onclick: () => { state.pathStartId = id; renderNodeDetails(n); } }, 'Set Start'),
      el('button', { id:'set-end', type:'button', onclick: () => { state.pathEndId = id; renderNodeDetails(n); } }, 'Set End'),
      el('button', { id:'show-path', type:'button', disabled: !(state.pathStartId && state.pathEndId), onclick: () => { showShortestPath(); } }, 'Show Shortest Path'),
      el('button', { id:'clear-path', type:'button', disabled: !state.currentPathEles, onclick: () => { clearShortestPath(); renderNodeDetails(n); } }, 'Clear Path')
    ),
    el('div', { class:'hint', style:{ marginTop:'6px' } },
      el('span', { class:'tag' }, 'Path Start'), ' ', startText, ' ',
      el('span', { class:'tag', style:'margin-left:6px;' }, 'Path End'), ' ', endText,
      el('label', { class:'hint', style:'margin-left:12px; display:inline-flex; align-items:center; gap:6px;' },
        el('input', { type:'checkbox', id:'stayOnPathLocal', ...(state.stayOnPath ? { checked: true } : {}), onchange: (e)=>{ state.stayOnPath = !!e.target.checked; const master = document.getElementById('stayOnPath'); if (master) master.checked = state.stayOnPath; reapplyFilters(); } }),
        'Stay on Path'
      )
    )
  );
}
