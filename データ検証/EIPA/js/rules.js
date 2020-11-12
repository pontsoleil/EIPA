/**
 * rules.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var rule_columns, rule_columnDefs, rule_table, RuleMap, RuleRows, rule_count=3,
    COL_rule_infocontrol,
    en_columns, en_columnDefs, en_table, EnMap, EnMap2, EnNums, EnRows,
    expandedRows, collapsedRows,
    TABLE2, RULES, RULES2,
    TABLE2_JA, RULES_JA,
    // CONDITIONS_JA, FUNCTIONALITY_JA, INTEGRITY_JA, VAT_JA,
    VAT_CATEGORY_JA;

function setFrame(num, _frame) {
  var frame, root_pane,
      component, content,
      root_pane,
      keyword;
  if (['func', 'int', 'cond', 'vat', 'rule'].indexOf(_frame) >= 0) {
    frame = 'rule';
  }
  else {
    frame = _frame;
  }
  if ('reset' === _frame) {
    if (1 === num) {
      filterRoot('#en');
      checkDetails('#en');
      $('#en-frame .fa-sync').addClass('d-none');
    }
    else if (2 === num) {
      find('#rule', 'ID', null);
      $('#rule-frame .fa-sync').addClass('d-none')
    }
  }
  else if (['en', 'rule'].indexOf(_frame) >= 0) {
    $('#tab-2 .tablinks').removeClass('active');
    $('#component-'+num+' .split-pane').splitPane('lastComponentSize', 0);
    root_pane = $('#root');
    root_pane.removeClass('d-none');
    component = $('#component-'+num);
    component.empty();
    content = $('#'+frame+'-frame');
    component.append(content);
  }
  else if (['func', 'int', 'cond', 'vat'].indexOf(_frame) >= 0) {
    $('#tab-2 .tablinks').removeClass('active');
    $('#tab-2 .tablinks.'+_frame).addClass('active');
    rule_table.clear();
    rule_table.rows.add(RuleRows);
    switch (_frame) {
      case 'func':
        keyword = '^R[0-9]*';
        break;
      case 'int':
        keyword = '^BR-[0-9]*';
        break;
      case 'cond':
        keyword = '^BR-CO-[0-9]*';
        break;
      case 'vat':
        keyword = '^BR-(AE|E|G|IC|IG|IP|O|S|Z)-[0-9]*';
        break;
    }
    rule_table.columns(0)
    .search(keyword, /** regex */true, /** smart */false)
    .draw();
  }
  
  setTimeout(function() {
    $('#en-frame > i.fa-sync').on('click', function() {
      filterRoot('#en');
      checkDetails('#en');
      $('#en-frame .fa-sync').addClass('d-none');
    });
    $('#rule-frame > i.fa-sync').on('click', function() {
      find('#rule', 'ID', null);
      $('#rule-frame .fa-sync').addClass('d-none')
    });
  }, 500);
}
// -----------------------------------------------------------------
// Formatting function for row details
//
function find(table_id, col, word) {
  var table = $(table_id).DataTable(),
      keys, vals, tableRows, nums_ = {};
  if ('#en' === table_id) {
    tableRows = EnRows; 
  }
  else if ('#rule' === table_id) {
    tableRows = RuleRows;
  }
  if (!word) {
    rows = tableRows;
  }
  else {
    keys = word.split(' ');
    rows = [];
    tableRows.forEach(function(v, i) {
      vals = v[col].split(' ');
      for (var key of keys) {
        for (var val of vals) {
          if (key === val) {
            rows.push(v);
            if (v.num.split('_').length > 2) {
              nums_[v.num] = true;
            }
          }
        }
      }
    });
  }
  Object.keys(nums_).forEach(function(num) {
    var _num, v;
    _num = num;
    while (_num.split('_').length > 2) {
      _num = _num.match(/^(.*)_[0-9]*$/)[1];
      v = EnMap2.get(_num);
      rows = appendByNum(rows, v);
    }
  });
  rows.sort(compareNum);
  table.clear();
  table.rows
  .add(rows)
  .draw();
  if ('#en' === table_id) {
    $('#en-frame .fa-sync').removeClass('d-none');
    checkDetails('#en', true);
    var trs = $('#en tbody tr');
    for (var tr of trs){
      var td = tr.children[5];
      if (td.innerText.indexOf(word) >= 0) {
        td.innerText = td.innerText.replace(word, '*'+word);
      }
      keys = word.split(' ');
      td = tr.children[1];
      for (var key of keys) {
        if (key === td.innerText) {
          td.innerText = '*'+key;
        }
      }


    }
  }
  else if ('#rule' === table_id) {
    $('#rule-frame .fa-sync').removeClass('d-none');
  }
}

function en_find(d) { // d is the original data object for the row
  var reqID = d.ReqID,
      word;
  word = reqID.trim();
  find('#rule', 'ID', word);
}

function en_format(d) { // d is the original data object for the row
  if (!d) { return null; }
/** num ID Level Card BusinessTerm Desc UsageNote ReqID SemanticDataType */
  var H1 = 40, H2 = 60,
      desc = d.Desc || '',
      usage = d.UsageNote || '',
      html = '';
  return googleTranslate([desc, usage])
  .then(function(translations) {
    var translatedText = translations[0].translatedText,
        match, desc_google, usage_google;
    usage = usage.replaceAll(' - ','<br>- ');
    match = translatedText.match(/.(\&quot;|「)(.*)(\&quot;|」)、.*(\&quot;|「)(.*)(\&quot;|」)./);
    if (match) {
      desc_google = match[2];
      usage_google = match[5];
      usage_google = usage_google.replaceAll(' - ','<br>- ');
    }
  // return Promise.resolve()
  // .then(function() {
    var record, desc_ja = '', usage_ja = '';
    record = TABLE2_JA[d.ID];
    desc_ja = record['desc_ja'];
    usage_ja = record['usage_ja'];

    html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
      '<colgroup>'+
        '<col style="width:'+H1+'%;">'+
        '<col style="width:'+H2+'%;">'+
      '</colgroup>'+
      '<tr>';
    //
    if (desc_ja && usage_ja) {
      html += '<tr>'+
        '<td valign="top">'+desc_ja+'</td><td valign="top">'+usage_ja+'</td>'+
      '</tr>';
    }
    else if (desc_ja) {
      html += '<tr><td valign="top" colspan="2">'+desc_ja+'</td></tr>';
    }
    else if (usage_ja) {
      html += '<tr><td valign="top" colspan="2">'+usage_ja+'</td></tr>';
    }
    // translation
    if (desc_google && usage_google) {
      html += '<tr>'+
        '<td valign="top">- Google翻訳API(V2) -<br>'+desc_google+'</td><td valign="top">'+usage_google+'</td></tr>';
    }
    else if (desc_google) {
      html += '<tr><td valign="top" colspan="2">- Google翻訳API(V2) -<br>'+desc_google+'</td></tr>';
    }
    else if (usage_google) {
      html += '<tr><td valign="top" colspan="2">- Google翻訳API(V2) -<br>'+usage_google+'</td></tr>';
    }
    // original
    if (desc && usage) {
      html += '<td valign="top">'+desc+'</td><td valign="top">'+usage+'</td>';
    }
    else if (desc) {
      html += '<td valign="top" colspan="2">'+desc+'</td>';
    }
    else if (usage) {
      html += '<td valign="top" colspan="2">'+usage+'</td>';
    }
    html += '</tr>';
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); })
}

function rule_find(d) { // d is the original data object for the row
  var id = d.ID,
      term = d.BusinessTerm || '';
  if (term) {
    find('#en', 'ID', term);
  }
  else {
    find('#en', 'ReqID', id);
  }
}

function rule_format(d) { // d is the original data object for the row
  if (!d) { return null; }
/** num ID Desc Target BusinessTerm */
  var H1 = 40, H2 = 60,
      desc = d.Desc || ' ',
      target = d.Target || '',
      term = d.BusinessTerm || '',
      // word,
      html = '';
  return googleTranslate(desc)
  .then(function(translations) {
    var desc_google = translations[0].translatedText;
    if (desc_google.match(/NL/)) {
      desc_google = desc_google.replaceAll('NL', '<br>\n');
    }
  // return Promise.resolve()
  // .then(function() {
    var record, desc_ja = '';
    record = RULES_JA[d.ID];
    if (record) {
      desc_ja = record['ja'];
    }
    if (desc_ja.match(/NL/)) {
      desc_ja = desc_ja.replaceAll('NL', '<br>\n');
    }
    html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
      '<colgroup>'+
        '<col style="width:'+H1+'%;">'+
        '<col style="width:'+H2+'%;">'+
      '</colgroup>';
      // if (desc_ja) {
      //   html += '<tr><td colspan="2">'+desc_ja+'</td></tr>';
      // }
      if (desc_google) {
        html += '<tr><td colspan="2">- Google翻訳API(V2) -<br>'+desc_google+'</td></tr>';
      }
      html += '<tr><td colspan="2">'+desc+'</td></tr>';
      if (target && term) {
        html += '<tr>'+
          '<td valign="top">'+target+'</td><td valign="top">'+term+'</td></tr>'
      }
      else if (target) {
        html += '<tr><td valign="top" colspan="2">'+target+'</td></tr>'
      }
      else if (term) {
        html += '<tr><td valign="top" colspan="2">'+term+'</td></tr>'
      }

      html += '</table>';
    if (desc || term || target) {
      return html;
    }
    return null;
  })
  .catch(function(err) {
    console.log(err);
    return 'ERROR:' + JSON.stringify(err);
  });
}
// -----------------------------------------------------------------
// EN
function renderBT(row) {
  var term = row.BusinessTerm,
      record,
      level = row.Level,
      res;
  record = TABLE2_JA[row.ID];
  if (record) {
    term = record['bt_ja']
  }
  res = level+' '+term;
  return res;
}
// -------------------------------------------------------------------
/** num ID Level Card BusinessTerm Desc UsageNote ReqID semanticDataType */
en_columns = [
  { 'width': '3%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'width': '10%',
    'data': 'ID' }, // 1
  { 'width': '54%',
    'data': 'BusinessTerm',
    'render': function(data, type, row) {
      var term = renderBT(row);
      return term; }}, // 2   
  { 'width': '10%',
    'data': 'SemanticDataType' }, // 3
  { 'width': '5%',
    'data': 'Card' }, // 4
  { 'width': '10%',
    'data': 'ReqID' }, // 5
  { 'width': '5%',
    'className': 'translate-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fas fa-language"></i>' }, // 6
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 7
];
en_columnDefs = [
  { 'searchable': false, 'targets': [0, 6, 7] }/*,
  { 'visible': false, 'targets': 1 }*/
];
/** num ID Desc Target BusinessTerm */
COL_rule_infocontrol = 3;
rule_columns = [
  { 'width': '12%',
    'data': 'ID' }, // 0
  { 'width': '60%',
    'data': 'Desc',
    'render': function(data, type, row) {
      var desc = row.Desc;
      var record = RULES_JA[row.ID];
      if (record) {
        desc = record['ja'];
      }
      if (desc.match(/NL/)) {
        desc = desc.replaceAll('NL', '<br>\n');
      }
      return desc; }}, // 1
  { //'width': '20%',
    'data': 'BusinessTerm' }, // 2
  { 'width': '20%',
    'data': 'Target' }, // 3
  { 'width': '5%',
    'className': 'translate-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fas fa-language"></i>' },
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 4
];
rule_columnDefs = [
  { 'searchable': false, 'targets': [4] },
  { 'visible': false, 'targets': 2 }
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
var compareID = function(a, b) {
  var a_match, a_kind, a_num,
      b_match, b_kind, b_num;
    a_match = a.match(/^([A-Z]*)-([0-9]*)$/);
    b_match = b.match(/^([A-Z]*)-([0-9]*)$/);
    if (a_match && b_match) {
      a_kind = a_match[1]; a_num = +a_match[2];
      b_kind = b_match[1]; b_num = +b_match[2];
      if (a_kind < b_kind) { return -1; }
      if (b_kind < a_kind) { return  1; }
      if (a_num < b_num) { return -1; }
      if (b_num < a_num) { return  1; }
    }
    return 0;
}

var compareNum = function(a, b) {
  var a_num = ''+a.num,
      b_num = ''+b.num,
      a_arr = a_num.split('_').map(function(v){ return+v; }),
      b_arr = b_num.split('_').map(function(v){ return+v; });
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
  if ('#en' === table_id) {
    EnRows.forEach(function(v, i) {
      if (v.num.split('_').length < 3) {
        rows.push(v);
      }
    });
    table.clear();
    table.rows
    .add(rows)
    .draw();
    $('#en-frame .fa-sync').addClass('d-none')
  }
}
// -------------------------------------------------------------------
function checkDetails(table_id, /** check if expandes */check) {
  var table = $(table_id).DataTable(),
      data = table.data(),
      tr_s, tr,
      row, row_data, expanded;
  tr_s = $(table_id+' tbody tr');
  if (data.length > 0) {
    if ('#en' === table_id) {
      for (var tr of tr_s) {
        row = table.row(tr);
        row_data = row.data();
        if (row_data.ID.match(/^BT/)) {
          tr.childNodes[0].classList = '';
        }
        if (check) {
          expanded = isExpanded(data, row_data.num);
          if (expanded) {
            tr.classList.add('expanded');
          }
        }
      }
    }
  }
}
// -------------------------------------------------------------------
function isExpanded(rows, num) {
  var expanded = false,
      i, rgx;//, count = 0;
  rgx = RegExp('^'+num+'_[^_]+$')
  for (i = 0; i < rows.length; i++) {
    num = rows[i].num;
    if (num.match(rgx)) {
      expanded = num;
      break;
    }
  }
  return expanded;
}
// -------------------------------------------------------------------
function expandCollapse(table_id, map, tr) {
  var table,
      row, row_data, rows, rows_, id, i, 
      res,
      collapse = null,
      expand = null,
      v, rgx;
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
  // Table initialize
  // -----------------------------------------------------------------
  function tableInitEN(json) {
    var data, i, item, level, seq, num,
        prev_item = {},
        idxLevel = [], rows = [];
    EnNums = [];
    EnMap = new Map();
    EnMap2 = new Map();
/** item = { num,ID,Level,Card,BusinessTerm,Desc,UsageNote,ReqID,SemanticDataType,num:,seq: };*/
    idxLevel[0] = '0';
    data = json.data;
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      level = item.Level.length;
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
      item.BusinessTerm = item.BusinessTerm || '';
      item.Desc = item.Desc || '';
      item.UsageNote = item.UsageNote || '';
      item.ReqID = item.ReqID || '';
      item.ReqID = item.ReqID.replaceAll(',',' ');
      item.SemanticDataType = item.SemanticDataType || '';
      rows.push(item);
      EnNums.push(num);
      EnMap.set(seq, item);
      EnMap2.set(num, item);
      prev_item = item;
    }
    EnRows = rows;
    filterRoot('#en');
    checkDetails('#en');
    return rows; // promise.then
  }

  function tableInitRule() {
    var data = [],
        item,
        seq, num,
        desc, match, bts,
        term, pos, terms,
        rows = [];
/** item = { num,ID,Desc,Target,BusinessTerm }; */
    RuleMap = new Map();
    RULES.data.map(function(d) { data.push(d); });
    RULES2.data.map(function(d) { data.push(d); });
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      seq = i;
      item.seq = seq;
      num = ''+seq;
      item.num = num;
      item.Target = item.Target || '';
      item.BusinessTerm = item.BusinessTerm || '';
      item.BusinessTerm = item.BusinessTerm.replaceAll(',',' ');
      desc = item.Desc ?  ''+item.Desc : '';
      if (desc.match(/NL/)) {
        item.Desc = desc.replaceAll('NL', '<br>\n');
      }
      else {
        item.Desc = desc;
      }
      terms = {};
      bts = item.BusinessTerm.split(' ');
      for (var bt of bts) {
        terms[bt] = true;
      }
      pos = 1;
      while (pos>0){
        match = desc.match(/B[GT]-[0-9]*/);
        if (match) {
          term = match[0];
          terms[term] = true;
          pos = match.index;
          desc = desc.substr(pos+1);
        }
        else {
          pos=-1;
        }
      }
      item.BusinessTerm = Object.keys(terms).sort(compareID).join(' ');
      rows.push(item);
      RuleMap.set(seq, item);
    }
    rule_table.clear();
    rule_table.rows
    .add(rows)
    .draw();
    RuleRows = rows;
    $('#rule-frame .fa-sync').addClass('d-none')
  }

  rule_table = $('#rule').DataTable({
    'columns': rule_columns,
    'columnDefs': rule_columnDefs,
    'paging': true,
    'autoWidth': false,
    'ordering': false,
    'select': true
  });
  // -----------------------------------------------------------------
  // Ajax request for japanese translation
  // -----------------------------------------------------------------
  ajaxRequest('data/rules/EN_16931-1_table2_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      TABLE2_JA = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // RULES
  ajaxRequest('data/rules/EN_16931-1_rules_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      RULES_JA = JSON.parse(res);
      rule_count--;
      if (0 === rule_count) {
        tableInitRule();
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
/*
  ajaxRequest('data/rules/EN_16931-1_conditions_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      for(var k in json){
        var v = json[k];
        RULES[k] = v;
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  ajaxRequest('data/rules/EN_16931-1_functionality_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      for(var k in json){
        var v = json[k];
        RULES[k] = v;
      }    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  ajaxRequest('data/rules/EN_16931-1_integrity_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      for(var k in json){
        var v = json[k];
        RULES[k] = v;
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  ajaxRequest('data/rules/EN_16931-1_vat_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      for(var k in json){
        var v = json[k];
        RULES[k] = v;
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  */
  // VAT category
/*  ajaxRequest('data/rules/EN_16931-1_VATcategory_ja.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      VAT_CATEGORY_JA = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  */
  // -----------------------------------------------------------------
  // Ajax request for rule data
  // -----------------------------------------------------------------
  ajaxRequest('data/rules/EN_16931-1_rules.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      RULES = JSON.parse(res);
      rule_count--;
      if (0 === rule_count) {
        tableInitRule();
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  
  ajaxRequest('data/rules/EN_16931-1_rules2.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      RULES2 = JSON.parse(res);
      rule_count--;
      if (0 === rule_count) {
        tableInitRule();
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });

  // -----------------------------------------------------------------
  // EN
  ajaxRequest('data/rules/EN_16931-1_table2.json', null, 'GET', 1000)
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
    EnRows = rows;
  })
  .then(function() {
    filterRoot('#en');
  })
  .catch(function(err) { console.log(err); })

  en_table = $('#en').DataTable({
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

  // -----------------------------------------------------------------
  // Add event listener for finding used info
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_table.row(tr);
    en_find(row.data());
    $('#en tbody tr td').removeClass('active');
    tr[0].children[1].classList.add('active');
  });
  // Rule
  $('#rule tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = rule_table.row(tr), info;
    rule_find(row.data());
    $('#rule tbody tr td').removeClass('active');
    tr[0].firstElementChild.classList.add('active');
  });
  // -----------------------------------------------------------------
  // Add event listener for opening and closing translation
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td.translate-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide();
      tr.removeClass('shown');
    }
    else { // Open this row and lookup correponding rules
      en_format(row.data())
      .then(function(html) {
        row.child(html ).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // Rule
  $('#rule tbody').on('click', 'td.translate-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = rule_table.row(tr), info;
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide();
      tr.removeClass('shown');
    }
    else { // Open this row and lookup correponding term/group
      rule_format(row.data())
      .then(function(info) {
        row.child(info).show();
        tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // -----------------------------------------------------------------
  // Add event listener for opening and closing detail records
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td:not(.translate-control, .info-control)', function (event) {
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



  setTimeout(function() {
    setFrame(1, 'en');
    setFrame(2, 'rule');
  }, 500);
}
// rules.js