/**
Initialize table user interface

This software was designed by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
and it was written by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office).

==== MIT License ====

Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
var APP_BASE, LANG,
    IS_SEMANTICS,IS_SYNTAX,IS_RULES,IS_ITEM_SEMANTICS,IS_ITEM_SYNTAX,IS_ITEM_RULE;

function goBack() {
  window.history.back();
}

function getUrlParameter(sParam) {
  var pageURL = window.location.search.substring(1),
      variables = pageURL.split('&'),
      name, i, tab1, tab2, file;
  for (i = 0; i < variables.length; i++) {
    name = variables[i].split('=');
    if (name[0] === sParam) {
      return name[1] === undefined ? true : decodeURIComponent(name[1]);
    }
  }
};

function tableInit() {
  var rows, fold, expand,i, level, num,
      idxLevel = [];
  rows = [];
  rows = document.querySelectorAll('table tbody tr');
  PintMap = new Map();
  PintNums = [];
  for (i = 0; i < rows.length; i++) {
    row = rows[i];
    if (IS_SEMANTICS) {
      level = row.dataset.level;
      pint_id = row.dataset.pint_id;
      num = pint_id;
      if (level > 0) {
        num = idxLevel[level - 1] + '_' + pint_id;
      }
      while (idxLevel.length - 1 > level) {
        idxLevel.pop();
      }
      idxLevel[level] = num;
      row.dataset.num = num;
    }
    else if (IS_SYNTAX) {
      path = row.dataset.path;
      level = row.dataset.level;
      num = row.dataset.seq;
      if (level > 0) {
        num = idxLevel[level - 1] + '_' + num;
      }
      while (idxLevel.length - 1 > level) {
        idxLevel.pop();
      }
      idxLevel[level] = num;
      row.dataset.num = num;
    }
  }
  if (!IS_SEMANTICS && !IS_SYNTAX) {
    return false;
  }
  for (i = 0; i < rows.length; i++) {
    row = rows[i];
    if (0 == i) {
      fold = row.querySelector('td.expand-control .fold');
      if (fold) {
        fold.style.display='';
      }
      expand = row.querySelector('td.expand-control .expand');
      if (expand) {
        expand.style.display='none';
      }
    }
    if (row.dataset.num && row.dataset.num.split('_').length < 3) {
      row.style.display = '';
    }
    else {
      row.style.display = 'none';
    }
  }
}

function expandCollapse(tr) {
  var rows = document.querySelectorAll('table tbody tr'),
      row, num, i, rgx,
      expand = false;
  data = tr.dataset;
  if (!data) {
    return false;
  }
  rgx = RegExp('^' + data.num + '_[^_]+$')
  for (i = 0; i < rows.length; i++) {
    row = rows[i];
    num = row.dataset.num;
    if (num.match(rgx)) {
      if (row.style.display == 'none') {
        row.style.display = '';
        expand = true;
      }
    }
  }
  rgxL = RegExp('^' + data.num + '_[^_]+.*$')
  for (i = 0; i < rows.length; i++) {
    row = rows[i];
    num = row.dataset.num;
    if (num.match(rgxL)) {
      if (!expand) {
        row.style.display = 'none';
      }
    }
  }
  if (expand) {
    tr.querySelector('td .fold').style.display = '';
    tr.querySelector('td .expand').style.display = 'none';
  }
  else {
    tr.querySelector('td .fold').style.display = 'none';
    tr.querySelector('td .expand').style.display = '';
  }
}

function changeLanguage(lang) {
  location.assign('../'+lang+'/index.html')
}

// function openLink(id,from,to,lang) {
//   var m, url, base, rgx;
//   // rgx = RegExp('^(.*)\/'+from+'\/.*$')
//   // base = location.href.match(rgx)[1];
//   switch (to) {
//     case 'semantic':
//       url = base+'/semantic/invoice/'+id+'/'+lang+'/';
//       break;
//     case 'syntax':
//       url = base+'/syntax/ubl-invoice/'+id+'/'+lang+'/';
//       break;
//     case 'rules':
//       if (id.match(/^jp-.*$/)) {
//         url = base+'/rules/ubl-japan/'+id+'/'+lang+'/';
//       }
//       else if (id.match(/^ibr-.*$/)) {
//         url = base+'/rules/ubl-pint/'+id+'/'+lang+'/';
//       }
//       break;
//     default:
//       break;
//   }
//   location.assign(url);
// }

function clearFounds() {
  var rows, tr, rgx;
  rows = document.querySelectorAll('table tbody tr');
  for (tr of rows) {
    for (var cell of tr.cells) {
      text = cell.innerHTML;
      // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace
      rgx = RegExp('<span class="found">(.*)</span>');
      text = text.replace(rgx, function (match, p1, offset, string) {
        return p1;
      });
      cell.innerHTML = text;
    }
  }
}

function showSemanticAncestor(found_num, rows) {
  var founds, id, needle, i, row, num, rgx, rgxG, rgx2, text;
  founds = found_num.split('_');
  id = founds[founds.length-1];
  needle = founds[0];
  for (i = 1; i < founds.length - 1; i++) { // founds[0] in Invoice
    needle += '_'+founds[i];
    rgxG = RegExp('^'+founds[i]);
    rgx = RegExp('^'+needle+'(_ib[gt]-[0-9]*|_'+id+')?$');
    // console.log(rgx);
    for (row of rows) {
      num = row.dataset.num;
      if (num.match(rgx)) {
        row.style.display = '';
        rgx2 = RegExp('^.*_'+id+'$');
        if (num.match(rgx2)) {
          text = row.cells[1].innerHTML;
          text = '<span class="found">'+text+'</span>';
          row.cells[1].innerHTML = text;
        }
        if (row.dataset.pint_id.match(rgxG)) {
          row.querySelector('td .fold').style.display='';
          row.querySelector('td .expand').style.display='none';
        }
      }
    }
  }
}

function showSyntaxAncestor(found_num, rows) {
  var founds, needle, i, row, num, rgxG;
  founds = found_num.split('_');
  needle = founds[0];
  for (i = 1; i < founds.length - 1; i++) { // founds[0] in Invoice
    needle += '_'+founds[i];
    row = document.querySelector('[data-seq~="'+founds[i]+'"]');
    if (row.classList.contains('group')) {
      row.querySelector('td .fold').style.display='';
      row.querySelector('td .expand').style.display='none';
    }
    for (row of rows) {
      rgx = RegExp('^'+needle+'(_[0-9]*|_'+num+')?$');
      num = row.dataset.num;
      if (num.match(rgx)) {
        row.style.display = '';
      }
    }
  }
}

function lookupTerm(key) {
  var num, i, rows, row, tr, text, text2, text4,
      _text, _key, loc,
      rgx, rgx2, rgxG, found, founds, rect, found_num, needle, founds,
      TIMEOUT = 12000;
  clearFounds();
  rows = document.querySelectorAll('table tbody tr');
  if (IS_SEMANTICS) {
    if (key.match(/^B[GT]-.*$/) ||
        key.match(/^b[tg]-.*$/)) {
      num = key.substr(3,key.length-3);
      if (num.match(/^[0-9]*$/)) {
        if (2 == num.length) {
          num = '0' + num;
        }
        else if (1 == num.length) {
          num = '00' + num;
        }
      }
      key = 'i'+key.substr(0,3).toLowerCase()+num;
    }
    else if (key.match(/^IB[GT]-.*$/)) {
      num = key.substr(4,key.length-4);
      if (num.match(/^[0-9]*$/)) {
        if (2 == num.length) {
          num = '0' + num;
        }
        else if (1 == num.length) {
          num = '00' + num;
        }
      }
      key = key.substr(0,4).toLowerCase()+num;
    }
    if (key.match(/^ib[gt]-.*$/)) {
      for (i = 0; i < rows.length; i++) {
        row = rows[i];
        if (key == row.dataset.pint_id) {
          found = row;
          found_num = row.dataset.num;
          break;
        }
      }
    }
    if (!found) {
      founds = [];
      for (row of rows) {
        text = row.cells[2].innerHTML + row.cells[4].innerHTML;
        _text = text; _key = key;
        if ('en' == $('select#language').val()) {
          _text = text.toLowerCase();
          _key = key.toLowerCase();
        }
        rgx = RegExp(_key);
        if (_text.match(rgx)) {
          founds.push(row);
        }
      }
    }
    if (!found && !founds && 0 == founds.length) {
      alert(key+' not found.');
      return false;
    }
    if (found) {
      showSemanticAncestor(found_num, rows);
    }
    else if (founds.length > 0) {
      for (tr of founds) {
        text2 = tr.cells[2].innerHTML;
        _key = key.toLowerCase();
        loc = text2.toLowerCase().indexOf(_key);
        if (loc >= 0) {
          text2 = text2.substr(0,loc)+'<span class="found">'+text2.substr(loc,_key.length)+'</span>'+text2.substr(loc+_key.length);
          tr.cells[2].innerHTML = text2;
        }
        text4 = tr.cells[4].innerHTML;
        loc = text4.toLowerCase().indexOf(_key);
        if (loc >= 0) {
          text4 = text4.substr(0,loc)+'<span class="found">'+text4.substr(loc,_key.length)+'</span>'+text4.substr(loc+_key.length);        
          tr.cells[4].innerHTML = text4;
        }
        found_num = tr.dataset.num;

        showSemanticAncestor(found_num, rows);

        if (tr.querySelector('td .fold') &&
            'none' == tr.querySelector('td .fold').style.display) {
          expandCollapse(tr);
        }

      }
      setTimeout(function() {
        clearFounds();
      }, TIMEOUT);
      found = founds[0];      
    }
  }
  else if (IS_SYNTAX) {
    founds = [];
    rgx = RegExp(key.toLowerCase());
    rgx2 = RegExp(key);
    for (i = 0; i < rows.length; i++) {
      row = rows[i];
      dataset = row.dataset;
      pint_id = dataset.pint_id;
      en_id = dataset.en_id;
      text = row.cells[4].innerHTML;
      location = row.dataset.location;
      if (pint_id.match(rgx) || pint_id.match(rgx2) ||
          en_id.match(rgx) || en_id.match(rgx2) ||
          location.toLowerCase().match(rgx) ||
          text.match(rgx2)) {
        founds.push(row);
      }
    }
    if (0 == founds.length) {
      alert(key+' not found.');
      return false;
    }
    for (tr of founds) {
      _key = key.toLowerCase()
      rgx = RegExp(_key);
      if (tr.dataset.location.toLowerCase().match(rgx)) {
        text = tr.cells[1].innerHTML;
        text2 = text.toLowerCase();
        loc = text2.indexOf(_key);
        text2 = text2.substr(loc)+'<span class="found">'+text2.substr(loc,_key.length)+'</span>'+text2.substr(loc+_key.length);
        // text = '<span class="found">'+text+'</span>';
        tr.cells[1].innerHTML = text2;        
      }
      text2 = tr.cells[4].innerHTML;
      loc = text2.toLowerCase().indexOf(_key);
      if (loc >= 0) {
        text2 = text2.substr(loc)+'<span class="found">'+text2.substr(loc,_key.length)+'</span>'+text2.substr(loc+k_ey.length);
        tr.cells[4].innerHTML = text2;
      }
      found_num = tr.dataset.num;

      showSyntaxAncestor(found_num, rows);
    }
    setTimeout(function() {
      clearFounds();
    }, TIMEOUT);
    found = founds[0];
  }
  else if (IS_RULES) {
    for (row of rows) {
      if (key == row.dataset.id) {
        found = row;
        break;
      }
    }
    if (!found) {
      founds = [];
      for (row of rows) {
        text = row.cells[0].innerHTML;
        _text = text; _key = key;
        if ('en' == $('select#language').val()) {
          _text = text.toLowerCase();
          _key = key.toLowerCase();
        }
        rgx = RegExp(_key);
        if (_text.match(rgx)) {
          founds.push(row);
        }
      }
    }
    if (!found && !founds && 0 == founds.length) {
      alert(key+' not found.');
      return false;
    }
    if (found) {
      text = found.cells[0].innerHTML;
      text = text.replace('">'+key+'</a>','"><span class="found">'+key+'</span></a>');
      found.cells[0].innerHTML = text;
      setTimeout(function() {
        clearFounds();
      }, TIMEOUT);
    }
    else if (founds.length > 0) {
      for (tr of founds) {
        text = tr.cells[0].innerHTML;
        text = text.replaceAll(key,'<span class="found">'+key+'</span>');
        tr.cells[0].innerHTML = text;
        id = tr.dataset.id;
        text = text.replaceAll('">'+id+'<','"><span class="found">'+id+'</span><');
        tr.cells[0].innerHTML = text;

      }
      setTimeout(function() {
        clearFounds();
      }, TIMEOUT);
      found = founds[0];
    }
  }
  if (found) {
    rect = found.getBoundingClientRect();
    scrollTo(0, rect.top);  
  }
  else {
    alert(key+' not found.');
  }
  return false;
}

function initModule(id) {
  if (/Trident\/|MSIE /.test(window.navigator.userAgent)) {
    $('#ie-warning').css('display','block');
    $('td i.fold, td i.expand').hide();
    setTimeout(function() {
      $('#ie-warning').css('display','none');
    },60000)
    return;
  }
  $('#ie-warning').css('display','none');

  var m;
  m=location.pathname.match(/^(.*billing-japan\/).*(en|ja)(\/.*)?$/);
  APP_BASE = m[1];
  LANG = m[2];
  IS_SEMANTICS = location.pathname.match(/^.*\/semantic\/[\-a-zA-Z]*\/tree\/(en|ja)/);
  IS_SYNTAX = location.pathname.match(/^.*\/syntax\/ubl-[\-a-zA-Z]*\/tree\/(en|ja)/);
  IS_RULES = location.pathname.match(/^.*\/rules\/(ubl-pint|ubl-japan|en-peppol|en-cen)\/(en|ja)/);
  IS_ITEM_SEMANTICS = location.pathname.match(/^.*\/semantic\/[\-a-zA-Z]*\/i[bg]t-.+\/(en|ja)/);
  IS_ITEM_SYNTAX = location.pathname.match(/^.*\/syntax\/ubl-[\-a-zA-Z]*\/c[ab]c:.+\/(en|ja)/);
  IS_ITEM_RULE = location.pathname.match(/^.*\/rules\/(ubl-pint|ubl-japan)\/.+\/(en|ja)/);

  $('#language').on('change', function(event) {
    event.stopPropagation();
    LANG = event.target.value;
    changeLanguage(LANG);
    return false;
  });

  $('table tbody').on('click', 'td.expand-control', function (event) {
    event.stopPropagation();
    var tr, data, rect;
    tr = $(this).closest('tr')[0];
    expandCollapse(tr);
    return false;
  });

  $('#nav-menu button.search').on('click', function(event) {
    var key = $('#nav-menu input.search').val();
    lookupTerm(key);
    return false;
  });

  $('button.back').on('click', function(event) {
    var m, _id, path, _path, url;
    if (IS_ITEM_SEMANTICS) {
      m = location.pathname.match(/(.+\/semantic\/invice\/)([^\/]+)\/(en|ja)\/?$/)
      url = m[1]+'tree/'+m[3]+'/?id='+m[2];
    }
    else if (IS_ITEM_SYNTAX) {
      m = location.pathname.match(/(.+\/syntax\/ubl-invoice\/)(.+)\/(en|ja)\/?$/)
      url = m[1]+'tree/'+m[3]+'/?id='+m[2].replaceAll(':','-');
    }
    else if (IS_ITEM_RULE) {
      m = location.pathname.match(/(.+\/)(ubl-pint\/|ubl-japan\/)([^\/]+)\/(en|ja)\/?$/)
      if (m) {
        url = m[1]+m[2]+m[4]+'/?id='+m[3];
      }
    }
    if (url) {
      location.assign(url);
    }
    return false;
  });

  // https://www.w3schools.com/howto/howto_js_scroll_to_top.asp
  //Get the button:
  gotoTopButton = document.getElementById("gotoTopButton");
  // When the user scrolls down 20px from the top of the document, show the button
  window.onscroll = function() {scrollFunction()};
  function scrollFunction() {
    if ($('#gotoTopButton')) {
      if (document.body.scrollTop > 120 || document.documentElement.scrollTop > 120) {
        gotoTopButton.style.display = 'block';
      } else {
        gotoTopButton.style.display = 'none';
      }
    }
  }

  $('#gotoTopButton').on('click', function() {
    gotoTop();
  })
  // When the user clicks on the button, scroll to the top of the document
  function gotoTop() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  }

  if (IS_SEMANTICS || IS_SYNTAX || IS_RULES) {
    Promise.resolve(true)
    .then(function() {
      return tableInit();
    })
    .then(function() {
      if (id) {
        lookupTerm(id);
      }
    })
    .catch(function(e) {
      console.log(e);
    });
  }

  $("body").tooltip({ selector: '[data-toggle=tooltip]' });

}
