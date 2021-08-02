/**
 * pint.js
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
 var en2x_columns, en2x_columnDefs, x2en_columns, x2en_columnDefs,
    pint2ubl_columns, pint2ubl_columnDefs, ubl2pint_columns, ubl2pint_columnDefs,
    pint2ubl_table, ubl2pint_table,
    en2cii_table, cii2en_table,
    en_ivc2ubl_table, ubl2en_ivc_table,
    en_cnt2ubl_table, ubl2en_cnt_table,
    Pint2UblMap, Ubl2PintMap, Ubl2PintNums,
    En2CiiMap, Cii2EnMap, Cii2EnNums,
    EnIvc2UblMap, Ubl2EnIvcMap, Ubl2EnIvcNums,
    EnCnt2UblMap, Ubl2EnCntMap, Ubl2EnCntNums,
    expandedRows, collapsedRows,
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
  UBL_IVC, UBL_CNT, UBL_CBC, UBL_CAC,
  CII_CII, CII_ABIE, CII_CCT, CII_QDT, CII_UDT,
  Lang,
  COL_pint2ubl = {
    'EN_ID':1,'PINT_ID':2,'BT':3,'BT_ja':4,'DT':5,'Card':6,'Desc':7,'Desc_ja':8,'Section':9,'Path':10,'Attr':11
  },
  COL_ubl2pint = {
    'Path':2,'Attr':3,'Section':4,'EN_ID':5,'PINT_ID':6,'BT':7,'BT_ja':8,'DT':9,'Card':10
  },
  pint2ubl_colBT, pint2ubl_colBT_ja,
  ubl2pint_colBT, ubl2pint_colBT_ja;

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
  pint2ubl_colBT.visible(en);
  ubl2pint_colBT.visible(en);
  pint2ubl_colBT_ja.visible(ja);
  ubl2pint_colBT_ja.visible(ja);
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
    setFrame('pint2ubl')
  }
  else { // pint is active
    $('.tablinks.en.title').addClass('active');
    $('.tablinks.en').css('display', 'block');
    $('.tablinks.pint.title').removeClass('active');
    $('.tablinks.pint').css('display', 'none');
    setFrame('en_ivc2ubl')
  }
}

function setFrame(table_id) {
  var top_container, table_frame, child, id, match, base;
  // save current content to backup.
  // top
  top_container = $('#root-container');
  // backup
  if (top_container.children().length > 0) {
    child = top_container.children();
    if (child) {
      id = child.attr('id');
      match = id.match(/^(.*)-frame$/);
      id = match[1];
      base = $('#'+id+'-container');
      table_frame = $('#'+id+'-frame');
      base.append(table_frame);
    }
  }
  table_frame = $('#'+table_id+'-frame');
  top_container.append(table_frame);
  $('.tablinks:not(.title)').removeClass('active');
  $('.tablinks:not(.title).'+table_id).addClass('active');
  if (table_id.match(/pint/)) {
    $('.tab .language').show();
  }
  else {
    $('.tab .language').hide();
  }
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
function en2x_format(d, kind) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 50, H2 = 50,
    desc = d.EN_Desc,
    path = d.Path,
    match = d.Match,
    rule = d.Rules,
    pathArray,
    padding = '',
    html = '',
    wk_path = '',
    wk_desc;
  return googleTranslate(desc)
  .then(function(translations) {
    var j_desc = translations[0].translatedText;      
    pathArray = path.split('/');
    wk_path = 'Path: ';
    for (var i = 1; i < pathArray.length; i++) {
      wk_path += padding + pathArray[i]+'<br>';
      padding += '&nbsp;&nbsp;&nbsp;';
    }
    wk_desc = (match ? lookupAlignment(match) : '') +
      (rule ? 'Rule:&nbsp;&nbsp;'+rule : '');
    html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
      '<colgroup>'+
        '<col style="width:'+H1+'%;">'+
        '<col style="width:'+H2+'%;">'+
      '</colgroup>'+
      '<tr>'+
        '<td valign="top">'+desc+'</td>'+
        '<td valign="top">'+
          wk_path + wk_desc+'</td>'+
      '</tr>';
    if (j_desc) {
      html += '<tr><td valign="top" colspan="2">'+j_desc+'</td></tr>';
    }
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); });
}
function x2en_format(d, kind) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 25, H2 = 40, H3 = 35,
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
  base = base ? ' ( '+base+' ) ' : '';
  cardinality = _child['Cardinality'] || '';
  cardinality = cardinality ? ' [ '+cardinality+' ]' : '';
  definition =  _child['Definition'] || '';

  return googleTranslate([desc_en, definition])
  .then(function(translations) {
    var translatedText = translations[0].translatedText,
        match, j_desc, j_definition;
    match = translatedText.match(/.(\&quot;|「)(.*)(\&quot;|」)、.*(\&quot;|「)(.*)(\&quot;|」)./);
    if (match) {
      j_desc = match[2];
      j_definition = match[5];
    }
    desc_x = den + cardinality+'<br>'+
              (datatype 
                ? (datatype + base)
                : 'cii' === kind
                  ? ''
                  : 'pint' === kind
                    ? d.CCL_ID
                    : 'Aggregate'
              )+'<br>'+
              definition;
    html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
      '<colgroup>'+
        '<col style="width:'+H1+'%;">'+
        '<col style="width:'+H2+'%;">'+
        '<col style="width:'+H3+'%;">'+
      '</colgroup>' +
      '<tr>'+
        '<td valign="top">'+paths+'</td>';
    if (desc_x && desc_en) {
      html += '<td valign="top">'+desc_x+'</td>'+
        '<td valign="top">'+desc_en+'</td></tr>';
    }
    else if (desc_x) {
      html += '<td valign="top" colspan="2">'+desc_x+'</td></tr>';
    }
    else if (desc_x && desc_en) {
      html += '<td valign="top" colspan="2">'+desc_en+'</td></tr>';
    }
    // tranlation
    if (j_desc && j_definition) {
      html += '<tr>'+
        '<td valign="top" colspan="2">'+j_definition+'</td>'+
        '<td valign="top">'+j_desc+'</td>'+
      '</tr>';
    }
    else if (j_desc) {
      html += '<tr><td valign="top" colspan="3">'+j_desc+'</td></tr>';
    }
    else if (j_definition) {
      html += '<tr><td valign="top" colspan="3">'+j_definition+'</td></tr>';
    }
    html += '</table>';
    return html;
  })
  .catch(function(err) { console.log(err); });
}
function pint2ubl_format(d) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 50, H2 = 50,
    desc = d.Desc,
    desc_ja = d.Desc_ja,
    explanation = d.Exp,
    explanation_ja = d.Exp_ja,
    example = d.Example,
    extension = d.Extension,
    path = d.Path,
    rules = d.Rules,
    pathArray,
    padding = '',
    html = '',
    wk_path = '',
    Lang = $('div#tab-1 p.language.use').text();

  wk_path = '/'+path.substring(1,path.length).split('/').join('/ ');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>'+
      '<col style="width:'+H1+'%;">'+
      '<col style="width:'+H2+'%;">'+
    '</colgroup>';
  if ('en' == Lang) {
    html += '<tr>'+
      '<td valign="top">'+
        (desc ? desc.split('\\n').join('<br/>')+'<br/>' : '')+
        (explanation ? '<b>[Additional explanation]</b> '+explanation.split('\\n').join('<br/>')+'<br/>' : '')+'</td>'+
      '<td valign="top">'+
        wk_path+'<br/>'+
        (example ? '<b>[Example]</b> '+example : '')+
        (extension ? '<b>[Extension]</b> '+extension : '')+
        (rules ? '<b>[Rules]</b> '+rules+'<br/>' : '')+'</td>'+
    '</tr>';
  }
  else if ('ja' == Lang) {
    html += '<tr>'+
      '<td valign="top">'+
        (desc_ja ? desc_ja.split('\\n').join('<br/>')+'<br/>' : '')+
        (explanation_ja ? '<b>[追加説明]</b> '+explanation_ja.split('\\n').join('<br/>')+'<br/>' : '')+'</td>'+
      '<td valign="top">'+
        wk_path+'<br/>'+
        (example ? '<b>[例]</b> '+example : '')+
        (extension ? '<b>[拡張]</b> '+extension : '')+
        (rules ? '<b>[ビジネスルール]</b> '+rules+'<br/>' : '')+'</td>'+
    '</tr>';
  }
  html += '</table>';
  return html;
}
function ubl2pint_format(d) { // d is the original data object for the row
  if (!d) { return null; }
  var H1 = 50, H2 = 50,
    desc = d.Desc,
    desc_ja = d.Desc_ja,
    explanation = d.Exp,
    explanation_ja = d.Exp_ja,
    example = d.Example,
    extension = d.Extension,
    paths = d.Paths,
    // path = d.Path,
    rules = d.Rules,
    // pathArray,
    // padding = '',
    html,
    wk_path,
    Lang = $('div#tab-1 p.language.use').text();

  // wk_path = '/'+path.substring(1,path.length).split('/').join('/ ');
  wk_path = '/'+paths.replace(/&nbsp;/g,'').replace(/<br>c/g,'/ c').replace(/<br>$/,'')
  desc = (desc ? desc.split('\\n').join('<br/>')+'<br/>' : '');
  desc_ja = (desc_ja ? desc_ja.split('\\n').join('<br/>')+'<br/>' : '');

  explanation = (explanation ? '<b>[Additional explanation]</b> '+explanation.split('\\n').join('<br/>')+'<br/>' : '');
  explanation_ja = (explanation_ja ? '<b>[追加説明]</b> '+explanation_ja.split('\\n').join('<br/>')+'<br/>' : '');
  html = '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'+
    '<colgroup>'+
      '<col style="width:'+H1+'%;">'+
      '<col style="width:'+H2+'%;">'+
    '</colgroup>';
  if ('en' == Lang) {
    html += '<tr>'+
      '<td valign="top">'+
        wk_path+'<br/>'+
        (example ? '<b>[Example]</b> '+example : '')+
        (extension ? '<b>[Extension]</b> '+extension : '')+
        (rules ? '<b>[Rules]</b> '+rules+'<br/>' : '')+'</td>'+
      '<td valign="top">'+desc+explanation+'</td>'+
    '</tr>';
  }
  else if ('ja' == Lang) {
    html += '<tr>'+
      '<td valign="top">'+
        wk_path+'<br/>'+
        (example ? '<b>[例]</b> '+example : '')+
        (extension ? '<b>[拡張]</b> '+extension : '')+
        (rules ? '<b>[ビジネスルール]</b> '+rules+'<br/>' : '')+'</td>'+
      '<td valign="top">'+
        (desc_ja ? desc_ja.split('\\n').join('<br/>')+'<br/>' : '')+
        (explanation_ja ? '<b>[追加説明]</b> '+explanation_ja.split('\\n').join('<br/>')+'<br/>' : '')+'</td>'+
    '</tr>';
  }
  html += '</table>';
  html = html.replace(/<br\/>/g, '<br/>')
  return html;
}
// -----------------------------------------------------------------
//
function renderBT(row) {
  var term,
      card = row.EN_Card,
      level = row.EN_Level,
      res = '';
  term = row.EN_BT;
  for (var i = 1; i < level; i++) {
    res += '+';
  }
  if (level > 1) {
    res += ' ';
  }
  if (card.match(/^1/)) {
    term = '<b>'+term+'</b>';
  }
  res = res += term;
  return res;
}
function renderDatatype(row) {
  var datatype;
  datatype = ''+row.DT;
  datatype = datatype.trim();
  datatype = datatypeMap[datatype] || datatype;
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
    res = parent+' / ';
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
function renderDesc(row) {
  var desc;
  desc = row.EN_Desc;
  desc = desc.split('\\n').join('<br/>')
  return desc
}
// -----------------------------------------------------------------
// EN_Parent EN_ID EN_Level EN_Card EN_BT EN_Desc DT
// Path Type Card Match Rules
en2x_columns = [
  { 'width': '2%',
  'className': 'details-control',
  'orderable': false,
  'data': null,
  'defaultContent': '' }, // 0
  { 'width': '6%',
  'data': 'EN_ID' }, // 1 
  { 'width': '28%',
  'data': 'EN_BT',
  'render': function(data, type, row) {
    var term = renderBT(row);
    return term; } }, // 2
  { 'width': '10%',
  'data': 'DT',
  'render': function(data, type, row) {
    var datatype = renderDatatype(row);
  return datatype; }}, // 3
  { 'width': '4%',
  'data': 'EN_Card' }, // 4
  { 'width': '44%',
  'data': 'Path',
  'render': function(data, type, row) {
    var path = renderPath(row);
    return path; }}, // 5
  { 'width': '4%',
  'data': 'Card' }, // 6
  { 'width': '3%',
  'className': 'info-control',
  'orderable': false,
  'data': null,
  'defaultContent': '' } // 7
];
en2x_columnDefs = [
  { 'searchable': false, 'targets': [0, 7] }
];
// -----------------------------------------------------------------
function renderBT_PINT(row,lang) {
  var term,
      card = row.Card,
      level = row.Level,
      res = '';
  term = row.BT;
  if (lang && 'ja' == lang) {
    term = row.BT_ja;
  }
  for (var i = 0; i < level; i++) {
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
  desc = row.Desc;
  if (lang && 'ja' == lang) {
    desc = row.Desc_ja;
  }
  desc = desc.split('\\n').join('<br/>')
  return desc
}
pint2ubl_columns = [
  { 'width': '2%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'width': '7%',
    'data': 'EN_ID' }, // 1 
  { 'width': '8%',
    'data': 'PINT_ID' }, // 2
  { 'width': '30%',
    'data': 'BT',
    'render': function(data, type, row) {
      var term = renderBT_PINT(row);
      return term; } }, // 3
  { 'width': '30%',
      'data': 'BT_ja',
      'render': function(data, type, row) {
        var term = renderBT_PINT(row, 'ja');
        return term; }}, // 4
  { 'width': '5%',
    'data': 'DT',
    'render': function(data, type, row) {
      var datatype = renderDatatype(row);
      return datatype; }}, // 5
  { 'width': '5%',
    'data': 'Card' }, // 6
  { 'width': '5%',
    'data': 'Section' }, // 7
  { 'width': '25%',
    'data': 'Path',
    'render': function(data, type, row) {
      var path = renderPath(row);
      return path; }}, // 8
  { 'width': '5%',
    'data': 'Attr' }, // 9
  { 'width': '3%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 10
];
pint2ubl_columnDefs = [
  { 'searchable': false, 'targets': [0, 10] },
  { 'visible':false, 'targets': [COL_pint2ubl.BT_ja]}
];
// -------------------------------------------------------------------
x2en_columns = [
  { 'width': '2%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'data': 'num' }, // 1
  { 'width': '44%',
    'data': 'Path',
    'render': function(data, type, row) {
      var path = row.Path || '';
      if (0 === row.seq) { path = '<b>'+path+'</b>'; }
      else if (row.Card && row.Card.match(/^1/)) {
        path = path.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
      }
      return path; }}, // 2
  { 'width': '4%',
    'data': 'Card' }, // 3
  { 'width': '6%',
    'data': 'EN_ID' }, // 4
  { 'width': '28%',
    'data': 'EN_BT' }, // 5
  { 'width': '10%',
    'data': 'DT',
    'render': function(data, type, row) {
      var datatype = renderDatatype(row);
      return datatype; }}, // 6
  { 'width': '4%',
    'data': 'EN_Card' }, // 7
  { 'width': '2%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 8
];
x2en_columnDefs = [
  { 'searchable': false, 'targets': [0, 8] },
  { 'visible': false, 'targets': 1 }
];
// -------------------------------------------------------------------
ubl2pint_columns = [
  { 'width': '2%',
    'className': 'details-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' }, // 0
  { 'data': 'num' }, // 1
  { 'width': '30%',
    'data': 'Path',
    'render': function(data, type, row) {
      var path = row.Path || '';
      if (0 === row.seq) { path = '<b>'+path+'</b>'; }
      else if (row.Card && row.Card.match(/^1/)) {
        path = path.replace(/^([\+]* )(.*)?/, "$1<b>$2</b>")
      }
      return path; }}, // 2
  { 'width': '10%',
    'data': 'Attr' }, // 3
  { 'width': '5%',
    'data': 'Section' }, // 4
  { 'width': '5%',
    'data': 'EN_ID' }, // 5
  { 'width': '5%',
    'data': 'PINT_ID' }, // 6
  { 'width': '30%',
    'data': 'BT',
    'render': function(data, type, row) {
      var term = renderBT_PINT(row);
      return term; } }, // 7
  { 'width': '30%',
    'data': 'BT_ja',
    'render': function(data, type, row) {
      var term = renderBT_PINT(row, 'ja');
      return term; } }, // 8
  { 'width': '5%',
    'data': 'DT',
    'render': function(data, type, row) {
      var datatype = renderDatatype(row);
      return datatype; }}, // 9
  { 'width': '5%',
    'data': 'Card' }, // 10
  { 'width': '2%',
    'className': 'info-control',
    'orderable': false,
    'data': null,
    'defaultContent': '' } // 11
];
ubl2pint_columnDefs = [
  { 'searchable': false, 'targets': [0, 11] },
  { 'visible': false, 'targets': [1, COL_ubl2pint.BT_ja] }
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
  var table, records, rows;
  table = $(table_id).DataTable();
  records = [];
  rows = [];
  records = table.data().toArray()
  for (var v of records) {
    if ('#pint2ubl' == table_id) {
      if (v.Level <='1') {
        rows.push(v);
      }
    }
    else if (table_id.match(/^#ubl2pint$/) ||
        table_id.match(/^(#cii2en|#ubl2en_ivc|#ubl2en_cnt)$/)) {
      if (v.num.split('_').length < 3) {
        rows.push(v);
      }
    }
    else {
      if (v.EN_Parent && 'root' === v.EN_Parent) {
        rows.push(v);
      }
    }
  }

  table.clear();
  table.rows
  .add(rows)
  .draw();

  // if ('#ubl2pint' === table_id ||
  //   '#cii2en' === table_id ||
  //   '#ubl2en_ivc' === table_id ||
  //   '#ubl2en_cnt' === table_id) {
  $(table_id +' tbody tr')[0].classList.add('expanded');
  // }
}
// -------------------------------------------------------------------
function checkDetails(table_id) {
  var table = $(table_id).DataTable(),
      data = table.data(),
      tr_s, tr, // nextSibling,
      row, row_data, num, i, nums,// nextrow, nextrow_data,
      rgx;
  tr_s = $(table_id+' tbody tr');
  if (data.length > 0) {
    if (table_id.match(/^#(en2pint|pint2ubl)$/)) {
      for (var tr of tr_s) {
        row = table.row(tr);
        row_data = row.data();
        if (row_data.EN_ID.match(/^BT/)/* ||
            row_data.PINT_ID.match(/^ibt/)*/) {
          tr.childNodes[0].classList = '';
        }
      }
    }
    else if (table_id.match(/pint/) ||
              table_id.match(/cii/) ||
              table_id.match(/ubl/)) {
      if (table_id.match(/cii/)) {
        nums = Cii2EnNums;
      }
      else if (table_id.match(/en_ivc/)) {
        nums = Ubl2EnIvcNums;
      }
      else if (table_id.match(/en_cnt/)) {
        nums = Ubl2EnCntNums;
      }
      else if (table_id.match(/pint/)) {
        nums = Ubl2PintNums;
      }
      if (!nums) {
        return null;
      }
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
      row, row_data, rows, rows_, id, i, 
      res,
      collapse = null,
      expand = null,
      v, rgx;
  // -----------------------------------------------------------------
  function isExpanded(rows, num) {
    var expanded = false,
        i, rgx, count = 0;
    if ('pint' === table_id.substr(1, 4) ||
        'en' === table_id.substr(1, 2) ||
        'cii' === table_id.substr(1, 3) ||
        'ubl' === table_id.substr(1, 3)) {
      rgx = RegExp('^'+num+'_[^_]+$')
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
  // -----------------------------------------------------------------
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
  var tr_s = $(table_id+' tbody tr');
  for (var tr of tr_s) {
    row = table.row(tr);
    row_data = row.data();
    nextSibling = tr.nextSibling;
    if (nextSibling) {
      nextrow = table.row(nextSibling);
      nextrow_data = nextrow.data();
      rgx = RegExp('^'+row_data.num+'[_-].+$');
      if (nextrow_data.num.match(rgx)) {
        tr.classList.add('expanded');
      }
    }
  }
  }
}
// -------------------------------------------------------------------
function translateInfo() {
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
}
// -------------------------------------------------------------------
var initModule = function () {
  // -----------------------------------------------------------------
  function en2x_tableInit(table_id, json) {
    var map,
        data, i, item, level, seq, num,
        idxLevel = [],
        numMap = new Map();
    data = json.data;
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = item.num;
      level = item.EN_Level - 1;
      num = ''+seq;
      if (level > 0) {
        num = idxLevel[level - 1]+'_'+num;
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
  function x2en_tableInit(table_id, json) {
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
      num = ''+seq;
      paths = item.Path.split('/');
      if (paths.length > 1) {
        for (var i = 1; i < paths.length; i++) {
          wk_path += padding + paths[i]+'<br>';
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
          num = idxLevel[level - 1]+'_'+num;
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
        Cii2EnNums = nums;
        break;
      case '#ubl2en_ivc':
        Ubl2EnIvcMap = map;
        Ubl2EnIvcNums = nums;
        break;
      case '#ubl2en_cnt':
        Ubl2EnCntMap = map;
        Ubl2EnCntNums = nums;
        break;
    }
    return rows;
  }
  function pint2ubl_tableInit(table_id, json) {
    var map, data,
        i, item, level, seq, num,
        idxLevel = [],
        nums = [];
        rows = [];
    map = new Map();
    data = json;
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = i;
      item.seq = seq;
      level = item.Level - 1;
      num = ''+seq;
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
    Pint2UblMap = map;
    Pint2UblNums = nums;
    filterRoot(table_id);
    checkDetails(table_id);
    return rows;
  }
  function ubl2pint_tableInit(table_id, json) {
    var map, nums,
        data, item,
        seq, paths, padding = '', wk_path = '',
        level, num, name, term, i,
        rows = [],
        idxLevel = [];
    data = json;
    map = new Map();
    nums = [];
    for (i = 0; i < data.length; i++) {
      item = data[i];
      seq = i;
      item.seq = seq;
      num = ''+seq;
      paths = item.Path.split('/');
      if (paths.length > 1) {
        for (var i = 1; i < paths.length; i++) {
          wk_path += padding + paths[i]+'<br>';
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
    Ubl2PintMap = map;
    Ubl2PintNums = nums;
    return rows;
  }
  // -----------------------------------------------------------------
  // PINT2UBL
  pint2ubl_table = $('#pint2ubl').DataTable({
    'columns': pint2ubl_columns,
    'columnDefs': pint2ubl_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#pint2ubl');
    }
  });
  ajaxRequest('data/pint2ubl.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      json = JSON.parse(res);
      return pint2ubl_tableInit('#pint2ubl', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    pint2ubl_table.clear();
    pint2ubl_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#pint2ubl');
  })
  .catch(function(err) { console.log(err); });
  // UBL2PINT
  ubl2pint_table = $('#ubl2pint').DataTable({
    'columns': ubl2pint_columns,
    'columnDefs': ubl2pint_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#ubl2pint');
    }  
  });
  ajaxRequest('data/ubl2pint.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      json = JSON.parse(res);
      return ubl2pint_tableInit('#ubl2pint', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    ubl2pint_table.clear();
    ubl2pint_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#ubl2pint');
  })
  .catch(function(err) { console.log(err); })
  // -----------------------------------------------------------------
  // EN2CII
  en2cii_table = $('#en2cii').DataTable({
    'ajax': 'data/en2cii.json',
    'columns': en2x_columns,
    'columnDefs': en2x_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'initComplete': function(settings, json) {
      En2CiiMap = en2x_tableInit('#en2cii', json);
    },
    'drawCallback': function(settings) {
      checkDetails('#en2cii');
    }  
  });
  // EN_IVC2UBL
  en_ivc2ubl_table = $('#en_ivc2ubl').DataTable({
    'ajax': 'data/en_ivc2ubl.json',
    'columns': en2x_columns,
    'columnDefs': en2x_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'initComplete': function(settings, json) {
      EnIvc2UblMap = en2x_tableInit('#en_ivc2ubl', json);
    },
    'drawCallback': function(settings) {
      checkDetails('#en_ivc2ubl');
    }  
  });
  // EN_IVC2UBL
  en_cnt2ubl_table = $('#en_cnt2ubl').DataTable({
    'ajax': 'data/en_cnt2ubl.json',
    'columns': en2x_columns,
    'columnDefs': en2x_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'initComplete': function(settings, json) {
      EnCnt2UblMap = en2x_tableInit('#en_cnt2ubl', json);
    },
    'drawCallback': function(settings) {
      checkDetails('#en_cnt2ubl');
    }  
  });
  // -----------------------------------------------------------------
  // CII2EN
  cii2en_table = $('#cii2en').DataTable({
    'columns': x2en_columns,
    'columnDefs': x2en_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#cii2en');
    }  
  });
  ajaxRequest('data/cii2en.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      json = JSON.parse(res);
      return x2en_tableInit('#cii2en', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    cii2en_table.clear();
    cii2en_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#cii2en');
  })
  .catch(function(err) { console.log(err); })
  // UBL2EN_IVC
  ubl2en_ivc_table = $('#ubl2en_ivc').DataTable({
    'columns': x2en_columns,
    'columnDefs': x2en_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#ubl2en_ivc');
    }  
  });
  ajaxRequest('data/ubl2en_ivc.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      json = JSON.parse(res);
      return x2en_tableInit('#ubl2en_ivc', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    ubl2en_ivc_table.clear();
    ubl2en_ivc_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#ubl2en_ivc');
  })
  .catch(function(err) { console.log(err); })
  // UBL2EN_CNT
  ubl2en_cnt_table = $('#ubl2en_cnt').DataTable({
    'columns': x2en_columns,
    'columnDefs': x2en_columnDefs,
    'paging': false,
    'autoWidth': false,
    'ordering': false,
    'select': true,
    'drawCallback': function(settings) {
      checkDetails('#ubl2en_cnt');
    }  
  });
  ajaxRequest('data/ubl2en_cnt.json', null, 'GET', 1000)
  .then(function(res) {
    try {
      json = JSON.parse(res);
      return x2en_tableInit('#ubl2en_cnt', json);
    }
    catch(e) { console.log(e); }
  })
  .then(function(rows) {
    ubl2en_cnt_table.clear();
    ubl2en_cnt_table.rows
    .add(rows)
    .draw();
  })
  .then(function() {
    filterRoot('#ubl2en_cnt');
  })
  .catch(function(err) { console.log(err); })
  // -----------------------------------------------------------------
  // Add event listener for opening and closing info
  // -----------------------------------------------------------------
  // EN2CII
  $('#en2cii tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = en2cii_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      en2x_format(row.data(), 'cii')
      .then(function(html) {
        row.child(html).show(); tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // EN_IVC2UBL
  $('#en_ivc2ubl tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = en_ivc2ubl_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      en2x_format(row.data())
      .then(function(html) {
        row.child(html).show(); tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // EN_CNT2UBL
  $('#en_cnt2ubl tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = en_cnt2ubl_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      en2x_format(row.data())
      .then(function(html) {
        row.child(html).show(); tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // PINT2UBL
  $('#pint2ubl tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = pint2ubl_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      var html = pint2ubl_format(row.data());
      row.child(html).show(); tr.addClass('shown');
    }
  });
  // ----------------------------------------------------------------- 
  // CII2EN
  $('#cii2en tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = cii2en_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      x2en_format(row.data(), 'cii')
      .then(function(html) {
        row.child(html).show(); tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
    }
  });
  // UBL2EN_IVC
  $('#ubl2en_ivc tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = ubl2en_ivc_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      x2en_format(row.data())
      .then(function(html) {
        row.child(html).show(); tr.addClass('shown');
      })
      .catch(function(err) { console.log(err); });
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
    x2en_format(row.data())
    .then(function(html) {
      row.child(html).show(); tr.addClass('shown');
    })
    .catch(function(err) { console.log(err); });
  }
  });
  // UBL2PINT
  $('#ubl2pint tbody').on('click', 'td.info-control', function(event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'), row = ubl2pint_table.row(tr);
    if (row.child.isShown()) { // This row is already open - close it
      row.child.hide(); tr.removeClass('shown');
    }
    else { // Open this row
      var html = ubl2pint_format(row.data());
      row.child(html).show(); tr.addClass('shown');
    }
  });
  // -----------------------------------------------------------------
  // Add event listener for opening and closing detail records
  // -----------------------------------------------------------------
  // EN2CII
  $('#en2cii tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en2cii_table.row(tr), data = row.data();
    if (!data) { return; }
    var id = data.EN_ID;
    if (id.match(/^BG/)) {
      expandCollapse('#en2cii', En2CiiMap, tr);      
    }
  });
  // EN_IVC2UBL
  $('#en_ivc2ubl tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_ivc2ubl_table.row(tr), data = row.data();
    if (!data) { return; }
    var id = data.EN_ID;
    if (id.match(/^BG/)) {
      expandCollapse('#en_ivc2ubl', EnIvc2UblMap, tr);      
    }
  });
  // EN_CNT2UBL
  $('#en_cnt2ubl tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = en_cnt2ubl_table.row(tr), data = row.data();
    if (!data) { return; }
    var id = data.EN_ID;
    if (id.match(/^BG/)) {
      expandCollapse('#en_cnt2ubl', EnCnt2UblMap, tr);      
    }
  });
  // PINT2UBL
  $('#pint2ubl tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = pint2ubl_table.row(tr), data = row.data();
    if (!data) { return; }
    var id = data.EN_ID;
    if (id.match(/^(BG|ibg)/)) {
      expandCollapse('#pint2ubl', Pint2UblMap, tr);      
    }
  });
  // -----------------------------------------------------------------
  // CII2EN
  $('#cii2en tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = cii2en_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of Cii2EnNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#cii2en', Cii2EnMap, tr);      
    }
  });
  // UBL2EN_IVC
  $('#ubl2en_ivc tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = ubl2en_ivc_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of Ubl2EnIvcNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#ubl2en_ivc', Ubl2EnIvcMap, tr);      
    }
  });
  // UBL2EN_CNT
  $('#ubl2en_cnt tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = ubl2en_cnt_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of Ubl2EnCntNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#ubl2en_cnt', Ubl2EnCntMap, tr);      
    }
  });
  // UBL2PINT
  $('#ubl2pint tbody').on('click', 'td:not(.info-control)', function (event) {
    event.stopPropagation();
    var tr = $(this).closest('tr'),
        row = ubl2pint_table.row(tr), data = row.data();
    if (!data) { return; }
    var num = data.num,
        rgx = RegExp('^'+num+'_[^_]+$'),
        i = 0;
    for (num of Ubl2PintNums) {
      if (num.match(rgx)) { i++; }
    }
    if (i > 0) {
      expandCollapse('#ubl2pint', Ubl2PintMap, tr);      
    }
  });

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

  $('.tablinks.en.title').removeClass('active');
  $('.tablinks.en').css('display', 'none');
  $('.tablinks.pint.title').addClass('active');
  $('.tablinks.pint').css('display', 'block');
  setFrame('pint2ubl')
  // setFrame('ubl2pint')
  // changeLanguage('en');
  pint2ubl_colBT = pint2ubl_table.column(COL_pint2ubl['BT']);
  pint2ubl_colBT_ja = pint2ubl_table.column(COL_pint2ubl['BT_ja']);
  // pint2ubl_colDesc = pint2ubl_table.column(COL_pint2ubl['BT']);
  // pint2ubl_colDesc_ja = pint2ubl_table.column(COL_pint2ubl['BT_ja']);
  ubl2pint_colBT = ubl2pint_table.column(COL_ubl2pint['BT']);
  ubl2pint_colBT_ja = ubl2pint_table.column(COL_ubl2pint['BT_ja']);
  // ubl2pint_colDesc = ubl2pint_table.column(COL_ubl2pint['BT']);
  // ubl2pint_colDesc_ja = ubl2pint_table.column(COL_ubl2pint['BT_ja']);
}
// pint.js