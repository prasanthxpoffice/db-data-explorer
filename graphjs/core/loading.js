let pending = 0;
const overlay = document.getElementById('loading-overlay');
let showDelayId = null;

function update() {
  if (!overlay) return;
  if (pending > 0) {
    if (showDelayId == null && overlay.hidden) {
      showDelayId = setTimeout(() => {
        try { overlay.hidden = false; document.body.setAttribute('aria-busy', 'true'); } catch {}
        showDelayId = null;
      }, 200);
    }
  } else {
    if (showDelayId != null) { clearTimeout(showDelayId); showDelayId = null; }
    try { overlay.hidden = true; document.body.removeAttribute('aria-busy'); } catch {}
  }
}

export function showLoading() {
  pending++;
  update();
}

export function hideLoading() {
  pending = Math.max(0, pending - 1);
  update();
}

export async function withLoading(promise) {
  try {
    showLoading();
    return await promise;
  } finally {
    hideLoading();
  }
}
