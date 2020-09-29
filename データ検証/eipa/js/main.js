var x_columns, x_columnDefs,
    en_columns, en_columnDefs,
    en_table, EnMap, EnNums,
    cii_table, CiiMap, CiiNums,
    sme_table, SmeMap, SmeNums,
    ubl_table, UblMap, UblNums,
    expandedRows, collapsedRows,
    datatypeMap = {
      'A': 'Amount',
      'B': 'Binary Object',
      'C': 'Code',
      'D': 'Date',
      'I': 'Identifier',
      'M': 'Numeric',
      'N': 'Normalized String',
      'P': 'Percentage',
      'Q': 'Quantity',
      'S': 'String',
      'T': 'Text',
      'U': 'Unit Price Amount',
      '0': 'Document Reference'
    },
    pane = [],
    UBL_IVC, UBL_CNT, UBL_CBC, UBL_CAC,
    CII_CII, CII_ABIE, CII_CCT, CII_QDT, CII_UDT;

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
/*function lookupCiiType(type) {
  if (!type) { return ''; }
  type = type.trim();
  var str = 'Type: ';
  switch (type) {
    case 'A': str += 'Attribute'; break;
    case 'C': str += 'Composite'; break;
    case 'E': str += 'Element';   break;
    case 'G': str += 'Aggregate'; break;
    case 'S': str += 'Segment';   break;
    default: str += '';
  }
  return str;
}
function lookupUblType(type) {
  if (!type) { return ''; }
  type = type.trim();
  var datatype = 'Type: ' + (datatypeMap[type] || '');
  return datatype;
}
*/
function lookupAlignment(match) {
  if (!match) { return ''; }
  var alignments, alignment, str = '';
  alignments = match.split(',').map(function(a) { return a.trim(); });
  for (alignment of alignments) {
    if (alignment.match(/^SEM/)) {
      str += 'Semantic alignment: ';
      switch (alignment) {
        case 'SEM-1': str += '&nbsp;&nbsp;SOURCE: wider TARGET: smaller'; break;
        case 'SEM-2': str += '&nbsp;&nbsp;SOURCE: smaller TARGET: wider'; break;
        case 'SEM-3': str += '&nbsp;&nbsp;SOURCE: overlap TARGET: overlap'; break;
        case 'SEM-4': str += '&nbsp;&nbsp;SOURCE: match TARGET: no match'; break;
      }
      str += '<br>'
    }
    if (alignment.match(/^STR/)) {
      str += 'Structural alignment: ';
      switch (alignment) {
        case 'STR-1': str += '&nbsp;&nbsp;SOURCE: Hierarchical order one to many TARGET: Hierarchical order many to one'; break;
        case 'STR-2': str += '&nbsp;&nbsp;SOURCE: element on higher level TARGET: element on lower level'; break;
        case 'STR-3': str += '&nbsp;&nbsp;SOURCE: grouping A-B-C TARGET: different grouping'; break;
        case 'STR-4': str += '&nbsp;&nbsp;SOURCE: higher detail TARGET: less detail'; break;
        case 'STR-5': str += '&nbsp;&nbsp;SOURCE: less detail TARGET: higher detail'; break;
      }
      str += '<br>'
    }
    if (alignment.match(/^CAR/)) {
      str += 'Alignment of cardinalities: ';
        switch (alignment) {
        case 'CAR-1': str += '&nbsp;&nbsp;SOURCE: optional TARGET: mandatory'; break;
        case 'CAR-2': str += '&nbsp;&nbsp;SOURCE: mandatory TARGET: optional'; break;
        case 'CAR-3': str += '&nbsp;&nbsp;SOURCE: single TARGET: multiple'; break;
        case 'CAR-4': str += '&nbsp;&nbsp;SOURCE: multiple TARGET: single'; break;
        case 'CAR-5': str += '&nbsp;&nbsp;SOURCE: element missing TARGET: element mandatory'; break;
      }
      str += '<br>'
    }
  }
  return str;
}
function en_format(d) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 35, H2 = 65,
      desc = d.EN_Desc,
      id = d.EN_ID,
      type = d.EN_DT,
      // path = d.Path,
      // type = d.Type || '',
      // card = d.Card,
      // match = d.Match,
      // rule = d.Rules,
      // pathArray,
      // padding = '',
      html = '';
      // wk_path = '',
      // wk_desc;
  // card = card ? '( ' + card + ')' : '';
  // pathArray = path.split('/');
  // wk_path = 'Path: ';
  // for (var i = 1; i < pathArray.length; i++) {
  //   wk_path += padding + pathArray[i] + '<br>';
  //   padding += '&nbsp;&nbsp;&nbsp;';
  // }
  // wk_desc = (match ? lookupAlignment(match) : '') +
  //           (rule ? 'Rule:&nbsp;&nbsp;' + rule : '');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>' +
      '<col style="width:' + H1 + '%;">' +
      '<col style="width:' + H2 + '%;">' +
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">' + id + ' ' + type +'</td>' +
      '<td valign="top">' + desc + '</td>' +
      // '<td valign="top">' +
        // ('cii' === kind ? lookupCiiType(type) : lookupUblType(type)) + 
        // (card ? ' ( ' + card + ' )' : '') + '<br>' +
        // wk_path + wk_desc + '</td>' +
    '</tr>' +
  '</table>';
  return html;
}
function x_format(d, kind) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 35, H2 = 65,
      paths = d.Paths,
      desc_x,
      desc_en = d.EN_Desc || ' ',
      _paths, parent, child, _child,
      match, abie, bbie, base,
      parent_type, den, datatype, cardinality, definition,
      html = '';
  _paths = paths.replaceAll('&nbsp;','').split('<br>');
  parent = _paths[_paths.length - 3];
  child = _paths[_paths.length - 2];
  if ('cii' === kind) {
    if (parent) {
      match = parent.match(/^rsm:(.*)$/);
      if (match) {
        abie = match[1];
        match = child.match(/^rsm:(.*)$/);
        if (match) {
          child = match[1];
        }
        for (var v of CII_CII.complexType.element) {
          if (v['@name'].indexOf(child) >= 0) {
            _child = v;
            break;
          }
        }
      }
    }
    else {
      _child = CII_CII.complexType;
    }
  }
  else {
    match = parent.match(/^cac:(.*)$/);
    if (match) {
      abie = match[1];
      parent_type = UBL_CAC.type[UBL_CAC.element[abie]['@type']];
      _child = parent_type.element.filter(function(el) {
        return child === el['@ref'];
      });
      if (_child.length > 0) {
        _child = _child[0];
      }
    }
    else if ('Invoice' === parent) {
      _child = UBL_IVC.element.filter(function(el) {
        return child === el['@ref'];
      });
      if (_child.length > 0) {
        _child = _child[0];
      }
    }
    else if ('CreditNote' === parent) {
      _child = UBL_CNT.element.filter(function(el) {
        return child === el['@ref'];
      });
      if (_child.length > 0) {
        _child = _child[0];
      }
    }
    match = child.match(/^cbc:(.*)$/);
    if (match) {
      bbie = match[1];
      base = UBL_CBC.type[UBL_CBC.element[bbie]['@type']]['@base'];
    }
  }
  _child = _child ? _child : {};
  den = _child['DictionaryEntryName'] || '';
  datatype = _child['DataType'] || '';
  base = base ? ' ( ' + base + ' ) ' : '';
  cardinality = _child['Cardinality'] || '';
  cardinality = cardinality ? ' ( ' + cardinality + ')' : '';
  definition =  _child['Definition'] || '';
  desc_x = den + cardinality + '<br>' +
            (datatype 
              ? (datatype + base)
              : 'cii' === kind ? '' : 'Aggregate'
            ) + '<br>' +
            definition;
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>' +
      '<col style="width:' + H1 + '%;">' +
      '<col style="width:' + H2 + '%;">' +
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">Path: ' + paths + '</td>' +
      '<td valign="top">' + desc_x + '</td>' +
    '</tr>' +
  '</table>';
  return html;
}
function sme_format(d, kind) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 35, H2 = 65,
      den = d.DictionaryEntryName,
      hdr = d.hdr || '',
      uniqueID = d.uniqueID || '',
      kind = d.kind || '',
      den = d.DictionaryEntryName,
      name = d.name,
      description = d.description,
      cardinality = d.Card,
      comment1 = d.comment1,
      comment2 = d.comment2,
      comment3 = d.comment3,
      update = d.update,
      private = d.private,
      SME = d.SME,
      Invoice = d.Invoice,
      item_name = d.item_name,
      note = d.note,
      cardinality,
      title, desc, memo,
      html = '';
  title = hdr + ' ' + kind + ' ' + uniqueID + (private ? ' 非公開' : '') + '<br>' +
          name + 
          (item_name ? '<br>( ' + item_name + ' )' : '') +
          (note ? '<br>' + note : '');
  cardinality = cardinality ? ' ( ' + cardinality + ')' : '';
  desc = description;
  memo = (comment1 || comment2 || comment3 ? '<br>' : '') +
          (comment1 ? comment1 : '') + (comment2 ? ' ' + comment2 : '') + (comment3 ? ' ' + comment3 : '') +
          (update || private || SME || Invoice ? '<br>' : '') +
          (update ? update : '') + (private ? ' ' + private : '') + (SME ? ' 中小基本必須' : '') + (Invoice ? ' 適格請求書対応' : '');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>' +
      '<col style="width:' + H1 + '%;">' +
      '<col style="width:' + H2 + '%;">' +
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">' + title + '</td>' +
      '<td valign="top">' + desc + memo +'</td>' +
    '</tr>' +
  '</table>';
  return html;
}
// -----------------------------------------------------------------
// EN
function renderBT(row) {
  var term = row.EN_BT,
      card = row.EN_Card,
      level = row.EN_Level,
      res = '';
  for (var i = 0; i < level; i++) {
    res += '+';
  }
  if (level > 0) {
    res += ' ';
  }
  if (card.match(/^1/)) {
    term = '<b>' + term + '</b>';
  }
  res = res += term;
  return res;
}
function renderDatatype(row) {
  var datatype;
  datatype = '' + row.EN_DT;
  datatype = datatype.trim();
  datatype = datatypeMap[datatype] || '';
  return datatype;
}
function renderPath(row) {
  var path, match, parent, element, res = '';
  path = row.Path;
  match = path.match(/([^\/]*)\/([^\/]*)$/);
  if (! match) {
    return path;
  }
  if (match[1]) {
    parent = match[1];
    res = parent + ' / ';
  }
  if (match[2]) {
    element = match[2];
    res += element;
  }
  return res;
}
function renderPath2(row) {
  var path, name = '';
  path = row.Path.split('/');
  if (path.length > 1) {
    path.shift();
    level = path.length - 1;
    for (i = 0; i < level; i++) { name += '+'; }
    if (level > 0) { name += ' '; }
    name += path[level];
  }
  return name;
}

// -------------------------------------------------------------------
en_columns = [
  { 'width': '5%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'data': 'EN_ID' }, // 1
  { 'width': '80%',
    'data': 'EN_BT',
    'render': function(data, type, row) {
      var term = renderBT(row);
      return term; }}, // 2   
  { 'width': '10%',
    'data': 'EN_Card' }, // 3
  { 'width': '5%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 4
];
en_columnDefs = [
  { 'searchable': false, 'targets': [0, 4] },
  { 'visible': false, 'targets': 1 }
];

x_columns = [
  { 'width': '5%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'data': 'num' }, // 1
  { 'width': '80%',
    'data': 'Path',
    'render': function(data, type, row) {
      var path = row.Path || '';
      if (0 === row.seq) { path = '<b>' + path + '</b>'; }
      else if (row.Card && row.Card.match(/^1/)) {
        path = path.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
      }
    return path; }}, // 2
  { 'width': '10%',
    'data': 'Card' }, // 3
  { 'width': '5%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 4
];
x_columnDefs = [
  { 'searchable': false, 'targets': [0, 4] },
  { 'visible': false, 'targets': 1 }
];

sme_columns = [
  { 'width': '5%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'data': 'num' }, // 1
  { 'width': '80%',
    'data': 'DictionaryEntryName',
    'render': function(data, type, row) {
      var den = row.DictionaryEntryName || '';
      if (0 === row.seq) { den = '<b>' + den + '</b>'; }
      else if (row.Card && row.Card.match(/^1/)) {
        den = den.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
      }
      var level = row.num && row.num.split('_') || [];
      level = level.length - 1;
      var prefix = ''
      for (var i = 0; i < level; i++) {
        prefix += '+';
      }
      if (level > 0) {
        den = prefix + ' ' + den;
      }
    return den; } }, // 2
  { 'width': '10%',
    'data': 'Card' }, // 3
  { 'width': '5%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 4
];
sme_columnDefs = [
  { 'searchable': false, 'targets': [0, 4] },
  { 'visible': false, 'targets': 1 }
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
  var a_num = '' + a.num,
      b_num = '' + b.num,
      a_arr = a_num.split('_').map(function(v){ return +v; }),
      b_arr = b_num.split('_').map(function(v){ return +v; });
  while (a_arr.length > 0 && b_arr.length > 0) {
    a_num = a_arr.shift();
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
    if ('#en' === table_id ||
        '#cii' === table_id ||
        '#sme' === table_id ||
        '#ubl' === table_id ||
        '#ubl2en_cnt' === table_id) {
      if (v.num.split('_').length < 3) {
        rows.push(v);
      }
    }
    // else {
    //   if ('root' === v.EN_Parent) {
    //     rows.push(v);
    //   }
    // }
  });

  table.clear();
  table.rows
  .add(rows)
  .draw();

  if ('#cii' === table_id ||
      '#ubl' === table_id) {
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
             table_id.match(/ubl/) ||
             table_id.match(/sme/)) {
      if (table_id.match(/cii/)) {
        nums = CiiNums;
      }
      else if (table_id.match(/ubl/)) {
        nums = UblNums;
      }
      else if (table_id.match(/sme/)) {
        nums = SmeNums;
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
        'ubl' === table_id.substr(1, 3) ||
        '#sme' === table_id) {
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
      var num = '' + row.num;
      if (num.match(rgx)) {
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
    tr_s = $(table_id + ' tbody tr');
    for (var tr of tr_s) {
      row = table.row(tr);
      row_data = row.data();
      nextSibling = tr.nextSibling;
      if (nextSibling) {
        nextrow = table.row(nextSibling);
        nextrow_data = nextrow.data();
        nextrow_data.num = '' + nextrow_data.num;
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
  function tableInitEN(json) {
    var data, i, item, level, seq, num,
        prev_item = {},
        idxLevel = [], rows = [];
    EnMap = new Map();
    EnNums = [];
    item = {
      Card: "1..1",
      EN_BT: "Electronic Invoice",
      EN_Card: "1..1",
      EN_DT: "",
      EN_Desc: "The European Commission estimates that \\\"The mass adoption of e-invoicing within the EU would lead to significant economic benefits and it is estimated that moving from paper to e-invoices will generate savings of around EUR 240 billion over a six-year period\\\". Based on this recognition \\\"The Commission wants to see e-invoicing become the predominant method of invoicing by 2020 in Europe.\\\"",
      EN_ID: "root",
      EN_Level: 0,
      EN_Parent: "",
      num: "0",
      seq: 0
    };
    idxLevel[0] = '0';
    rows.push(item);
    EnNums.push('0');
    EnMap.set(0, item);
    data = json.data;
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      level = item.EN_Level;
      num = '' + seq;
      if (level > 0) {
        num = idxLevel[level - 1] + '_' + num;
      }
      while (idxLevel.length - 1 > level) {
        idxLevel.pop();
      }
      idxLevel[level] = num;
      item.num = num;
      item.seq = seq;
      if (prev_item.EN_BT !== item.EN_BT) {
        rows.push(item);
        EnNums.push(num);
        EnMap.set(seq, item);
      }
      prev_item = item;
    }
    filterRoot('#en');
    checkDetails('#en');
    return rows;
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
        item.num = num;
        nums.push(num);
        rows.push(item);
        map.set(seq, item);
      }
    }
    switch (table_id) {
      case '#cii':
        CiiMap = map;
        CiiNums = nums;
        break;
      case '#ubl':
        UblMap = map;
        UblNums = nums;
        break;
    }
    return rows;
  }
  function tableInitSME(json) {
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
      num = item.num;
      seq = item.seq;
      item.num = num;
      nums.push(num);
      rows.push(item);
      map.set(seq, item);
    }
    SmeMap = map;
    SmeNums = nums;
    return rows;
  }
  // -----------------------------------------------------------------
  // EN
  ajaxRequest('data/en2cii.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInitEN(json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    en_table.clear();
    en_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#en');
  })
  .catch(function(err) { console.log(err); })

  en_table = $('#en').DataTable({
    // 'ajax': 'data/en2cii.json',
    'columns': en_columns,
    'columnDefs': en_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    // 'initComplete': function(settings, json) {
    //   tableInitEN('#en', json);
    // },
    'drawCallback': function(settings) {
      checkDetails('#en');
    }  
  });
  // CII
  ajaxRequest('data/cii2en.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInit2('#cii', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    cii_table.clear();
    cii_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#cii');
  })
  .catch(function(err) { console.log(err); })

  cii_table = $('#cii').DataTable({
    'columns': x_columns,
    'columnDefs': x_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#cii');
    }  
  });
  // SME
  ajaxRequest('data/sme.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInitSME(json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    sme_table.clear();
    sme_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#sme');
  })
  .catch(function(err) { console.log(err); })

  sme_table = $('#sme').DataTable({
    'columns': sme_columns,
    'columnDefs': sme_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#sme');
    }  
  });  
  // UBL
  ajaxRequest('data/ubl2en_ivc.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInit2('#ubl', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    ubl_table.clear();
    ubl_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#ubl');
  })
  .catch(function(err) { console.log(err); })

  ubl_table = $('#ubl').DataTable({
    'columns': x_columns,
    'columnDefs': x_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#ubl');
    }  
  });
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
      row.child(en_format(row.data())).show(); tr.addClass('shown');
    }
  });
  // CII
  $('#cii tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = cii_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      row.child(x_format(row.data(), 'cii')).show(); tr.addClass('shown');
    }
  });
  // SME
  $('#sme tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = sme_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      row.child(sme_format(row.data(), 'sme')).show(); tr.addClass('shown');
    }
  });
  // UBL
  $('#ubl tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = ubl_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      row.child(x_format(row.data())).show(); tr.addClass('shown');
    }
  });
  // UBL2EN_CNT
  $('#ubl2en_cnt tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = ubl2en_cnt_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      row.child(x_format(row.data())).show(); tr.addClass('shown');
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
    // var id = data.EN_ID;
    // if (id.match(/^BG/)) {
      expandCollapse('#en', EnMap, tr);      
    }
  });
  // CII
  $('#cii tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = cii_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^' + num + '_[^_]+$'),
        i = 0;
    for (num of CiiNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#cii', CiiMap, tr);      
    }
  });
  // SME
  $('#sme tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = sme_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^' + num + '_[^_]+$'),
        i = 0;
    for (num of SmeNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#sme', SmeMap, tr);      
    }
  });
  // UBL
  $('#ubl tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = ubl_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^' + num + '_[^_]+$'),
        i = 0;
    for (num of UblNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#ubl', UblMap, tr);      
    }
  });
  // -----------------------------------------------------------------
  // Ajax request for data
  // -----------------------------------------------------------------
  // UBL_IVC 
  ajaxRequest('data/ubl2.1/ivc.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      UBL_IVC = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // UBL_CNT 
  ajaxRequest('data/ubl2.1/cnt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      UBL_CNT = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // UBL_CBC 
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
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // UBL_CAC 
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
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });

  // -----------------------------------------------------------------
  // UN/CEFACT CII
  // CII_CII 
  ajaxRequest('data/cii/cii.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      CII_CII = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // CII_ABIE
  ajaxRequest('data/cii/abie.json', null, 'GET', 10000)
  .then(function(res) {
    try {
      CII_ABIE = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // CII_CCT
  ajaxRequest('data/cii/cct.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      CII_CCT = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // CII_QDT
  ajaxRequest('data/cii/qdt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      CII_QDT = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // CII_UDT
  ajaxRequest('data/cii/udt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      CII_UDT = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });

  setTimeout(function() {
    setFrame(1,'en');
    setFrame(2,'sme');
  }, 3000);

}
// main.js