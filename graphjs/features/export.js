import { cy } from '../core/cy-init.js';

export function initExportButtons() {
  document.getElementById('btnTidy').addEventListener('click', ()=>{
    const name = document.getElementById('layout').value;
    const animate = document.getElementById('animate')?.checked ?? true;
    cy.layout({ name, animate, fit: true, padding: 20 }).run();
  });
  document.getElementById('btnExportPng').addEventListener('click', ()=>{
    try {
      const uri = cy.png({ full: true, scale: 2, bg: '#0f172a' });
      const a = document.createElement('a'); a.href = uri; a.download = 'graph.png'; document.body.appendChild(a); a.click(); a.remove();
    } catch (e) { console.error('Export PNG failed', e); }
  });
}
