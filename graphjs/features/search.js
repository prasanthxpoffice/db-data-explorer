import { state } from '../core/state.js';
import { cy } from '../core/cy-init.js';

function clearSearchBlink() {
  if (state.searchBlinkInterval) { try { clearInterval(state.searchBlinkInterval); } catch {} state.searchBlinkInterval = null; }
  if (state.searchMatches && state.searchMatches.length) { try { state.searchMatches.removeClass('search-hit search-blinkA search-blinkB'); } catch {} }
  state.searchMatches = null;
}

function applySearchBlink(matches) {
  clearSearchBlink();
  state.searchMatches = matches;
  if (!state.searchMatches || state.searchMatches.length === 0) return;
  try { state.searchMatches.addClass('search-hit'); } catch {}
  let on = true;
  try { state.searchMatches.removeClass('search-blinkB').addClass('search-blinkA'); } catch {}
  state.searchBlinkInterval = setInterval(()=>{
    on = !on;
    try { if (on) { state.searchMatches.removeClass('search-blinkB').addClass('search-blinkA'); } else { state.searchMatches.removeClass('search-blinkA').addClass('search-blinkB'); } } catch {}
  }, 500);
}

function renderSearchTerms() {
  const ul = document.getElementById('search-terms'); if (!ul) return;
  ul.innerHTML = '';
  state.searchTerms.forEach((t, idx) => {
    const li = document.createElement('li'); li.className = 'hint chip'; li.style.margin = '2px 0';
    const span = document.createElement('span'); span.className = 'tag'; span.textContent = t;
    const btn = document.createElement('button'); btn.textContent = '×'; btn.className = 'chip-close'; btn.setAttribute('aria-label','Remove');
    btn.addEventListener('click', () => { state.searchTerms.splice(idx, 1); renderSearchTerms(); applySearchBlinkFromTerms(); });
    li.append(span, btn); ul.appendChild(li);
  });
}

export function applySearchBlinkFromTerms() {
  if (!state.searchTerms || state.searchTerms.length === 0) { clearSearchBlink(); return; }
  const terms = state.searchTerms.map(s=>s.toLowerCase());
  const matches = cy.nodes().filter(n=>{
    const lab = (n.data('label')||'').toString().toLowerCase();
    const col = (n.data('col')||'').toString().toLowerCase();
    const val = (n.data('val')||'').toString().toLowerCase();
    const id  = n.id().toLowerCase();
    return terms.some(t => lab.includes(t) || col.includes(t) || val.includes(t) || id.includes(t));
  });
  applySearchBlink(matches);
  if (matches.length>0) { cy.elements().unselect(); matches.select(); cy.fit(matches, 60); }
}

export function initSearchUI() {
  document.getElementById('btnSearchAdd').addEventListener('click', ()=>{
    const raw = (document.getElementById('searchTerm').value||'').toLowerCase();
    const terms = raw.split(/[\s,]+/).map(s=>s.trim()).filter(Boolean);
    if (terms.length === 0) return;
    const set = new Set(state.searchTerms); for (const t of terms) set.add(t);
    state.searchTerms = Array.from(set); document.getElementById('searchTerm').value = '';
    renderSearchTerms(); applySearchBlinkFromTerms();
  });
  document.getElementById('btnSearchClear').addEventListener('click', ()=>{
    document.getElementById('searchTerm').value=''; state.searchTerms = []; renderSearchTerms(); clearSearchBlink(); cy.elements().unselect();
  });
  renderSearchTerms();
}
