import { withLoading } from './loading.js';

function endpoint(name) {
  const cfg = (typeof window !== 'undefined' ? window.appConfig : null) || {};
  const eps = cfg.apiEndpoints || {};
  const ep = eps && eps[name];
  if (typeof ep === 'string' && ep.trim()) return ep.trim().replace(/\/$/, '');
  throw new Error(`Missing API endpoint configuration for '${name}'. Set appConfig.apiEndpoints.${name} in partials/config.html`);
}

function withQuery(url, qs) {
  if (!qs) return url;
  const sep = url.includes('?') ? '&' : '?';
  return url + sep + (qs instanceof URLSearchParams ? qs.toString() : String(qs));
}

export async function getViews() {
  const url = endpoint('views');
  const res = await withLoading(fetch(url));
  if (!res.ok) throw new Error(`Views API ${res.status}`);
  return res.json();
}

export async function getSeedColumns(viewIds = [], lang = 'en') {
  const qs = new URLSearchParams();
  if (viewIds.length) qs.set('viewIds', viewIds.join(','));
  qs.set('lang', lang);
  const url = withQuery(endpoint('seedColumns'), qs);
  const res = await withLoading(fetch(url));
  if (!res.ok) throw new Error(`seed columns ${res.status}`);
  return res.json();
}

export async function getSeedValues({ col, term = '', viewIds = [], lang = 'en' }) {
  const qs = new URLSearchParams({ col, lang, pageSize: '30' });
  if (term) qs.set('term', term);
  if (viewIds.length) qs.set('viewIds', viewIds.join(','));
  const url = withQuery(endpoint('seedValues'), qs);
  const res = await withLoading(fetch(url));
  if (!res.ok) throw new Error(`seed values ${res.status}`);
  return res.json();
}

export async function traverseStepMulti(payload) {
  const url = endpoint('traverseStepMulti');
  const res = await withLoading(fetch(url, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  }));
  if (!res.ok) throw new Error(`API ${res.status} ${await res.text()}`);
  return res.json(); // { edges, nextFrontier }
}
