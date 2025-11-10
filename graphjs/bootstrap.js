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
  // Inject panels before initializing the app logic
  await Promise.all([
    injectPartial('left-panel-root', 'partials/left-panel.html'),
    injectPartial('right-panel-root', 'partials/right-panel.html'),
  ]);
  // Now load the app
  await import('./main.js');
}

boot().catch(err => {
  console.error(err);
  alert(err?.message || String(err));
});

