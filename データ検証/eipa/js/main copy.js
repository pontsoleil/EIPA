var pane = {
      1: null,
      2: null
    },
    UBL_IVC, UBL_CNT, UBL_CBC, UBL_CAC,
    CII_CII, CII_ABIE, CII_CCT, CII_QDT, CII_UDT,
    EnMap, UblMap, PeppolMap, CiiMap, SmeMap;
;
// -----------------------------------------------------------------
// TAB MENU
//
function setFrame(num, frame) {
  var frame, match, root_pane, id, base;
  var component, content;
  var root_pane, frames, children, child, i;

  pane[num] = frame;

  $('#component-'+num+' .split-pane').splitPane('lastComponentSize', 0);

  $('#tab-'+num+' .tablinks').removeClass('active');
  $('#tab-'+num+' .tablinks.'+frame).addClass('active');

  root_pane = $('#root');
  root_pane.removeClass('d-none');
  // save current content to backup.
  // top
  component = $('#component-'+num);
  if (component.children().length > 0) {
    child = component.children();
    if (child.length > 0) {
      id = child.attr('id');
      match = id.match(/^(.*)-frame$/);
      base = $('#'+match[1]+'-container');
      base.append(child);
    }
  }
  component.empty();
  content = $('#'+frame+'-frame');
  component.append(content);
}
// -----------------------------------------------------------------
// Formatting function for row details
//
var H1 = 30, H2 = 70, Q1 = 25, Q2 = 25, Q3 = 25, Q4 = 25;
function format(d) { // d is the original data object for the row
  if (!d) { return null; }
  var html;
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%; padding-left:16px;">'+
  '<colgroup>'+
  '<col span="1" style="width: '+Q1+'%;">'+
  '<col span="1" style="width: '+Q2+'%;">'+
  '<col span="1" style="width: '+Q3+'%;">'+
  '<col span="1" style="width: '+Q4+'%;">'+
  '</colgroup>'+
  (d.Definition ? '<tr><td colspan="4">'+d.Definition+'</td><tr>' : '')+
  '<tr><td>'+d.UniqueID+'</td><td colspan="3">'+d.DictionaryEntryName+'</td></tr>'+
  (d.Publicationcomments
    ? '<tr><td style="font-size:smaller">Publication Comments:</td><td colspan="3">'+d.Publicationcomments+'</td></tr>'
    : '')+
  (d.AssociatedObjectClass
    ? '<tr><td style="font-size:smaller">Associated Object Class:</td>'+
      '<td colspan="3">'+
      (d.AssociatedObjectClassTermQualifier
        ? d.AssociatedObjectClassTermQualifier+'_ '
        : '')+d.AssociatedObjectClass
    : '')+'</td></tr>'+
  (d.QualifiedDataTypeUID
    ?  '<tr><td style="font-size:smaller">Qualified Datatype UID:</td>'+
        '<td colspan="3">'+d.QualifiedDataTypeUID
    : '')+'</td></tr>'+
  (d.BusinessTerm
    ? '<tr><td style="font-size:smaller">Business Term:</td><td colspan="3">'+d.BusinessTerm+'</td></tr>'
    : '')+
  (d.UsageRule
    ? '<tr><td  style="font-size:smaller">Usage Rule:</td><td colspan="3">'+d.UsageRule+'</td></tr>'
    : '')+
  (d.BusinessProcess
    ? '<tr><td style="font-size:smaller">Business Process:</td><td colspan="3">'+d.BusinessProcess+'</td></tr>'
    : '')+
  (d.Product
    ? '<tr><td style="font-size:smaller">Product:</td><td colspan="3" >'+d.Product+'</td></tr>'
    : '')+
  '<tr><td style="font-size:smaller">Industry:</td><td>'+(d.Industry ? d.Industry : '')+'</td>'+
    '<td style="font-size:smaller">region(Geopolitical):</td><td>'+(d.RegionGeopolitical ? +d.RegionGeopolitical : '')+'</td>'+
  '</tr>'+
  '<tr><td style="font-size:smaller">Official Constraints:</td><td>'+(d.OfficialConstraints ? d.OfficialConstraints : '')+'</td>'+
    '<td style="font-size:smaller">Role:</td><td>'+(d.Role ? d.Role : '')+'</td>'+
  '</tr>'+
  (d.SupportingRole
    ? '<tr><td style="font-size:smaller">Supporting Role:</td><td colspan="3">'+d.SupportingRole+'</td></tr>'
    : '')+
  (d.SystemConstraints
    ? '<tr><td style="font-size:smaller">System Constraints:</td><td colspan="3">'+d.SystemConstraints+'</td></tr>'
    : '')+
  (d.Example
    ? '<tr><td style="font-size:smaller">Example:</td><td colspan="3">'+d.Example+'</td></tr>'
    : '')+
  '</table>';
  return html;
}

// -----------------------------------------------------------------
// columns
// -----------------------------------------------------------------
var rgx = RegExp('^(([^_\\.]*)_ )?([^\\.]*)\\. (([^_\\.]*)_ )?([^\\.]*)(\\. (([^_\\.]*)_ )?(.*))?$');
var rgx_COL_ObjectclassTermQualifier = 2;
var rgx_COL_ObjectClassTerm = 3;
var rgx_COL_PropertyTermQualifier = 5;
var rgx_COL_PropertyTerm = 6;
var rgx_COL_DatatypeQualifier = 9;
var rgx_COL_RepresentationTerm  = 10;
function splitLC3(letters) {
  var i,
      letter = letters[0],
      words = letter,
      upperCase = letter === letter.toUpperCase();
  for (var i = 1; i < letters.length; i++) {
    letter = letters[i];
    if (!upperCase) {
      if (letter === letter.toUpperCase()) {
        upperCase = true;
        words += ' '+letter;
      } else {
        upperCase = false;
        words += letter;
      }
    }
    else {
      upperCase = (letter === letter.toUpperCase());
      words += letter;
    }
  }
  return words;
}
function renderNameByNum(num, name) {
  if (!name) {
    return '';
  }
  var num = '' + num;
  var depth = (num.match(/\./g) || []).length;
  var prefix = '';
  for (var i = 0; i < depth; i++) {
    prefix += '+';
  }
  return (prefix ? prefix+' ' : '')+name;//splitLC3(name);
}
function renderDescription(description) {
  if (!description) {
    return '';
  }
  else if (description.length > 72) {
    description = description.substr(0, 72)+'...';
  }
  return description;
}
// -----------------------------------------------------------------
COL_DictionaryEntryName = 6;
COL_ObjectClassTerm = 7;
var columns = [
  { 'width': '2%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'width': '8%',
    'data': 'Kind' }, // 1
  { 'width': '35%',
    'data': 'name'/*,
    'render': function(data, type, row) {
    return renderName(row); }*/}, // 2
  { 'width': '49%',
    'data': 'datatype'/*,
    'render': function(data, type, row) {
    return renderDatatype(row); }*/}, // 3
  { 'width': '4%',
    'data': 'Cardinality' }, // 4
  { 'width': '2%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 5
  { 'data': 'DictionaryEntryName' }, // 6-
  { 'data': 'ObjectClassTerm' } // 7-
];
var columnDefs = [
  { 'searchable': false, 'targets': [0, 5] },
  { 'visible': false, 'targets': [6, 7] } 
];
// -------------------------------------------------------------------
// Utility
//
function appendByNum(items, item) {
  if (!item.num) {
    return null;
  }
  if (items instanceof Array && item) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].num && item.num === items[i].num) {
        items.splice(i, 1);
        items.push(item);
        return items;
      }
    }
    items.push(item);
    return items;
  }
  return null;
}
// -------------------------------------------------------------------
function removeByNum(items, item) {
  if (!item.num) {
    return null;
  }
  if (items instanceof Array && item) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].num && item.num === items[i].num) {
        items.splice(i, 1);
        return items;
      }
    }
    return items;
  }
  return null;
}
// -------------------------------------------------------------------
var compareNum = function(a, b) {
  var a_arr = a.num.split('_').map(function(v){ return +v; }),
      b_arr = b.num.split('_').map(function(v){ return +v; });
  while (a_arr.length > 0 && b_arr.length > 0) {
    var a_num = a_arr.shift(),
        b_num = b_arr.shift();
    if (a_num < b_num) { return -1; }
    if (b_num < a_num) { return  1; }
  }
  if (b_arr.length > 0) { return -1; }
  if (a_arr.length > 0) { return  1; }
  return 0;
}
// -------------------------------------------------------------------
function filterRoot(table_id) {
  var table, rows;
  table = $(table_id).DataTable();
  rows = [];
  table.data().toArray().forEach(function(v, i) {
    if ('#cii2en' === table_id ||
        '#ubl2en_ivc' === table_id ||
        '#ubl2en_cnt' === table_id) {
      if (v.num.split('_').length < 3) {
        rows.push(v);
      }
    }
    else {
      if ('root' === v.EN_Parent) {
        rows.push(v);
      }
    }
  });

  table.clear();
  table.rows
  .add(rows)
  .draw();

  if ('#cii2en' === table_id ||
      '#ubl2en_ivc' === table_id ||
      '#ubl2en_cnt' === table_id) {
    $(table_id +' tbody tr')[0].classList.add('expanded');
  }
}
// -------------------------------------------------------------------
function checkDetails(table_id) {
  var table = $(table_id).DataTable(),
      data = table.data(),
      tr_s, tr, // nextSibling,
      row, row_data, num, i, nums,// nextrow, nextrow_data,
      rgx;
  tr_s = $(table_id + ' tbody tr');
  if (data.length > 0) {
    if ('en' === table_id.substr(1, 2)) {
      for (var tr of tr_s) {
        row = table.row(tr);
        row_data = row.data();
        if (row_data.EN_ID.match(/^BT/)) {
          tr.childNodes[0].classList = '';
        }
      }
    }
    else if (table_id.match(/cii/) ||
             table_id.match(/ubl/)) {
      if (table_id.match(/cii/)) {
        nums = CiiNums;
      }
      else if (table_id.match(/en_ivc/)) {
        nums = IvcNums;
      }
      else if (table_id.match(/en_cnt/)) {
        nums = CntNums;
      }
      for (var tr of tr_s) {
        row = table.row(tr);
        row_data = row.data();
        num = row_data.num;
        if (1 == num) { i = 1; }
        else {
          rgx = RegExp('^' + num + '_[^_]+$');
          i = 0;
          for (num of nums) {
            if (num.match(rgx)) { i++; }
          }
        }
        if (i === 0) {
          tr.childNodes[0].classList = '';
        }
      }
    }
  }
}
// -------------------------------------------------------------------
function expandCollapse(table_id, map, tr) {
  var table,
      row, row_data, rows, rows_, id, i, 
      res,
      collapse = null,
      expand = null,
      v, rgx;

  function isExpanded(rows, num) {
    var expanded = false,
        i, rgx, count = 0;
    if ('en' === table_id.substr(1, 2) ||
        'cii' === table_id.substr(1, 3) ||
        'ubl' === table_id.substr(1, 3)) {
      rgx = RegExp('^' + num + '_[^_]+$')
      for (i = 0; i < rows.length; i++) {
        num = rows[i].num;
        if (num.match(rgx)) {
          expanded = num;
          break;
        }
      }
    }
    else {
      return null;
    }
    return expanded;
  }
  
  table = $(table_id).DataTable();
  row = table.row(tr);
  row_data = row.data();
  if (!row_data) { return; }
  rows = [];
  rows_ = table.data();
  for (i = 0; i < rows_.length; i++) {
    row = rows_[i];
    rows.push(row);
  }

  res = isExpanded(rows_, row_data.num);
  if (res) {
    collapse = row_data.num;
  }
  else {
    expand = row_data.num;
  }
  if (collapse) { // collapse
    tr.removeClass('expanded');
    removeByNum(expandedRows, row_data);
    collapsedRows = [row_data];
    rgx = RegExp('^' + collapse + '_');
    rows = rows.filter(function(row) {
      if (row.num.match(rgx)) {
        removeByNum(expandedRows, row);
        return false;
      }
      return true;
    });
  }
  else if (expand) { // expand
    tr.addClass('expanded');
    collapsedRows = [];
    expandedRows = [row_data];
    rgx = RegExp('^' + expand + '_[^_]+$');
    map.forEach(function(value, key) {
      if (value.num.match(rgx)) {
        v = JSON.parse(JSON.stringify(value));
        appendByNum(rows, v);
      }
    });
  }
  else {
    return;
  }

  rows.sort(compareNum);

  table.clear();
  table.rows
  .add(rows)
  .draw();

  var data = table.data(),
    tr_s, tr, nextSibling,
    row, row_data, nextrow, nextrow_data,
    rgx;
  if (data.length > 0) {
    var tr_s = $(table_id + ' tbody tr');
    for (var tr of tr_s) {
      row = table.row(tr);
      row_data = row.data();
      nextSibling = tr.nextSibling;
      if (nextSibling) {
        nextrow = table.row(nextSibling);
        nextrow_data = nextrow.data();
        rgx = RegExp('^' + row_data.num + '_[^_]+$');
        if (nextrow_data.num.match(rgx)) {
          tr.classList.add('expanded');
        }
      }
    }
  }
}
// -------------------------------------------------------------------
var initModule = function () {
  // -----------------------------------------------------------------
  function tableInit(table_id, json) {
    var map,
        data, i, item, level, seq, num,
        idxLevel = [],
        numMap = new Map();
    data = json.data;
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      level = item.EN_Level - 1;
      num = '' + seq;
      if (level > 0) {
        num = idxLevel[level - 1] + '_' + num;
      }
      while (idxLevel.length - 1 > level) {
        idxLevel.pop();
      }
      idxLevel[level] = num;
      numMap.set(seq, num);
    }
    map = new Map();
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      item.seq = seq;
      num = numMap.get(seq);
      item.num = num;
      map.set(seq, item);
    }
    filterRoot(table_id);
    checkDetails(table_id);
    return map;
  }
  function tableInit2(table_id, json) {
    var map, nums,
        data, item,
        seq, paths, padding = '', wk_path = '',
        level, num, name, term, i,
        rows = [],
        idxLevel = [];
    data = json.data;
    map = new Map();
    nums = [];
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = i;
      item.seq = seq;
      item.EN_Level = item.EN_Level || '';
      item.EN_Card = item.EN_Card || '';
      item.EN_DT = item.EN_DT || '';
      item.EN_Desc = item.EN_Desc || '';
      num = '' + seq;
      paths = item.Path.split('/');
      if (paths.length > 1) {
        for (var i = 1; i < paths.length; i++) {
          wk_path += padding + paths[i] + '<br>';
          padding += '&nbsp;&nbsp;&nbsp;';
        }
        item.Paths = wk_path;
        padding = '';
        wk_path = '';
        paths.shift();
        level = paths.length - 1;
        name = '';
        for (i = 0; i < level; i++) { name += '+'; }
        if (level > 0) { name += ' '; }
        term = paths[level];
        name += term;
        item.Path = name;
        if (level > 0) {
          num = idxLevel[level - 1] + '_' + num;
        }
        while (idxLevel.length - 1 > level) {
          idxLevel.pop();
        }
        idxLevel[level] = num;
        nums.push(num);
        item.num = num;
        rows.push(item);
        map.set(seq, item);
      }
    }
    switch (table_id) {
      case '#cii2en':
        Cii2EnMap = map;
        CiiNums = nums;
        break;
      case '#ubl2en_ivc':
        Ubl2EnIvcMap = map;
        IvcNums = nums;
        break;
      case '#ubl2en_cnt':
        Ubl2EnCntMap = map;
        CntNums = nums;
        break;
    }
    return rows;
  }
  function tableInit3(table_id) {
    var data, map, nums, item, 
        ref, match, type, element, children, name, base,
        seq, num, idxLevel = [], rows = [];

    function parse(num, data) {
      console.log('num:' + num, data);
      if (!data || 0 === data.length) { return null; }
      for (var i = 0; i < data.length; i++) {
        item = data[i];
        var level = num && num.split('_').length - 1 || 0;
        ref = item['@ref'];
        match = ref.match(/^(c[ab]c):(.*)$/);
        if (match) {
          seq++;
          item.seq = seq;
          if (level > 0) {
            num = idxLevel[level - 1] + '_' + num;
          }
          while (idxLevel.length - 1 > level) {
            idxLevel.pop();
          }
          idxLevel[level] = num;
          nums.push(num);
          item.num = num;
          item.ObjectClassTerm = item.ObjectClassTerm || '';
          switch (match[1]) {
            case 'cac':
              item.Kind = 'A';
              type = UBL_CAC.element[match[2]]['@type'];
              element = UBL_CAC.type[type];
              item.name = element['@name'];
              item.datatype = type;
              item.children = element.element;
              // if (children && children.length > 1) {
              //   parse(num, children);
              // }
              break;
            case 'cbc':
              item.Kind = 'B';
              type = UBL_CBC.element[match[2]]['@type'];
              element = UBL_CBC.type[type];
              item.name = element['@name'];
              item.datatype = element['@base'];
              break;
          }
          rows.push(item);
          map.set(seq, item);
        }
      }
    }

    map = new Map();
    switch(table_id) {
      case '#ubl':
        data = UBL_IVC.element;
        map = new Map();
        nums = [];
        level = 0;
        seq = 0;
        num = '' + seq;

        parse(num, data);

        console.log(rows);
        
        en_table.clear();
        en_table.rows
        .add(rows)
        .draw();
        break;
      case '#cii':

        break;
    }
  }
  // EN
  en_table = $('#en').DataTable({
    'columns': columns,
    'columnDefs': columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      // checkDetails('#en');
    }  
  });
  // UBL
  ubl_table = $('#ubl').DataTable({
    'columns': columns,
    'columnDefs': columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      // checkDetails('#ubl');
    }  
  });
  // CII
  cii_table = $('#cii').DataTable({
    'columns': columns,
    'columnDefs': columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#cii');
    }  
  });
  // --- Ajax --------------------------------------------------------
  // UBL 2.1
  var ubl_count = 4;
  // 1 UBL_IVC 
  ajaxRequest('data/ubl2.1/ivc.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      UBL_IVC = JSON.parse(res);
      ubl_count--;
      if (0 === ubl_count) {
        tableInit3('#ubl');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 2 UBL_CNT 
  ajaxRequest('data/ubl2.1/cnt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      UBL_CNT = JSON.parse(res);
      ubl_count--;
      if (0 === ubl_count) {
        tableInit3('#ubl');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 3 UBL_CBC 
  ajaxRequest('data/ubl2.1/cbc.json', null, 'GET', 10000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      UBL_CBC = {
        type: {},
        element: {}
      }
      json.complexType.forEach(function(v) {
        UBL_CBC.type[v['@name']] = v; 
      });
      json.element.forEach(function(v) {
        UBL_CBC.element[v['@name']] = v; 
      });
      ubl_count--;
      if (0 === ubl_count) {
        tableInit3('#ubl');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 4 UBL_CAC 
  ajaxRequest('data/ubl2.1/cac.json', null, 'GET', 10000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      UBL_CAC = {
        type: {},
        element: {}
      }
      json.complexType.forEach(function(v) {
        UBL_CAC.type[v['@name']] = v; 
      });
      json.element.forEach(function(v) {
        UBL_CAC.element[v['@name']] = v; 
      });
      ubl_count--;
      if (0 === ubl_count) {
        tableInit3('#ubl');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // -----------------------------------------------------------------
  // UN/CEFACT CII
  var cii_count = 5;
  // 1 CII_CII 
  ajaxRequest('data/cii/cii.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      CII_CII = {
        complexType: {},
        element: {}
      }
      json.complexType.forEach(function(v) {
        CII_CII.complexType[v['@name']] = v; 
      });
      json.element.forEach(function(v) {
        CII_CII.element[v['@name']] = v; 
      });
      cii_count--;
      if (0 === cii_count) {
        tableInit3('#cii');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 2 CII_ABIE
  ajaxRequest('data/cii/abie.json', null, 'GET', 10000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      CII_ABIE = {
        complexType: {},
        element: {}
      }
      json.complexType.forEach(function(v) {
        CII_ABIE.complexType[v['@name']] = v; 
      });
      json.element.forEach(function(v) {
        CII_ABIE.element[v['@name']] = v; 
      });
      cii_count--;
      if (0 === cii_count) {
        tableInit3('#cii');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 3 CII_CCT
  ajaxRequest('data/cii/cct.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      CII_CCT = {
        complexType: {}
      }
      json.complexType.forEach(function(v) {
        CII_CCT.complexType[v['@name']] = v; 
      });
      cii_count--;
      if (0 === cii_count) {
        tableInit3('#cii');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 4 CII_QDT
  ajaxRequest('data/cii/qdt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      CII_QDT = {
        complexType: {}
      };
      json.complexType.forEach(function(v) {
        CII_QDT.complexType[v['@name']] = v; 
      });
      cii_count--;
      if (0 === cii_count) {
        tableInit3('#cii');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // 5 CII_UDT
  ajaxRequest('data/cii/udt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      CII_UDT = {
        complexType: {},
        simpleType: {}
      }
      json.complexType.forEach(function(v) {
        CII_UDT.complexType[v['@name']] = v; 
      });
      json.simpleType.forEach(function(v) {
        CII_UDT.simpleType[v['@name']] = v; 
      });
      cii_count--;
      if (0 === cii_count) {
        tableInit3('#cii');
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // -----------------------------------------------------------------
  // Add event listener for opening and closing info
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = en_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      row.child(en_format(row.data(), 'cii')).show(); tr.addClass('shown');
    }
  });
  // -----------------------------------------------------------------
  // Add event listener for opening and closing detail records
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^' + num + '_[^_]+$'),
        i = 0;
    for (num of EnNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#en', EnMap, tr);      
    }
  });

  setFrame(1, 'ubl');
  // setFrame(2, 'cii');
}