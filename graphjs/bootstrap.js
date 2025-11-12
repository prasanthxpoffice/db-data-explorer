async function injectPartial(rootId, url) {
  const root = document.getElementById(rootId);
  if (!root) return;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
  const html = await res.text();
  root.insertAdjacentHTML('beforebegin', html);
  root.remove();
}

async function boot() {
  // Inject config first so language and API base are available
  await injectConfig();

  // Inject panels before initializing the app logic
  await Promise.all([
    injectPartial('left-panel-root', 'partials/left-panel.html'),
    injectPartial('right-panel-root', 'partials/right-panel.html'),
  ]);
  // Now load the app (resolve relative to this module for robustness)
  const mainUrl = new URL('./main.js', import.meta.url).href;
  try {
    await import(mainUrl);
  } catch (err) {
    try {
      const probe = await fetch(mainUrl, { method: 'GET' });
      console.error('Failed to import main module', { url: mainUrl, status: probe.status, contentType: probe.headers.get('content-type') });
    } catch (probeErr) {
      console.error('Failed to fetch main module', { url: mainUrl, error: probeErr });
    }
    throw err;
  }
  try {
    // Re-apply i18n to cover injected markup
    i18n.setLang(window.appConfig?.lang || 'en');
    i18n.apply(document);
  } catch {}
}

boot().catch(err => {
  console.error(err);
  alert(err?.message || String(err));
});
import { i18n } from './core/i18n.js';

async function injectConfig() {
  await injectPartial('config-root', 'partials/config.html');
  const defaults = {
    lang: 'en',
    userId: null,
    apiEndpoints: {},
  };
  let cfg = { ...defaults };
  try {
    const el = document.getElementById('app-config');
    if (el) {
      const parsed = JSON.parse(el.textContent || '{}');
      if (parsed && typeof parsed === 'object') {
        cfg = { ...cfg, ...parsed };
      }
    }
  } catch {}
  if (typeof cfg.userId === 'string') {
    const n = parseInt(cfg.userId, 10);
    cfg.userId = Number.isFinite(n) ? n : null;
  }

  // Merge with localStorage config
  try {
    const storedConfig = localStorage.getItem('graphConfig');
    if (storedConfig) {
      const parsedStoredConfig = JSON.parse(storedConfig);
      if (parsedStoredConfig && typeof parsedStoredConfig === 'object') {
        cfg = { ...cfg, ...parsedStoredConfig };
      }
    }
  } catch (err) {
    console.error('Error reading graphConfig from localStorage', err);
  }

  window.appConfig = cfg;
  // Apply language and direction early
  const v = cfg.lang || 'en';
  const root = document.documentElement;
  root.setAttribute('lang', v);
  root.setAttribute('dir', v === 'ar' ? 'rtl' : 'ltr');
}
