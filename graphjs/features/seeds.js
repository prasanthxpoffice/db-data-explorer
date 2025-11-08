import { state } from "../core/state.js";
import { getSeedColumns, getSeedValues } from "../core/api.js";
import { qs } from "../core/dom.js";
import { getSelectedViewIds } from "./views.js";
import { cy } from "../core/cy-init.js";

function renderSeedList() {
  const ul = qs("#seed-list");
  ul.innerHTML = "";
  state.seeds.forEach((s, idx) => {
    const li = document.createElement("li");
    li.className = "hint";
    li.style.margin = "2px 0";
    const disp = s.label ?? s.val;
    const colName = s.colLabel || s.col;
    li.textContent = `${colName} = ${disp}`;
    const btn = document.createElement("button");
    btn.textContent = "x";
    btn.style.marginLeft = "8px";
    btn.addEventListener("click", () => {
      state.seeds.splice(idx, 1);
      renderSeedList();
    });
    li.appendChild(btn);
    ul.appendChild(li);
  });
  // Toggle related action buttons visibility based on presence of seeds
  const hasSeeds = Array.isArray(state.seeds) && state.seeds.length > 0;
  const clearBtn = qs('#clear-seeds');
  const runBtn = qs('#run');
  if (clearBtn) clearBtn.style.display = hasSeeds ? '' : 'none';
  if (runBtn) runBtn.style.display = hasSeeds ? '' : 'none';
}

export async function refreshSeedColumns() {
  try {
    const viewIds = getSelectedViewIds();
    const lang = qs("#lang").value || "en";
    const cols = await getSeedColumns(viewIds, lang);
    const sel = qs("#seed-col-select");
    sel.innerHTML = "";
    if (Array.isArray(cols) && cols.length) {
      const def = document.createElement("option");
      def.value = "";
      def.textContent = "--";
      def.selected = true;
      sel.appendChild(def);
    }
    (cols || []).forEach((item) => {
      const opt = document.createElement("option");
      if (item && typeof item === "object" && "id" in item) {
        opt.value = String(item.id);
        opt.textContent = String(item.text ?? item.id);
      } else {
        const c = String(item ?? "");
        opt.value = c;
        opt.textContent = c;
      }
      sel.appendChild(opt);
    });
    if (!sel.options.length) {
      const opt = document.createElement("option");
      opt.value = "";
      opt.textContent = "— No active columns —";
      opt.disabled = true;
      opt.selected = true;
      sel.appendChild(opt);
    }
  } catch (e) {
    // Fallback: infer from current graph nodes
    const sel = qs("#seed-col-select");
    const seen = new Set();
    sel.innerHTML = "";
    cy.nodes().forEach((n) => {
      const c = n.data("col");
      if (c && !seen.has(c)) {
        seen.add(c);
        const opt = document.createElement("option");
        opt.value = opt.textContent = c;
        sel.appendChild(opt);
      }
    });
    if (sel.options.length) {
      const def = document.createElement("option");
      def.value = "";
      def.textContent = "--";
      def.selected = true;
      sel.insertBefore(def, sel.firstChild);
    } else {
      const opt = document.createElement("option");
      opt.value = "";
      opt.textContent = "No active columns";
      opt.disabled = true;
      opt.selected = true;
      sel.appendChild(opt);
    }
  }
  refreshSeedValuesSuggestions();
}

let seedValTimer = null;
export async function refreshSeedValuesSuggestions() {
  clearTimeout(seedValTimer);
  seedValTimer = setTimeout(async () => {
    try {
      const sel = qs("#seed-col-select");
      const col = sel && sel.value ? sel.value : "";
      const term = (qs("#seed-val").value || "").trim();
      if (!col) return;
      const viewIds = getSelectedViewIds();
      const lang = qs("#lang").value || "en";
      const payload = await getSeedValues({ col, term, viewIds, lang });
      const list = qs("#seedVals-list");
      list.innerHTML = "";
      (payload.items || []).forEach((it) => {
        const o = document.createElement("option");
        if (it && typeof it === "object" && "id" in it) {
          o.value = String(it.text ?? it.id); // show label
          o.setAttribute("data-id", String(it.id)); // keep underlying id
        } else {
          const v = String(it ?? "");
          o.value = v;
        }
        list.appendChild(o);
      });
    } catch {}
  }, 200);
}

export function initSeedsUI() {
  qs("#add-seed").addEventListener("click", () => {
    const sel = qs("#seed-col-select");
    const col = sel && sel.value ? sel.value.trim() : "";
    const colLabel = sel && sel.selectedIndex >= 0 ? sel.options[sel.selectedIndex].textContent || col : col;
    const valInput = qs("#seed-val");
    const typed = (valInput.value || "").trim();
    if (!col || !typed) {
      alert("Pick a Entity and enter a value.");
      return;
    }
    let idVal = typed;
    let label = typed;
    const list = qs("#seedVals-list");
    if (list) {
      const match = Array.from(list.children).find((o) => o.value === typed);
      if (match && match.getAttribute) {
        const d = match.getAttribute("data-id");
        if (d) idVal = d;
      }
    }
    const key = `${col}|${idVal}`;
    const exists = state.seeds.some((s) => `${s.col}|${String(s.val)}` === key);
    if (!exists) state.seeds.push({ col, colLabel, val: idVal, label });
    valInput.value = "";
    renderSeedList();
  });

  qs("#add-seed-selected").addEventListener("click", () => {
    const sel = cy.nodes(":selected");
    if (!sel || !sel.length) {
      alert("Select node(s) in the graph to add.");
      return;
    }
    sel.forEach((n) => {
      const col = n.data("col");
      const val = String(n.data("val"));
      const colLabel = col; // derive purely from selected node
      const label = (n.data("label") ?? val).toString();
      if (col && val) {
        const key = `${col}|${val}`;
        const exists = state.seeds.some((s) => `${s.col}|${String(s.val)}` === key);
        if (!exists) state.seeds.push({ col, colLabel, val, label });
      }
    });
    renderSeedList();
  });

  qs("#clear-seeds").addEventListener("click", () => {
    state.seeds = [];
    renderSeedList();
  });
  // Also clear seeds when the full graph Clear button is used
  qs("#clear").addEventListener("click", () => {
    state.seeds = [];
    renderSeedList();
  });
  qs("#seed-val").addEventListener("input", refreshSeedValuesSuggestions);
  const seedColSelect = qs("#seed-col-select");
  if (seedColSelect)
    seedColSelect.addEventListener("change", () => {
      qs("#seed-val").value = "";
      refreshSeedValuesSuggestions();
    });

  renderSeedList();
}
