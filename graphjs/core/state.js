// Centralized mutable state (replaces globals)
export const state = {
  // graph
  seeds: [], // [{ col, val, label?, color?, type?, colLabel? }]
  currentFrontier: [],
  perViewExclude: [],        // [{ ViewID, col, val }]
  perViewExcludeSet: new Set(),

  // views
  viewSelected: new Set(),   // Set<number>
  availableViews: [],        // [{ id, nameEn, nameAr, descriptionEn, descriptionAr }]

  // UI options
  minSupport: 1,
  hideLeaves: false,
  hubDeg: 6,
  labelHideThreshold: 1500,
  currentFanoutLimit: null,  // number | null
  typeVisibility: new Map(), // Map<string, boolean>
  typeColor: new Map(),      // Map<string, string>

  // search
  searchTerms: [],
  searchMatches: null,
  searchBlinkInterval: null,

  // path
  pathStartId: null,
  pathEndId: null,
  currentPathEles: null,
  pathTimers: [],
  pathBlinkInterval: null,
  stayOnPath: false,
  
  // misc
  isExpanding: false,
  stopNodeExpand: false,
};
