const apiBase = location.protocol === 'file:' ? 'http://localhost:3000' : '';

export async function getViews() {
  const res = await fetch(`${apiBase}/api/views`);
  if (!res.ok) throw new Error(`Views API ${res.status}`);
  return res.json();
}

export async function getSeedColumns(viewIds = [], lang = 'en') {
  const qs = new URLSearchParams();
  if (viewIds.length) qs.set('viewIds', viewIds.join(','));
  qs.set('lang', lang);
  const res = await fetch(`${apiBase}/api/seed/columns?${qs.toString()}`);
  if (!res.ok) throw new Error(`seed columns ${res.status}`);
  return res.json();
}

export async function getSeedValues({ col, term = '', viewIds = [], lang = 'en' }) {
  const qs = new URLSearchParams({ col, lang, pageSize: '30' });
  if (term) qs.set('term', term);
  if (viewIds.length) qs.set('viewIds', viewIds.join(','));
  const res = await fetch(`${apiBase}/api/seed/values?${qs.toString()}`);
  if (!res.ok) throw new Error(`seed values ${res.status}`);
  return res.json();
}

export async function traverseStepMulti(payload) {
  const res = await fetch(`${apiBase}/api/traverseStepMulti`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`API ${res.status} ${await res.text()}`);
  return res.json(); // { edges, nextFrontier }
}
