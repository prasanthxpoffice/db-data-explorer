import { cy } from './core/cy-init.js';
import { state } from './core/state.js';
import { qs } from './core/dom.js';
import { initViews } from './features/views.js';
import { initSeedsUI, refreshSeedColumns } from './features/seeds.js';
import { initFilterControls, reapplyFilters } from './features/filters.js';
import { renderNodeDetails } from './features/details.js';
import { expandFromNode, runTraverse, clearGraph, updateGraphDataPanel } from './features/expand.js';
import { initSearchUI, applySearchBlinkFromTerms } from './features/search.js';
import { showShortestPath, clearShortestPath } from './features/path.js';
import { initExportButtons } from './features/export.js';

function relayout() {
  const name = qs('#layout').value;
  cy.layout({ name, animate: qs('#animate')?.checked ?? true, fit: true, padding: 20 }).run();
}
qs('#layout').addEventListener('change', relayout);
// Theme toggle
const themeSel = qs('#theme');
if (themeSel) themeSel.addEventListener('change', ()=>{
  const v = themeSel.value;
  const root = document.documentElement;
  if (v === 'light') root.setAttribute('data-theme','light'); else root.removeAttribute('data-theme');
});

// Language direction (RTL for Arabic)
function applyLangDirection() {
  const langSel = qs('#lang');
  const v = langSel?.value || 'en';
  const root = document.documentElement;
  root.setAttribute('lang', v);
  root.setAttribute('dir', v === 'ar' ? 'rtl' : 'ltr');
}
const langSel = qs('#lang');
if (langSel) langSel.addEventListener('change', applyLangDirection);
// Apply once on load
applyLangDirection();

// Graph selection expands and shows details (unless stopped)
cy.on('select', 'node', async (evt) => { const n = evt.target.data(); renderNodeDetails(n); if (state.stopNodeExpand) return; await expandFromNode(n); });
cy.on('unselect', 'node', () => { if (cy.nodes(':selected').length === 0) qs('#node-details').textContent = 'No node selected.'; });

// Top-level buttons
qs('#run').addEventListener('click', runTraverse);
qs('#clear').addEventListener('click', clearGraph);

// Side panel toggles
const lp = document.getElementById('left-panel');
const rp = document.getElementById('right-panel');
qs('#left-toggle').addEventListener('click', ()=>{ lp.classList.toggle('open'); });
qs('#right-toggle').addEventListener('click', ()=>{ rp.classList.toggle('open'); });

// Custom events wiring
document.addEventListener('views:changed', async ()=>{ await refreshSeedColumns(); });
document.addEventListener('path:show', () => { showShortestPath(); });
document.addEventListener('path:clear', () => { clearShortestPath(); });
document.addEventListener('search:apply', applySearchBlinkFromTerms);

// Init modules
initViews();
initSeedsUI();
initFilterControls();
initSearchUI();
initExportButtons();

// Initial adjustments
reapplyFilters();
relayout();
refreshSeedColumns();
updateGraphDataPanel();
