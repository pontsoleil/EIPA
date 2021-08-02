/**
 * rules.js
 *
 * designed by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
 * written by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
 *
 * MIT License
 * 
 * Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var IS_PINT, FRAME1, FRAME2,
    // PINT
    pint_rule_columns, pint_rule_columnDefs, pint_rule_table,
    PintRuleMap, PintRuleRows, pint_rule_count=2,
    COL_pint_rule_infocontrol,
    pint_columns, pint_columnDefs, pint_table, PintMap, PintMap2, PintNums, PintRows,
    PINT, PINT_RULES, JP_PINT_RULES,
    // EN
    rule_columns, rule_columnDefs, rule_table, RuleMap, RuleRows, rule_count=3,
    COL_rule_infocontrol,
    en_columns, en_columnDefs, en_table, EnMap, EnMap2, EnNums, EnRows,
    expandedRows, collapsedRows,
    TABLE2, RULES, RULES2,
    TABLE2_JA, RULES_JA, VAT_CATEGORY_JA,
    datatypeMap = {
      // Semantic
      'A': 'Amount',
      'U': 'Unit Price Amount',
      'Unit': 'Unit Price Amount',
      'P': 'Percentage',
      'Percent': 'Percentage',
      'Q': 'Quantity',
      'C': 'Code',
      'I': 'Identifier',
      'ID': 'Identifier',
      'Iatorndic': 'Identifier',
      'D': 'Date',
      '0': 'Document Reference',
      'REF (Optional)': 'Document Reference',
      'T': 'Text',
      'B': 'Binary Object',
      'Binary': 'Binary Object',
      // Syntax
      'M': 'Numeric',
      'S': 'String',
      'N': 'Normalized String'
    },
    COL_pint = { // pint2ubl.json
      'SemSort':0,'EN_ID':1,'PINT_ID':2,'BT':3,'BT_ja':4,'DT':5,'Card':6,'Desc':7,'Desc_ja':8,'Exp':9,'Exp_ja':10,
      'Example':11,'Card':12,'DT':13,'Section':14,'Extension':15,'SynSort':16,'Path':17,'Attr':18,'Rules':19
    },
    COL_pint_rule = { // pint_rules.json, jp-pint_rules.json
      'ID': 0, 'Desc':1, 'Desc_ja':2, 'BusinessTerm':3
    },
    pint_colBT, pint_colBT_ja, pint_rule_colDesc, pint_rule_colDesc_ja,
    RuleIDs;

function translateInfo() {
/*
  var table_id, table, data,
      tr_s, tr,
      row, row_data, html;

  if ($('#root table#pint2ubl')[0]) {
    table_id = '#pint2ubl';
  }
  else if ($('#root table#ubl2pint')[0]) {
    table_id = '#ubl2pint';
  }
  else {
    return;
  }
  table = $(table_id).DataTable(),
  data = table.data(),
  tr_s = $(table_id+' tbody tr');
  if (data.length > 0) {
    for (var tr of tr_s) {
      if ($(tr).hasClass('shown')) {
        row = table.row(tr);
        row_data = row.data();
        if (row.child.isShown()) { // This row is already open - close it
          row.child.hide();
          if ('#ubl2pint' == table_id) {
            html = ubl2pint_format(row_data);
          }
          else if ('#pint2ubl' == table_id) {
            html = pint2ubl_format(row_data);
          }
          row.child(html).show();
        }
      }
    }
  }
*/
}

function changeLanguage() {
  var Lang = $('div#tab-1 p.language.use').text(),
      en, ja;
  if ('en' == Lang) {
    Lang ='ja';
    en = false;
    ja = true;
  }
  else if ('ja' == Lang) {
    Lang = 'en';
    en = true;
    ja = false;
  }
  $('div.tab p.language.use').text(Lang);
  pint_colBT.visible(en);
  pint_colBT_ja.visible(ja);
  pint_rule_colDesc.visible(en);
  pint_rule_colDesc_ja.visible(ja);
  translateInfo();
}

function setMenu(tab) {
  var $pintTitle = $('#'+tab+' .tablinks.pint.title')
      $enTitle = $('#'+tab+' .tablinks.en.title');
  if ($enTitle.hasClass('active')) {
    $('.tablinks.en.title').removeClass('active');
    $('.tablinks.en').css('display', 'none');
    $('.tablinks.pint.title').addClass('active');
    $('.tablinks.pint').css('display', 'block');
    IS_PINT = true;
    FRAME1 = 'pint';
    FRAME2 = 'pint-rule';
  }
  else { // pint is active
    $('.tablinks.en.title').addClass('active');
    $('.tablinks.en').css('display', 'block');
    $('.tablinks.pint.title').removeClass('active');
    $('.tablinks.pint').css('display', 'none');
    IS_PINT = false;
    FRAME1 = 'en';
    FRAME2 = 'rule';
  }
  setFrame(FRAME1, FRAME2);
  changeLanguage();
}

function setFrame(_frame1, _frame2) {
  // 1 en, pint
  // 2 en: func, int, cond, vat
  //   pint: pint, jp-pint
  var frame1, frame2, root_pane1, root_pane2,
      component1, content_id1, current_content1, new_content1, container1,
      component2, content_id2, current_content2, new_content2, container2,
      keyword;
      // menu;
  if (_frame1) {
    if ('pint' === _frame1) {
      IS_PINT = true;
      // menu = 'pint';
    }
    else if ('en' === _frame1 || _frame2.match(/^(func|int|cond|vat|rule)$/)) {
      // menu = 'en';
      IS_PINT = false;
    }
  }
  if (IS_PINT) {
    frame1 = _frame1 || 'pint';
    frame2 = _frame2 || 'pint-rule';
  }
  else {
    frame1 = _frame1 || 'en';
    frame2 = _frame2 ||  'rule';
  }
  // resume content
  if (_frame1) {
    container1 = $('#'+frame1+'-container');
    current_content1 = $('#component-1 div:first');
    content_id1 = current_content1.attr('id');
    if (content_id1) {
      container1.append(current_content1);
    }
  }
  if (_frame2) {
    container2 = $('#'+frame2+'-container');
    current_content2 = $('#component-2 div:first');
    content_id2 = current_content2.attr('id');
    if (content_id2) {
      container2.append(current_content2);
    }
  }
  // load new content
  component1 = $('#component-1');
  new_content1 = $('#'+frame1+'-frame');
  component1.append(new_content1);
  filterRoot(frame1);
  checkDetails(frame1);
  component2 = $('#component-2');
  new_content2 = $('#'+frame2+'-frame');
  component2.append(new_content2);
  if ('reset' === _frame1 || 'reset' === _frame2) {
    find(frame2, 'ID', null);
  }
  else {
    $('#tab-2 .tablinks').removeClass('active');
    $('#tab-2 .tablinks.'+_frame2).addClass('active');
    if (IS_PINT) {
      if ('pint-rule' === _frame2) {
        pint_rule_table.clear();
        if (PintRuleRows && PintRuleRows.length > 0) {
          pint_rule_table.rows.add(PintRuleRows);
        }
        pint_rule_table.columns(0)
        .search('^.*$', /** regex */true, /** smart */false)
        .draw();
      }
      else {
        switch (_frame2) {
          case 'pint':
            keyword = '^ibr-[\-a-z0-9]*';
            break;
          case 'jp-pint':
            keyword = '^jp-[\-a-z0-9]*';
            break;
        }
        pint_rule_table.columns(0)
        .search(keyword, /** regex */true, /** smart */false)
        .draw();
      }
    }
    else {
      rule_table.clear();
      if (RuleRows && RuleRows.length > 0) {
        rule_table.rows.add(RuleRows);
        if ('rule' === _frame2) {
          rule_table.columns(0)
          .search('^.*$', /** regex */true, /** smart */false)
          .draw();
        }
        else {
          switch (_frame2) {
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
      }
    }
  }
}
// -----------------------------------------------------------------
// Formatting function for row details
//
function find(table_id, col, word) {
  var table = $(table_id).DataTable(),
      keys, vals, tableRows, nums_ = {};
  if ('#pint' === table_id) {
    tableRows = PintRows;
  }
  else if ('#pint-rule' === table_id) {
    tableRows = PintRuleRows;
  }
  else if ('#en' === table_id) {
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
function renderDatatype(row) {
  var datatype;
  datatype = ''+row.DT;
  datatype = datatype.trim();
  datatype = datatypeMap[datatype] || datatype;
  return datatype;
}
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
// PINT
function renderBT_PINT(row,lang) {
  var term,
      card = row.Card,
      level = row.Level,
      match,
      res = '';
  term = row.BT;
  if (!term) {
    return '';
  }
  if (lang && 'ja' == lang) {
    term = row.BT_ja;
  }
  for (var i = 1; i < level; i++) {
    res += '+';
  }
  if (level >= 1) {
    res += ' ';
  }
  if (card.match(/^1/)) {
    term = '<b>'+term+'</b>';
  }
  res = res += term;
  return res;
}
function renderDesc_PINT(row, lang) {
  var desc;
  if ('ja' === lang) {
    desc = row.Desc_ja;
  }
  else {
    desc = row.Desc;
  }
  if (desc && !desc.match(/^\[[a-z]+\]/)) {
    match = row.Desc.match(/^\[[a-z]+\]/);
    if (match) {
      desc = match[0]+' '+desc;
    }
  }
  if (desc && desc.length > 0) {
    desc = desc.split('\\n').join('<br/>')
  }
  return desc
}
pint_columns = [
  { 'width': '3%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'width': '10%',
    'data': 'EN_ID' }, // 1
  { 'width': '10%',
    'data': 'PINT_ID' }, // 2
  { 'width': '44%',
    'data': 'BT',
    'render': function(data, type, row) {
      var term = renderBT_PINT(row);
      return term; }}, // 3
  { 'width': '44%',
    'data': 'BT_ja',
    'render': function(data, type, row) {
      var term = renderBT_PINT(row, 'ja');
      return term; }}, // 4   
  { 'width': '10%',
    'data': 'DT',
    'render': function(data, type, row) {
      var datatype = renderDatatype(row);
      return datatype; } }, // 5
  { 'width': '5%',
    'data': 'Card' }, // 6
  { 'width': '10%',
    'data': 'Rules' }, // 7
  { 'width': '5%',
    'className': 'rule-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fa fa-link"></i>' }, // 8
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 9
];
pint_columnDefs = [
  { 'searchable': false, 'targets': [0, 8, 9] }/*,
  { 'visible': false, 'targets': 1 }*/
];
COL_pint_rule_infocontrol = 3;
pint_rule_columns = [ // ID Desc Desc_ja BusinessTerm
  { 'width': '12%',
    'data': 'ID' }, // 0
  { 'width': '60%',
    'data': 'Desc',
    'render': function(data, type, row) {
      var desc = renderDesc_PINT(row);
      return desc; }}, // 1
  { 'width': '60%',
    'data': 'Desc_ja',
    'render': function(data, type, row) {
      var desc = renderDesc_PINT(row, 'ja');
      return desc; }}, // 2
  { 'width': '20%',
    'data': 'BusinessTerm' }, // 3
  { 'width': '5%',
    'className': 'rule-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fa fa-link"></i>' }, // 4
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 5
];
rpint_ule_columnDefs = [
  { 'searchable': false, 'targets': [4,5] }
  // { 'visible': false, 'targets': 2 }
];
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
    'className': 'rule-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fa fa-link"></i>' }, // 6
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
// -------------------------------------------------------------------
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
  { 'width': '20%',
    'data': 'BusinessTerm' }, // 2
  // { 'width': '20%',
  //   'data': 'Target' }, // 3
  { 'width': '5%',
    'className': 'rule-control',
    'orderable': false,
    'data': null,
    'defaultContent': '<i class="fa fa-link"></i>' }, // 3
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 4
];
rule_columnDefs = [
  { 'searchable': false, 'targets': [3,4] }
  // { 'visible': false, 'targets': 2 }
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
// -------------------------------------------------------------------
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
  // Table initialize for PINT
  // -----------------------------------------------------------------
  function tableInitPINT(json) {
    var data, i, item, id, level, seq, num,
        // prev_item = {},
        idxLevel = [], rows = [];
    PintNums = [];
    PintMap = new Map();
    PintMap2 = new Map();
    /** item = { EN_ID,PINT_ID,BT,BT_ja,DT,Card,Desc,Desc_ja,Section,Path,Attr,num,seq };*/
    idxLevel[0] = '0';
    data = json;
    if (! data || 0 === data.length) {
      return;
    }
    for (i = 0; i < data.length; i++) {
      item = data[i];
      id = item.PINT_ID;
      seq = i;
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
      rows.push(item);
      PintNums.push(num);
      PintMap.set(id, item);
    }
    var pint_id, data, rules, rule_id;
    if (!RuleIDs) {
      RuleIDs = {};
    }
    for (var [key, data] of Object.entries(PintMap)) {
      pint_id = data.PINT_ID;
      if (!RuleIDs[pint_id]) {
        RuleIDs[pint_id] = {};
      }
      rules = data.Rules.split(',');
      for (var i = 0; i < rules.length; i++) {
        rule_id = rules[i];
        RuleIDs[pint_id][rule_id] = true;
      }
    }
    PintRows = rows;
    filterRoot('#pint');
    checkDetails('#pint');
    return rows; // promise.then
  }
  function tableInitPintRule() {
    var data = [],
        item,
        seq, num,
        desc, match, bts,
        term, pos, terms,
        rule_id, seq, num,
        desc, match, bt, bts,
        term, pos, terms,
        pint_id, data, rules, rule_id,
        BT_IDs,
        rows = [];
    
  /** item = { num,ID,Desc,Desc_ja,BusinessTerm }; */
    PintRuleMap = new Map();
    PINT_RULES.map(function(d) { data.push(d); });
    JP_PINT_RULES.map(function(d) { data.push(d); });
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      rule_id = item.ID;
      seq = i;
      item.seq = seq;
      num = ''+seq;
      item.num = num;
      desc = item.Desc;
      terms = {};
      bt = item.BusinessTerm;
      if (bt) {
        bts = bt.split(' ');
        for (var _bt of bts) {
          terms[_bt] = true;
        }
      }
      pos = 1;
      while (pos>0){
        match = desc.match(/(ib[gt]|B[TG])-[0-9]*/);
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
      
      BT_IDs = item.BusinessTerm.split(' ');
      for (var i = 0; i < BT_IDs.length; i++) {
        pint_id = BT_IDs[i];
        if (!RuleIDs) {
          RuleIDs = {};
        }
        if (!RuleIDs[pint_id]) {
          RuleIDs[pint_id] = {};
        }
        RuleIDs[pint_id][rule_id] = true
      }
      rows.push(item);
      PintRuleMap.set(rule_id, item);
    }

    pint_rule_table.clear();
    pint_rule_table.rows
    .add(rows)
    .draw();
    PintRuleRows = rows;
  }
  // -----------------------------------------------------------------
  pint_rule_table = $('#pint-rule').DataTable({
    'columns': pint_rule_columns,
    'columnDefs': pint_rule_columnDefs,
    'paging': true,
    'autoWidth': false,
    'ordering': false,
    'select': true
  });
  // -----------------------------------------------------------------
  // PINT
  pint_table = $('#pint').DataTable({
    'columns': pint_columns,
    'columnDefs': pint_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#pint');
    }  
  });
  ajaxRequest('data/pint2ubl.json', null, 'GET', 500)
  .then(function(res) {
    try {
      var json = JSON.parse(res);
      return tableInitPINT(json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    pint_table.clear();
    pint_table.rows
    .add(rows)
    .draw();
    PintRows = rows;
  })
  .then(function() {
    filterRoot('#pint');
  })
  .catch(function(err) { console.log(err); })
  // PINT RULES
  ajaxRequest('data/rules/pint_rules.json', null, 'GET', 600)
  .then(function(res) {
    try {
      PINT_RULES = JSON.parse(res);
      pint_rule_count--;
      if (0 === pint_rule_count) {
        tableInitPintRule();
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // JP-PINT RULES
  ajaxRequest('data/rules/jp-pint_rules.json', null, 'GET', 700)
  .then(function(res) {
    try {
      JP_PINT_RULES = JSON.parse(res);
      pint_rule_count--;
      if (0 === pint_rule_count) {
        tableInitPintRule();
      }
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // -----------------------------------------------------------------
  // Table initialize
  // -----------------------------------------------------------------
  function tableInitEN(json) {
  var data, i, item, level, seq, num,
      // prev_item = {},
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
    // item.BusinessTerm = item.BusinessTerm || '';
    // item.Desc = item.Desc || '';
    // item.UsageNote = item.UsageNote || '';
    // item.ReqID = item.ReqID || '';
    // item.ReqID = item.ReqID.replaceAll(',',' ');
    // item.SemanticDataType = item.SemanticDataType || '';
    rows.push(item);
    EnNums.push(num);
    EnMap.set(seq, item);
    EnMap2.set(num, item);
    // prev_item = item;
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
  }
  // -----------------------------------------------------------------
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
  ajaxRequest('data/rules/EN_16931-1_table2_ja.json', null, 'GET', 800)
  .then(function(res) {
    try {
      TABLE2_JA = JSON.parse(res);
    }
    catch(e) { console.log(e); }
  })
  .catch(function(err) { console.log(err); });
  // RULES
  ajaxRequest('data/rules/EN_16931-1_rules_ja.json', null, 'GET', 900)
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
  ajaxRequest('data/rules/EN_16931-1_rules2.json', null, 'GET', 1100)
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
  ajaxRequest('data/rules/EN_16931-1_table2.json', null, 'GET', 1200)
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
  // -----------------------------------------------------------------
  // Add event listener for finding related
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td.rule-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_table.row(tr);
    en_find(row.data());
    $('#en tbody tr td').removeClass('active');
    tr[0].children[1].classList.add('active');
  });
  // Rule
  $('#rule tbody').on('click', 'td.rule-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = rule_table.row(tr), info;
    rule_find(row.data());
    $('#rule tbody tr td').removeClass('active');
    tr[0].firstElementChild.classList.add('active');
  });
  // -----------------------------------------------------------------
  // Add event listener for information
  // -----------------------------------------------------------------
  // EN
  $('#en tbody').on('click', 'td.info-control', function(event) {
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
  $('#rule tbody').on('click', 'td.info-control', function(event) {
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
  $('#en tbody').on('click', 'td:not(.info-control, .rule-control)', function (event) {
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

  pint_colBT = pint_table.column(COL_pint['BT']);
  pint_colBT_ja = pint_table.column(COL_pint['BT_ja']);
  pint_rule_colDesc = pint_rule_table.column(COL_pint_rule['Desc']);
  pint_rule_colDesc_ja = pint_rule_table.column(COL_pint_rule['Desc_ja']);

  setTimeout(function() {
    setMenu(1);
    setFrame('pint', 'jp-pint');
    changeLanguage();
  }, 500);
}
// rules.js