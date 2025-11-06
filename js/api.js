// API module: centralizes all server calls.
(function(){
  window.App = window.App || {};
  const base = (location.protocol === 'file:') ? 'http://localhost:3000' : '';

  async function httpGet(path, params){
    const qs = params ? `?${new URLSearchParams(params).toString()}` : '';
    const res = await fetch(`${base}${path}${qs}`);
    if(!res.ok){
      const txt = await res.text().catch(()=>res.statusText);
      throw new Error(`${path} ${res.status} ${txt}`);
    }
    return res.json();
  }

  async function httpPost(path, body){
    const res = await fetch(`${base}${path}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body||{})
    });
    if(!res.ok){
      const txt = await res.text().catch(()=>res.statusText);
      throw new Error(`${path} ${res.status} ${txt}`);
    }
    return res.json();
  }

  const Api = {
    base,
    getViews: () => httpGet('/api/views'),
    getSeedColumns: (viewIds, lang) => {
      const params = {};
      if (Array.isArray(viewIds) && viewIds.length) params.viewIds = viewIds.join(',');
      if (lang) params.lang = lang;
      return httpGet('/api/seed/columns', params);
    },
    getSeedValues: (col, term, viewIds, lang, pageSize=30) => {
      const params = { col, pageSize: String(pageSize) };
      if (term) params.term = term;
      if (Array.isArray(viewIds) && viewIds.length) params.viewIds = viewIds.join(',');
      if (lang) params.lang = lang;
      return httpGet('/api/seed/values', params);
    },
    traverseStepMulti: (payload) => httpPost('/api/traverseStepMulti', payload)
  };

  App.Api = Api;
})();
