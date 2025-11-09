import { cy, nodeId } from '../core/cy-init.js';
import { state } from '../core/state.js';
import { qs, el, setText } from '../core/dom.js';
import { i18n } from '../core/i18n.js';
import { showShortestPath, clearShortestPath } from './path.js';
import { reapplyFilters } from './filters.js';

export function renderNodeDetails(n) {
  const panel = qs('#node-details');
  if (!n) { setText(panel, i18n.t('no_node_selected')); return; }
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
      el('div', {}, el('span', { class:'tag' }, i18n.t('column')), ' ', n.col),
      el('div', {}, el('span', { class:'tag' }, i18n.t('value')),  ' ', String(n.val)),
      type ? el('div', {}, el('span', { class:'tag' }, i18n.t('type')), ' ', type) : null,
      el('div', { style: { marginTop:'6px' } }, el('span', { class:'tag' }, i18n.t('degree')), ` ${deg} (in ${indeg} | out ${outdeg})`)
    ),
    el('div', { class:'btns', style:{ marginTop:'8px', display:'flex', gap:'8px', flexWrap:'wrap' } },
      el('button', { id:'set-start', type:'button', onclick: () => { state.pathStartId = id; renderNodeDetails(n); } }, i18n.t('set_start')),
      el('button', { id:'set-end', type:'button', onclick: () => { state.pathEndId = id; renderNodeDetails(n); } }, i18n.t('set_end')),
      el('button', { id:'show-path', type:'button', disabled: !(state.pathStartId && state.pathEndId), onclick: () => { showShortestPath(); } }, i18n.t('show_shortest_path')),
      el('button', { id:'clear-path', type:'button', disabled: !state.currentPathEles, onclick: () => { clearShortestPath(); renderNodeDetails(n); } }, i18n.t('clear_path'))
    ),
    el('div', { class:'hint', style:{ marginTop:'6px' } },
      el('span', { class:'tag' }, i18n.t('path_start')), ' ', startText, ' ',
      el('span', { class:'tag', style:'margin-left:6px;' }, i18n.t('path_end')), ' ', endText,
      el('label', { class:'hint', style:'margin-left:12px; display:block; margin-top:6px;' },
        el('input', { type:'checkbox', id:'stayOnPathLocal', ...(state.stayOnPath ? { checked: true } : {}), onchange: (e)=>{ state.stayOnPath = !!e.target.checked; const master = document.getElementById('stayOnPath'); if (master) master.checked = state.stayOnPath; reapplyFilters(); } }),
        i18n.t('stay_on_path')
      )
    )
  );
}
