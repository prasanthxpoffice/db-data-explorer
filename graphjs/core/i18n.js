// Lightweight offline i18n helper for static UI strings
export const i18n = {
  lang: 'en',
  dict: {
    en: {
      app_title: 'Graph DB Data Explorer',
      data_source: 'Data Source',
      entity: 'Entity',
      entity_value: 'Entity Value',
      value_placeholder: 'Value (e.g. 1)',
      add: 'Add',
      clear: 'Clear',
      add_from_selection: 'Add From Selection',
      show: 'Show',
      selection: 'Selection',
      legends_type: 'Legends (Type)',
      search: 'Search',
      search_placeholder: 'label / col / val',
      options: 'Options',
      depth: 'Depth',
      max_conn: 'Max Connections per Node',
      language: 'Language',
      layout: 'Layout',
      animate: 'Animate',
      min_edge_support: 'Min Edge Support',
      hide_leaves: 'Hide Leaves',
      highlight_hubs: 'Highlight Hubs',
      hubs_deg_ge: '(deg >=)',
      max_edges_per_node: 'Max Edges / Node',
      label_threshold: 'Label Threshold',
      stop_node_expand: 'Stop Node Expand',
      tidy: 'Tidy',
      clear_graph: 'Clear Graph',
      export_png: 'Export PNG',
      no_node_selected: 'No node selected.',
      column: 'Column',
      value: 'Value',
      type: 'Type',
      degree: 'Degree',
      set_start: 'Set Start',
      set_end: 'Set End',
      show_shortest_path: 'Show Shortest Path',
      clear_path: 'Clear Path',
      path_start: 'Path Start',
      path_end: 'Path End',
      stay_on_path: 'Stay on Path',
      select_views: 'Select views',
      selected_prefix: 'Selected:',
      alert_pick_entity_value: 'Pick an Entity and enter a value.',
      alert_select_nodes: 'Select node(s) in the graph to add.',
      no_active_columns: 'No active columns',
    },
    ar: {
      app_title: 'مستكشف بيانات قاعدة البيانات البيانية',
      data_source: 'مصدر البيانات',
      entity: 'الكيان',
      entity_value: 'قيمة الكيان',
      value_placeholder: 'القيمة (مثال: 1)',
      add: 'إضافة',
      clear: 'مسح',
      add_from_selection: 'إضافة من التحديد',
      show: 'عرض',
      selection: 'التحديد',
      legends_type: 'الأساطير (النوع)',
      search: 'بحث',
      search_placeholder: 'وسم / عمود / قيمة',
      options: 'الخيارات',
      depth: 'العمق',
      max_conn: 'أقصى اتصالات لكل عقدة',
      language: 'اللغة',
      layout: 'التخطيط',
      animate: 'تحريك',
      min_edge_support: 'أدنى دعم للحافة',
      hide_leaves: 'إخفاء الأوراق',
      highlight_hubs: 'إبراز المحاور',
      hubs_deg_ge: '(الدرجة ≥)',
      max_edges_per_node: 'أقصى حواف/عقدة',
      label_threshold: 'حد التسمية',
      stop_node_expand: 'إيقاف توسيع العقدة',
      tidy: 'ترتيب',
      clear_graph: 'مسح الرسم',
      export_png: 'تصدير PNG',
      no_node_selected: 'لا توجد عقدة محددة.',
      column: 'العمود',
      value: 'القيمة',
      type: 'النوع',
      degree: 'الدرجة',
      set_start: 'تعيين البداية',
      set_end: 'تعيين النهاية',
      show_shortest_path: 'عرض أقصر مسار',
      clear_path: 'مسح المسار',
      path_start: 'بداية المسار',
      path_end: 'نهاية المسار',
      stay_on_path: 'البقاء على المسار',
      select_views: 'اختر المشاهد',
      selected_prefix: 'المحدد:',
      alert_pick_entity_value: 'اختر كيانًا وأدخل قيمة.',
      alert_select_nodes: 'حدد عقدة/عقدًا في الرسم للإضافة.',
      no_active_columns: 'لا توجد أعمدة نشطة',
    },
  },
  setLang(v){ this.lang = v || 'en'; },
  t(key){
    const pack = this.dict[this.lang] || this.dict.en;
    return (pack && pack[key]) || (this.dict.en && this.dict.en[key]) || key;
  },
  apply(root=document){
    const r = root instanceof Document ? root : document;
    r.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (!key) return;
      el.textContent = this.t(key);
    });
    r.querySelectorAll('[data-i18n-attr]').forEach(el => {
      const mapAttr = el.getAttribute('data-i18n-attr'); // e.g., "placeholder:value_placeholder,title:app_title"
      if (!mapAttr) return;
      mapAttr.split(',').forEach(pair => {
        const [attr, key] = pair.split(':').map(s=>s.trim());
        if (attr && key) el.setAttribute(attr, this.t(key));
      });
    });
  }
};

