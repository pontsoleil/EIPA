/**
 * syntax.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var x_columns, x_columnDefs,
    en_columns, en_columnDefs,
    en_table, EnMap, EnNums,
    cii_table, CiiMap, CiiNums,
    sme_table, SmeMap, SmeNums,
    ubl_table, UblMap, UblNums,
    peppol_table, PeppolMap, PeppolNums,
    expandedRows, collapsedRows,
    pane = [],
    UBL_IVC, UBL_CNT, UBL_CBC, UBL_CAC,
    CII_CII, CII_ABIE, CII_CCT, CII_QDT, CII_UDT,
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
    };

function setFrame(num, frame) {
  var frame, match, id, base, component, content, child;

  pane[num] = frame;

  $('#tab-'+num+' .tablinks').removeClass('active');
  $('#tab-'+num+' .tablinks.'+frame).addClass('active');
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
      desc = ''+d.EN_Desc,
      id = ''+d.EN_ID,
      datatype = ''+d.EN_DT,
      html = '';
    datatype = datatype.trim();
    datatype = datatype ? 'data type: '+datatypeMap[datatype] : 'Business terms Group';
    html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
      '<colgroup>'+
        '<col style="width:'+H1+'%;">'+
        '<col style="width:'+H2+'%;">'+
      '</colgroup>'+
      '<tr>'+
        '<td valign="top">ID: '+id+'<br>'+datatype+'</td>'+
        '<td valign="top">'+desc+'</td>'+
      '</tr>';
  if (!desc) {
    html += '</table>';
    return Promise.resolve(html)
    .then(function(html) {
      return html;
    })
    .catch(function(err) { console.log(err); });  
  }
  return googleTranslate(desc)
  .then(function(translations) {
    var j_desc = translations[0].translatedText;
    if (j_desc) {
      html += '<tr><td valign="top" colspan="2">'+j_desc+'</td></tr>';
    }
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); });
}

function x_format(d, kind) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 35, H2 = 65,
      paths = d.Paths,
      _paths, parent, child, _child,
      match, abie, bbie, base,
      parent_type, den, datatype, cardinality, definition,
      html = '';
  _paths = paths.replaceAll('&nbsp;','').split('<br>');
  parent = _paths[_paths.length - 3];
  child = _paths[_paths.length - 2];
  if ('cii' === kind) {
    if (parent) {
      match = parent.match(/^r[as]m:(.*)$/);
      if (match) {
        abie = match[1];
        match = child.match(/^r[as]m:(.*)$/);
        if (match) { child = match[1]; }
        for (var v of CII_CII.complexType.element) {
          if (v['@name'] && v['@name'].indexOf(child) >= 0) { _child = v; break; }
        }
        if (!_child) {
          for (var v of CII_ABIE.element) {
            if (v['@name'] && v['@name'].indexOf(child) >= 0) { _child = v; break; }
          }
        }
        if (!_child) {
          for (var v of CII_ABIE.complexType) {
            if (v['@name'] && v['@name'].indexOf(child) >= 0) { _child = v; break; }
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
      if (_child.length > 0) { _child = _child[0]; }
    }
    else if ('Invoice' === parent) {
      _child = UBL_IVC.element.filter(function(el) { return child === el['@ref']; });
      if (_child.length > 0) { _child = _child[0]; }
    }
    else if ('CreditNote' === parent) {
      _child = UBL_CNT.element.filter(function(el) { return child === el['@ref']; });
      if (_child.length > 0) { _child = _child[0]; }
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
  base = base ? ' ( '+base+' ) ' : '';
  cardinality = _child['Cardinality'] || '';
  cardinality = cardinality ? ' ( '+cardinality+')' : '';
  definition =  _child['Definition'] || '';
  var desc_x = den+cardinality+'<br>'+
            // (datatype ? (datatype+base) : 'cii' === kind ? '' : 'Aggregate')+'<br>'+
            definition;
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>'+
      '<col style="width:'+H1+'%;">'+
      '<col style="width:'+H2+'%;">'+
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">Path: '+paths+'</td>'+
      '<td valign="top">'+desc_x+'</td>'+
    '</tr>';  
  if (!definition) {
    html += '</table>';
    return Promise.resolve(html)
    .then(function(html) {
      return html;
    })
    .catch(function(err) { console.log(err); });  
  }
  return googleTranslate(definition)
  .then(function(translations) {
    var j_definition = translations[0].translatedText;
    if (j_definition) {
      html += '<tr><td valign="top" colspan="2">'+j_definition+'</td></tr>';
    }
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); });  
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
  title = hdr+' '+kind+' '+uniqueID+(private ? ' 非公開' : '')+'<br>'+
          name+
          (item_name ? '<br>( '+item_name+' )' : '') +
          (note ? '<br>'+note : '');
  cardinality = cardinality ? ' ( '+cardinality+')' : '';
  desc = description;
  memo = (comment1 || comment2 || comment3 ? '<br>' : '') +
          (comment1 ? comment1 : '')+
          (comment2 ? ' '+comment2 : '')+
          (comment3 ? ' '+comment3 : '') +
          (update || private || SME || Invoice ? '<br>' : '') +
          (update ? update : '')+(private ? ' '+private : '')+
          (SME ? ' 中小基本必須' : '')+
          (Invoice ? ' 適格請求書対応' : '');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>'+
      '<col style="width:'+H1+'%;">'+
      '<col style="width:'+H2+'%;">'+
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">'+title+'</td>'+
      '<td valign="top">'+desc+memo+'</td>'+
    '</tr>'+
  '</table>';
  return html;
}

function peppol_format(d) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 100,
      name = d.Name,
      description = d.Description,
      html = '';
  description = description.replaceAll('_QUOT_', '&quot;');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>'+
      '<col style="width:'+H1+'%;">'+
    '</colgroup>'+
    '<tr>'+
      '<td valign="top">'+description+'</td>'+
    '</tr>';  
  if (!description) {
    html += '</table>';
    return Promise.resolve(html)
    .then(function(html) {
      return html;
    })
    .catch(function(err) { console.log(err); });  
  }
  return googleTranslate(description)
  .then(function(translations) {
    var j_description = translations[0].translatedText;
    if (j_description) {
      j_description = j_description.replaceAll('_QUOT_', '&quot;');
      html += '<tr><td valign="top">'+j_description+'</td></tr>';
    }
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); });  
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
    term = '<b>'+term+'</b>';
  }
  res = res += term;
  return res;
}
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
// -------------------------------------------------------------------
function renderPath(row) {
  var path = row.Path || '';
  if (0 === row.seq) { path = '<b>'+path+'</b>'; }
  else if (row.Card && row.Card.match(/^1/)) {
    path = path.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
  }
  return path;
}
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
      var path = renderPath(row);
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
// -------------------------------------------------------------------
function renderSmdDen(row) {
  var den = row.DictionaryEntryName || '';
  if (1 === row.seq) { den = '<b>'+den+'</b>'; }
  else if (row.Card && row.Card.match(/^1/)) {
    den = '<b>'+den+'</b>';
    // den = den.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
  }
  var level = row.num && row.num.split('_') || [];
  level = level.length - 1;
  var prefix = ''
  for (var i = 0; i < level; i++) {
    prefix += '+';
  }
  if (level > 0) {
    den = prefix+' '+den;
  }
  return den;
}
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
      var den = renderSmdDen(row);
      return den; }}, // 2
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
function renderPeppolName(row) {
  var name = row.Name,
      prefix = row.Level,
      card = row.Card,
      match;
  match = name.match(/[+]*[ ]*(.*)$/);
  if (match) { name = match[1]; }
  if (card.match(/^1/)) { name = '<b>'+name+'</b>'; }
  if (prefix) { name = prefix+' '+name; }
  return name;
}
peppol_columns = [
  { 'width': '5%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'width': '80%',
    'data': 'Name',
    'render': function(data, type, row) {
      var name = renderPeppolName(row);
      return name; }}, // 1
  { 'width': '10%',
    'data': 'Card' }, // 2
  { 'width': '5%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 3
];
peppol_columnDefs = [
  { 'searchable': false, 'targets': [0, 3] }
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
  var a_num = ''+a.num,
      b_num = ''+b.num,
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
        '#peppol' === table_id) {
      if (v.num.split('_').length < 3) {
        rows.push(v);
      }
    }
    // else if ('#peppol' === table_id) {
    //   if (v.num.split('_').length < 2) {
    //     rows.push(v);
    //   }
    // }
  });
  table.clear();
  table.rows
  .add(rows)
  .draw();

  if ('#cii' === table_id || '#ubl' === table_id) {
    $(table_id +' tbody tr')[0].classList.add('expanded');
  }
}
// -------------------------------------------------------------------
function checkDetails(table_id) {
  var table = $(table_id).DataTable(),
      data = table.data(),
      tr_s, tr,
      row, row_data, num, i, nums,
      rgx;
  tr_s = $(table_id+' tbody tr');
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
    else {
      if (table_id.match(/cii/)) {
        nums = CiiNums;
      }
      else if (table_id.match(/ubl/)) {
        nums = UblNums;
      }
      else if (table_id.match(/sme/)) {
        nums = SmeNums;
      }
      else if (table_id.match(/peppol/)) {
        nums = PeppolNums;
      }
      if (nums.length > 0)
      for (var tr of tr_s) {
        row = table.row(tr);
        row_data = row.data();
        num = row_data.num;
        if (1 == num) { i = 1; }
        else {
          rgx = RegExp('^'+num+'_[^_]+$');
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
      row, row_data, rows, rows_, i, 
      res,
      collapse = null,
      expand = null,
      v, rgx;

  function isExpanded(rows, num) {
    var expanded = false,
        rgx;
    if ('en' === table_id.substr(1, 2) ||
        'cii' === table_id.substr(1, 3) ||
        'ubl' === table_id.substr(1, 3) ||
        '#sme' === table_id ||
        '#peppol' === table_id) {
      rgx = RegExp('^'+num+'_[^_]+$')
      for (var i = 0; i < rows.length; i++) {
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
  for (var i = 0; i < rows_.length; i++) {
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
    rgx = RegExp('^'+collapse+'_');
    rows = rows.filter(function(row) {
      var num = ''+row.num;
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
    rgx = RegExp('^'+expand+'_[^_]+$');
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
    tr_s = $(table_id+' tbody tr');
    for (var tr of tr_s) {
      row = table.row(tr);
      row_data = row.data();
      nextSibling = tr.nextSibling;
      if (nextSibling) {
        nextrow = table.row(nextSibling);
        nextrow_data = nextrow.data();
        nextrow_data.num = ''+nextrow_data.num;
        rgx = RegExp('^'+row_data.num+'_[^_]+$');
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
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      level = item.EN_Level;
      num = ''+seq;
      if (level > 0) {
        num = idxLevel[level - 1]+'_'+num;
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
  function tableInitX(table_id, json) {
    var map, nums,
        data, item,
        seq, previous_path, paths, padding = '', wk_path = '',
        level, num, name, term, i,
        rows = [],
        idxLevel = [];
    data = json.data;
    map = new Map();
    nums = [];
    previous_path = '';
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      if (previous_path !== item.Path) {
        previous_path = item.Path;
        seq = i;
        item.seq = seq;
        item.EN_Level = item.EN_Level || '';
        item.EN_Card = item.EN_Card || '';
        item.EN_DT = item.EN_DT || '';
        item.EN_Desc = item.EN_Desc || '';
        num = ''+seq;
        paths = item.Path.split('/');
        if (paths.length > 1) {
          for (var j = 1; j < paths.length; j++) {
            wk_path += padding+paths[j]+'<br>';
            padding += '&nbsp;&nbsp;&nbsp;';
          }
          item.Paths = wk_path;
          padding = '';
          wk_path = '';
          paths.shift();
          level = paths.length - 1;
          name = '';
          for (var j = 0; j < level; j++) { name += '+'; }
          if (level > 0) { name += ' '; }
          term = paths[level];
          name += term;
          item.Path = name;
          if (level > 0) {
            num = idxLevel[level - 1]+'_'+num;
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
        seq, num,
        rows = [];
    data = json.data;
    map = new Map();
    nums = [];
    for (var i = 0; i < data.length; i++) {
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
  function tableInitPEPPOL(json) {
    var map, nums,
        data, item,
        seq, prefix, paths, padding = '', wk_path = '',
        level, num, name, term, i,
        rows = [],
        idxLevel = [];
    data = json.data;
    map = new Map();
    nums = [];
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      seq = i;
      item.seq = seq;
      num = ''+seq;
      name = item.Name || '';
      prefix = item.Level;
      item.Name = prefix+' '+name;
      level = prefix.length;
      if (level > 0) {
        //level = prefix.length - 1;
        // if (level > 0) {
        num = idxLevel[level - 1]+'_'+num;
        // }
        while (idxLevel.length - 1 > level) {
          idxLevel.pop();
        }
      }
      idxLevel[level] = num;
      item.num = num;
      nums.push(num);
      rows.push(item);
      map.set(seq, item);
    }
    PeppolMap = map;
    PeppolNums = nums;
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
  // ------
  en_table = $('#en').DataTable({
    // 'ajax': 'data/en2cii.json',
    'columns': en_columns,
    'columnDefs': en_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#en');
    }  
  });
  // CII
  ajaxRequest('data/cii2en.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInitX('#cii', json);
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
  // ------
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
  // ------
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
      return tableInitX('#ubl', json);
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
  // ------
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
  // PEPPOL
  ajaxRequest('data/Peppol/invoice.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInitPEPPOL(json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    peppol_table.clear();
    peppol_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#peppol');
  })
  .catch(function(err) { console.log(err); })
  // ------
  peppol_table = $('#peppol').DataTable({
    'columns': peppol_columns,
    'columnDefs': peppol_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#peppol');
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
      row.child.hide();
      tr.removeClass('shown');
    }
    else { // Open this row
      en_format(row.data())
      .then(function(html) {
        row.child(html).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
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
      x_format(row.data(), 'cii')
      .then(function(html) {
        row.child(html).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
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
      row.child(sme_format(row.data(), 'sme')).show();
      tr.addClass('shown');
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
      x_format(row.data())
      .then(function(html) {
        row.child(html).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // Peppol
  $('#peppol tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = peppol_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      peppol_format(row.data())
      .then(function(html) {
        row.child(html).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
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
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of EnNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
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
        rgx = RegExp('^'+num+'_[^_]+$'),
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
        rgx = RegExp('^'+num+'_[^_]+$'),
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
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of UblNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#ubl', UblMap, tr);      
    }
  });
  // PEPPOL
  $('#peppol tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = peppol_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of PeppolNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#peppol', PeppolMap, tr);      
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
  // used by info-control x_format
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
// syntax.js