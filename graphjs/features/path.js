import { state } from '../core/state.js';
import { cy } from '../core/cy-init.js';
import { reapplyFilters } from './filters.js';

export function clearShortestPath() {
  try { cy.stop(); } catch {}
  for (const t of state.pathTimers) clearTimeout(t);
  state.pathTimers = [];
  if (state.pathBlinkInterval) { try { clearInterval(state.pathBlinkInterval); } catch {} state.pathBlinkInterval = null; }
  cy.elements('.sp').removeClass('sp');
  cy.edges().removeClass('sp-blinkA sp-blinkB');
  if (state.pathStartId) cy.getElementById(state.pathStartId).removeClass('sp-start');
  if (state.pathEndId) cy.getElementById(state.pathEndId).removeClass('sp-end');
  cy.edges().forEach(e => { try { e.removeData('spDir'); e.removeData('spColor'); } catch {} });
  state.currentPathEles = null; reapplyFilters();
}

function startPathBlink() {
  if (state.pathBlinkInterval) { try { clearInterval(state.pathBlinkInterval); } catch {} }
  const edges = state.currentPathEles ? state.currentPathEles.filter('edge') : cy.collection();
  if (!edges || edges.length === 0) return;
  try { edges.removeClass('sp-blinkB').addClass('sp-blinkA'); } catch {}
  let on = true;
  state.pathBlinkInterval = setInterval(() => {
    on = !on;
    try { if (on) { edges.removeClass('sp-blinkB').addClass('sp-blinkA'); } else { edges.removeClass('sp-blinkA').addClass('sp-blinkB'); } } catch {}
  }, 500);
}

export function showShortestPath() {
  if (!state.pathStartId || !state.pathEndId) return;
  const start = cy.getElementById(state.pathStartId);
  const end = cy.getElementById(state.pathEndId);
  if (start.empty() || end.empty()) { alert('Start or End node is not in the current graph.'); return; }
  clearShortestPath();
  const result = cy.elements().aStar({ root: start, goal: end, directed: false });
  if (!result.found) { alert('No path found in current graph. Try expanding more.'); return; }
  state.currentPathEles = result.path;
  try { start.addClass('sp-start'); } catch {}
  try { end.addClass('sp-end'); } catch {}
  const seq = state.currentPathEles.toArray();
  for (let i = 1; i < seq.length - 1; i++) {
    const ele = seq[i]; if (!ele.isEdge()) continue;
    const prev = seq[i - 1]; const next = seq[i + 1];
    if (!prev || !next || !prev.isNode() || !next.isNode()) continue;
    const src = ele.data('source'); const tgt = ele.data('target');
    const forward = (src === prev.id() && tgt === next.id());
    try { ele.data('spDir', forward ? 'forward' : 'reverse'); } catch {}
  }
  const animate = document.getElementById('animate')?.checked ?? true;
  if (animate) {
    const ordered = state.currentPathEles.toArray();
    try { cy.edges().removeClass('sp'); } catch {}
    ordered.forEach((ele, idx) => { const t = setTimeout(() => { try { ele.addClass('sp'); } catch {} }, idx * 60); state.pathTimers.push(t); });
    const total = ordered.length * 60 + 100;
    state.pathTimers.push(setTimeout(() => { try { cy.animate({ fit: { eles: state.currentPathEles.union(start).union(end), padding: 40 }, duration: 400 }); } catch {} reapplyFilters(); startPathBlink(); }, total));
  } else {
    state.currentPathEles.addClass('sp'); cy.fit(state.currentPathEles.union(start).union(end), 40); reapplyFilters();
  }
}
