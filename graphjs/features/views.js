import { state } from '../core/state.js';
import { getViews } from '../core/api.js';
import { qs } from '../core/dom.js';

const btn = qs('#view-dropdown-btn');
const menu = qs('#view-dropdown');
const container = qs('#view-select');

export function getSelectedViewIds() { return Array.from(state.viewSelected).sort((a,b)=>a-b); }

function viewLabelFor(v, lang) {
  return lang === 'ar'
    ? (v.descriptionAr || v.nameAr || `View ${v.id}`)
    : (v.descriptionEn || v.nameEn || `View ${v.id}`);
}

function updateButton() {
  const lang = qs('#lang').value || 'en';
  const ids = Array.from(state.viewSelected).sort((a,b)=>a-b);
  const names = ids.map(id => {
    const v = state.availableViews.find(x => x.id === id);
    return v ? viewLabelFor(v, lang) : String(id);
  });
  if (!ids.length) { btn.textContent = 'Select views'; return; }
  btn.textContent = '';
  // Prefix then each name on its own line
  btn.append('Selected: ');
  names.forEach((name, idx) => {
    if (idx === 0) {
      btn.append(name);
    } else {
      btn.append(document.createElement('br'));
      btn.append(name);
    }
  });
}

function renderMenu() {
  menu.innerHTML = '';
  const lang = qs('#lang').value || 'en';
  state.availableViews.forEach(v => {
    const label = document.createElement('label');
    const cb = document.createElement('input');
    cb.type = 'checkbox'; cb.value = String(v.id); cb.checked = state.viewSelected.has(v.id);
    cb.addEventListener('change', () => {
      if (cb.checked) state.viewSelected.add(v.id); else state.viewSelected.delete(v.id);
      updateButton();
      document.dispatchEvent(new CustomEvent('views:changed'));
    });
    const span = document.createElement('span');
    span.textContent = lang === 'ar' ? (v.descriptionAr || v.nameAr || `View ${v.id}`)
                                     : (v.descriptionEn || v.nameEn || `View ${v.id}`);
    label.append(cb, span);
    menu.appendChild(label);
  });
}

export async function initViews() {
  try {
    const arr = await getViews();
    state.availableViews = Array.isArray(arr) ? arr.map(v => ({
      id: v.id, nameEn: v.nameEn, nameAr: v.nameAr, descriptionEn: v.descriptionEn, descriptionAr: v.descriptionAr,
    })) : [];
    if (state.viewSelected.size === 0) state.availableViews.slice(0,2).forEach(v => state.viewSelected.add(v.id));
    updateButton(); renderMenu();
  } catch (e) {
    updateButton();
  }

  btn.addEventListener('click', () => { container.classList.toggle('open'); if (container.classList.contains('open')) renderMenu(); });
  document.addEventListener('click', (e) => { if (!container.contains(e.target)) container.classList.remove('open'); });
  qs('#lang').addEventListener('change', () => {
    if (container.classList.contains('open')) renderMenu();
    updateButton();
    document.dispatchEvent(new CustomEvent('views:changed'));
  });
}
