import { state } from '../core/state.js';
import { cy } from '../core/cy-init.js';
import { ensureEdge } from '../core/cy-init.js';
import { traverseStepMulti } from '../core/api.js';
import { getSelectedViewIds } from './views.js';
import { setEdgeStyleForSize, adjustLabels } from './filters.js';
import { refreshSeedColumns } from './seeds.js';

function buildPayloadFromUI() {
  const viewIds = getSelectedViewIds();
  const depth = Math.max(1, parseInt(document.getElementById('depth').value || '1', 10));
  const lang = document.getElementById('lang').value;
  const maxFanoutText = document.getElementById('maxFanout').value;
  const maxFanout = maxFanoutText ? parseInt(maxFanoutText, 10) : undefined;
  return { viewIds, frontier: state.seeds.slice(), perViewExclude: state.perViewExclude, depth, lang, maxFanout };
}

function relayout() {
  const name = document.getElementById('layout').value;
  setTimeout(() => { cy.layout({ name, animate: (document.getElementById('animate')?.checked ?? true), fit: true, padding: 20 }).run(); }, 50);
}

export function updateGraphDataPanel() {
  try {
    const panel = document.getElementById('graph-data-panel');
    if (!panel) return;
    const hasContent = cy.nodes().length > 0 && cy.edges().length > 0;
    panel.style.display = hasContent ? '' : 'none';
  } catch {}
}

export function renderEdges(rows) {
  cy.batch(() => { rows.forEach(ensureEdge); });
  relayout();
  try { refreshSeedColumns(); } catch {}
  updateGraphDataPanel();
}

export async function expandFromNode(n) {
  if (!n || state.isExpanding) return;
  state.isExpanding = true;
  const payload = buildPayloadFromUI();
  try {
    let localExclude = []; const localExcludeSet = new Set();
    const addExcludeLocal = (viewId, col, val) => { const key = `${viewId}|${col}|${String(val)}`; if (localExcludeSet.has(key)) return; localExcludeSet.add(key); localExclude.push({ ViewID: viewId, col, val: String(val) }); };

    let steps = Math.max(1, parseInt(String(payload.depth || 1), 10));
    let next = [{ col: n.col, val: String(n.val) }];
    for (let d = 0; d < steps; d++) {
      if (!next || next.length === 0) break;
      payload.frontier = next.slice(); payload.depth = 1; payload.perViewExclude = localExclude;
      const { edges, nextFrontier } = await traverseStepMulti(payload);
      if (edges && edges.length) {
        let hasNew = false;
        try {
          for (const row of edges) {
            const id = `${row.from_col}:${row.from_val}->${row.to_col}:${row.to_val}`;
            const revId = `${row.to_col}:${row.to_val}->${row.from_col}:${row.from_val}`;
            const fwdEmpty = cy.getElementById(id).empty();
            const revEmpty = cy.getElementById(revId).empty();
            if (fwdEmpty && revEmpty) { hasNew = true; break; }
          }
          if (!hasNew) {
            for (const row of edges) {
              const revId = `${row.to_col}:${row.to_val}->${row.from_col}:${row.from_val}`;
              const rev = cy.getElementById(revId);
              if (!rev.empty()) { try { rev.data('bidirectional', true); } catch {} }
            }
            try { cy.style().update(); } catch {}
          }
        } catch {}
        if (hasNew) { renderEdges(edges); setEdgeStyleForSize(); adjustLabels(); }
      }

      state.currentFrontier = (nextFrontier || []).slice();
      if (Array.isArray(payload.viewIds)) for (const v of payload.viewIds) for (const f of state.currentFrontier) addExcludeLocal(v, f.col, f.val);
      next = state.currentFrontier;
    }
  } catch (err) {
    console.error(err); alert(err.message);
  } finally { state.isExpanding = false; }
}

export async function runTraverse() {
  const payload = buildPayloadFromUI();
  try {
    let localExclude = []; const localExcludeSet = new Set();
    const addExcludeLocal = (viewId, col, val) => { const key = `${viewId}|${col}|${String(val)}`; if (localExcludeSet.has(key)) return; localExcludeSet.add(key); localExclude.push({ ViewID: viewId, col, val: String(val) }); };

    let steps = Math.max(1, parseInt(String(payload.depth || 1), 10));
    let next = state.seeds.slice();
    if (!next.length && cy.nodes().length) {
      const sel = cy.nodes(':selected'); const pool = sel.length ? sel : cy.nodes();
      next = pool.map(n => ({ col: n.data('col'), val: String(n.data('val')) }));
    }

    for (let d = 0; d < steps; d++) {
      if (!next || next.length === 0) break;
      payload.frontier = next.slice(); payload.depth = 1; payload.perViewExclude = localExclude;
      const { edges, nextFrontier } = await traverseStepMulti(payload);
      renderEdges(edges || []); setEdgeStyleForSize(); adjustLabels();
      state.currentFrontier = (nextFrontier || []).slice();
      if (Array.isArray(payload.viewIds)) for (const v of payload.viewIds) for (const f of state.currentFrontier) addExcludeLocal(v, f.col, f.val);
      next = state.currentFrontier;
    }
  } catch (err) { console.error(err); alert(err.message); }
}

export function clearGraph() {
  cy.elements().remove(); state.currentFrontier = []; state.perViewExclude = []; state.perViewExcludeSet = new Set(); state.seeds = [];
  setEdgeStyleForSize(); adjustLabels();
  updateGraphDataPanel();
}
