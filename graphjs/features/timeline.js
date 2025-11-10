import { cy } from '../core/cy-init.js';
import { state } from '../core/state.js';
import { qs, setText } from '../core/dom.js';
import { setEdgeStyleForSize, adjustLabels } from './filters.js';
import { isAnimate } from '../core/cy-init.js';

function snapshotFromCy() {
  const nodes = cy.nodes().map(n => {
    const d = n.data();
    const pos = n.position();
    return { id: d.id, col: d.col, val: d.val, label: d.label, color: d.color, type: d.type, position: { x: pos.x, y: pos.y } };
  });
  const edges = cy.edges().map(e => {
    const d = e.data();
    return { id: d.id, source: d.source, target: d.target, views_count: d.views_count, views_list: d.views_list, bidirectional: e.data('bidirectional') };
  });
  const zoom = cy.zoom();
  const pan = cy.pan();
  return { nodes, edges, zoom, pan };
}

function sameSnapshot(a, b) {
  if (!a || !b) return false;
  if (a.nodes.length !== b.nodes.length || a.edges.length !== b.edges.length) return false;
  const an = new Set(a.nodes.map(n => n.id));
  const bn = new Set(b.nodes.map(n => n.id));
  const ae = new Set(a.edges.map(e => e.id));
  const be = new Set(b.edges.map(e => e.id));
  if (an.size !== bn.size || ae.size !== be.size) return false;
  for (const id of an) if (!bn.has(id)) return false;
  for (const id of ae) if (!be.has(id)) return false;
  return true;
}

function updatePanelVisibility() {
  try {
    const panel = document.getElementById('graph-data-panel');
    if (!panel) return;
    const hasContent = cy.nodes().length > 0 && cy.edges().length > 0;
    panel.style.display = hasContent ? '' : 'none';
  } catch {}
}

function updateSliderUi() {
  const slider = qs('#timeline-slider');
  const label = qs('#timeline-label');
  const total = state.timelineSteps.length;
  const idx = Math.max(0, state.timelineIndex);
  if (slider) {
    slider.max = String(Math.max(0, total - 1));
    slider.value = String(Math.max(0, Math.min(idx, total - 1)));
  }
  if (label) setText(label, `${total ? idx + 1 : 0} / ${total}`);
}

export function initTimelineUI() {
  const slider = qs('#timeline-slider');
  if (slider && !slider.dataset.bound) {
    slider.addEventListener('input', () => {
      const target = parseInt(slider.value || '0', 10) || 0;
      goToStep(target);
    });
    slider.dataset.bound = '1';
  }
  // capture initial empty state
  if (!state.timelineSteps.length) {
    state.timelineSteps = [snapshotFromCy()];
    state.timelineIndex = 0;
  }
  updateSliderUi();
}

export function captureTimelineStep() {
  const snap = snapshotFromCy();
  const last = state.timelineSteps[state.timelineSteps.length - 1];
  if (sameSnapshot(last, snap)) { updateSliderUi(); return; }
  state.timelineSteps.push(snap);
  state.timelineIndex = state.timelineSteps.length - 1;
  updateSliderUi();
}

export function resetTimeline() {
  state.timelineSteps = [snapshotFromCy()];
  state.timelineIndex = 0;
  updateSliderUi();
}

export function goToStep(index) {
  const total = state.timelineSteps.length;
  if (total === 0) return;
  const targetIdx = Math.max(0, Math.min(index, total - 1));
  const target = state.timelineSteps[targetIdx];

  // Current graph content sets
  const currNodeSet = new Set(cy.nodes().map(n => n.id()));
  const currEdgeSet = new Set(cy.edges().map(e => e.id()));
  const targetNodeSet = new Set(target.nodes.map(n => n.id));
  const targetNodeMap = new Map(target.nodes.map(n => [n.id, n]));
  const targetEdgeSet = new Set(target.edges.map(e => e.id));

  // Remove elements not in target (edges first)
  const edgesToRemove = [...currEdgeSet].filter(id => !targetEdgeSet.has(id));
  if (edgesToRemove.length) {
    const eles = cy.collection(edgesToRemove.map(id => cy.getElementById(id))).filter(e => !e.empty());
    try { eles.animate({ style: { opacity: 0 } }, { duration: 150, complete: () => eles.remove() }); } catch { eles.remove(); }
  }
  const nodesToRemove = [...currNodeSet].filter(id => !targetNodeSet.has(id));
  if (nodesToRemove.length) {
    const eles = cy.collection(nodesToRemove.map(id => cy.getElementById(id))).filter(e => !e.empty());
    try { eles.animate({ style: { opacity: 0 } }, { duration: 150, complete: () => eles.remove() }); } catch { eles.remove(); }
  }

  // Add missing nodes
  const currNodeSetAfter = new Set(cy.nodes().map(n => n.id()));
  const nodesToAdd = target.nodes.filter(n => !currNodeSetAfter.has(n.id));
  if (nodesToAdd.length) {
    const added = cy.add(nodesToAdd.map(d => ({ group: 'nodes', data: { id: d.id, col: d.col, val: d.val, label: d.label, color: d.color, type: d.type }, position: d.position } )));
    try { added.style('opacity', 0); added.animate({ style: { opacity: 1 } }, { duration: 250 }); } catch {}
  }

  // Update positions and data for nodes that exist in both current and target
  cy.nodes().forEach(n => {
    const snap = targetNodeMap.get(n.id());
    if (snap) {
      try {
        n.position(snap.position || n.position());
        if (snap.label != null) n.data('label', snap.label);
        if (snap.color != null) n.data('color', snap.color);
        if (snap.type != null) n.data('type', snap.type);
      } catch {}
    }
  });

  // Add missing edges
  const currEdgeSetAfter = new Set(cy.edges().map(e => e.id()));
  const edgesToAdd = target.edges.filter(e => !currEdgeSetAfter.has(e.id));
  if (edgesToAdd.length) {
    const added = cy.add(edgesToAdd.map(d => ({ group: 'edges', data: { id: d.id, source: d.source, target: d.target, views_count: d.views_count, views_list: d.views_list } })));
    try { added.style('opacity', 0); added.animate({ style: { opacity: 1 } }, { duration: 250 }); } catch {}
  }

  // Restore bidirectional flags for edges in target
  target.edges.forEach(d => {
    if (d.bidirectional) {
      const e = cy.getElementById(d.id);
      if (e && !e.empty()) try { e.data('bidirectional', true); } catch {}
    }
  });

  // Apply preset layout to enforce positions
  const posMap = new Map(target.nodes.map(n => [n.id, n.position]));
  try {
    cy.layout({ name: 'preset', positions: (ele) => posMap.get(ele.id()) || ele.position(), animate: isAnimate(), fit: false }).run();
  } catch {}

  // Restore viewport
  if (typeof target.zoom === 'number') try { cy.zoom(target.zoom); } catch {}
  if (target.pan && typeof target.pan.x === 'number' && typeof target.pan.y === 'number') try { cy.pan(target.pan); } catch {}

  state.timelineIndex = targetIdx;
  updateSliderUi();
  updatePanelVisibility();
  try { setEdgeStyleForSize(); adjustLabels(); } catch {}
}
