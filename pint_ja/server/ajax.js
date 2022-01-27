/**
 * wuwei.ajax.js
 * General JavaScript utilities
 *
 * WuWei is a free to use open source knowledge modeling tool.
 * More information on WuWei can be found on WuWei homepage.
 * https://www.wuwei.space/blog/
 *
 * WuWei is licensed under the MIT License
 * Copyright (c) 2013-2020, Nobuyuki SAMBUICHI
 **/
ajaxRequest = function(url, data, methodType, ms) {
  let xhr, timerid;
  /**
   * use promise object in our ajaxRequest function
   * https://medium.com/front-end-hacking/ajax-async-callback-promise-e98f8074ebd7
   * alse see https://blog.garstasio.com/you-dont-need-jquery/ajax/#posting
   */
  function param(object) {
    var encodedString = '';
    for (var key in object) {
      if (object.hasOwnProperty(key)) {
        if (encodedString.length > 0) {
          encodedString += '&';
        }
        if ('object' === typeof object[key]) {
          encodedString += encodeURI(key + '=' + JSON.stringify(object[key]));
        }
        else {
          encodedString += encodeURI(key + '=' + object[key]);
        }
      }
    }
    return encodedString;
  }
  
  const ajaxCall = function (url, data, methodType) {
    const
      UNSENT = 0,
      OPENED = 1,
      HEADERS_RECEIVED= 2,
      LOADING	= 3,
      DONE = 4;

    return new Promise(function(resolve, reject) {
      xhr = new XMLHttpRequest();

      if ('POST' === methodType.toUpperCase()) {
        xhr.open(methodType, url, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        // Upload progress on request.upload
        xhr.upload.addEventListener('progress', function(e) {
          var complete = (e.loaded / e.total)*100;
          // Percentage of upload completed
          console.log(url, methodType, 'xhr.upload progress complete:', complete);
          progressbar.move(complete);
        });
      }
      else if ('GET' === methodType.toUpperCase()) {
        if (data) {
          let param = [];
          for (let d in data) {
            param.push(`${encodeURIComponent(d)}=${encodeURIComponent(data[d])}`);
          }
          url += `?${param.join('&')}`;
        }
        xhr.open(methodType, url, true);
      }

      xhr.onreadystatechange = function() {
        let responseText;
        if (xhr.readyState === UNSENT) {
          console.log(url, methodType, 'UNSENT');
        }
        else if (xhr.readyState === OPENED) {
          console.log(url, methodType, 'OPENED');
        }
        else if (xhr.readyState === HEADERS_RECEIVED) {
          console.log(url, methodType, 'HEADERS_RECEIVED');
        }
        else if (xhr.readyState === LOADING) {
          console.log(url, methodType, 'LOADING');
        }
        else if (xhr.readyState === DONE) {
          console.log(url, methodType, 'DONE status:', xhr.status);
          clearTimeout(timerid);
          if (xhr.status === 200) {
            responseText = xhr.responseText;
            resolve(responseText);
          }
          else if (xhr.status === 404) {
            responseText = xhr.responseText;
            resolve(responseText);
          }
          else {
            console.log('xhr failed');
            console.log(url, methodType, 'DONE status:', xhr.status);
            reject({
              status: this.status,
              statusText: xhr.statusText
            });
          }
        }
        else {
          console.log('xhr processing going on xhr.readyState=' + xhr.readyState);
        }
      };

      if ('POST' === methodType.toUpperCase()) {
        if ('object' === typeof data) {
          data = param(data);
        }
        xhr.send(data);
      }
      else if ('GET' === methodType.toUpperCase()) {
        xhr.send();
      }

      history.replaceState({}, null, INDEX_URL);
      //** see https://stackoverflow.com/questions/13650408/hide-variables-passed-in-url */
      // console.log('request sent succesfully to ', url);
    });
  };

  if (!ms) {
    ms = 180000;
  }
  // Create a promise that rejects in <ms> milliseconds
  const timeout = new Promise((resolve, reject) => {
    timerid = setTimeout(() => {
      clearTimeout(timerid);
      xhr.abort();
      reject({
        status: 'timeout',
        statusText: `Timed out in ${ms}ms.`
      });
    }, ms);
  });

  // Returns a race between our timeout and the passed in promise
  return Promise.race([
    ajaxCall(url, data, methodType),
    timeout
  ]);
};

function AjaxSubmit (form) {
  var INDEX_URL = 'https://www.wuwei.space/jp_pint/upload.html'

  return new Promise(function(resolve, reject) {

    if (!form.action) {
      reject(new Error('No action specified.'));
    }

    var xhr = new XMLHttpRequest();
    xhr.timeout = 180000; // time in milliseconds 180sec.
    xhr.onload = function () {
      // Request finished. Do processing here.
      console.log("AjaxSubmit - Success!");
      console.log( this.responseText );
      resolve(this.responseText);
    };
    xhr.ontimeout = function (e) {
      // XMLHttpRequest timed out. Do something here.
      reject(e);
    };
    // Upload progress on request.upload
    xhr.upload.addEventListener('progress', function(e) {
      var complete = (e.loaded / e.total)*100;
      // Percentage of upload completed
      console.log(complete);
      progressbar.move(complete);
    });

    if (form.method.toLowerCase() === "post") {
      xhr.open("post", form.action);
      xhr.send(new FormData(form));
      history.replaceState({}, null, INDEX_URL);
      //** see https://stackoverflow.com/questions/13650408/hide-variables-passed-in-url */
    }
    else {
      var field, fieldType, nItem, nFile, sSearch = "";
      for (nItem = 0; nItem < form.elements.length; nItem++) {
        field = form.elements[nItem];
        if (! field.hasAttribute("name")) {
          continue;
        }
        fieldType = field.nodeName.toUpperCase() === "INPUT" ? field.getAttribute("type").toUpperCase() : "TEXT";
        if (fieldType === "FILE") {
          for (nFile = 0; nFile < field.files.length; sSearch += "&" + xhr(field.name) + "=" + encodeURIComponent(field.files[nFile++].name));
        }
        else if ((fieldType !== "RADIO" && fieldType !== "CHECKBOX") || field.checked) {
          sSearch += "&" + encodeURIComponent(field.name) + "=" + encodeURIComponent(field.value);
        }
      }
      xhr.open("get", form.action.replace(/(?:\?.*)?$/, sSearch.replace(/^&/, "?")), true);
      xhr.send(null);
      history.replaceState({}, null, INDEX_URL);
      //** see https://stackoverflow.com/questions/13650408/hide-variables-passed-in-url */
    }
  });
}

// ===== 本システムのホームディレクトリの絶対URLを得る ===============
// [入力]
// ・なし
// [出力]
// ・本システムのホームディレクトリーの絶対URL文字列
//   - 文字列の最後には "/" が付いている。従ってこのURLを元に、別のファ
//     イルやディレクトリーの絶対URLを作る時、付け足す文字列の先頭に "/"
//     は不要である。
//   - 失敗時はnull
// [備考]
// ・JavaScriptにとって、自分のプログラムファイルが置かれている絶対URL
//   を自力で知るのは難しい。理由は、呼び出し側HTMLのカレントURL(絶対
//   URL)が与えられるからだ。
// ・そこで呼び出し側HTMLの中にある、呼び出し元の<script src="...">を探
//   し出し、そのURL情報を使ってカレントURL(絶対URL)に位置補正を行い、
//   自身の絶対URLを検出する。
function get_homedir() {
  // --- 自分自身に関する情報の設定(自分の位置を検出するために必要) --
  var sThis_filename = 'clock.js'; // このファイルの名前(*1)
  var sPath_to_the_home = '.';     // ↑のホームdirへの相対パス
    // (*1) 同名ファイルが他に存在するなどして、ファイル名だけでは一意
    //      に絞り込めない場合、「<script src="~">で必ず含めると保証さ
    //      れている」のであれば、親ディレクトリーなどを含めてもよい。
    //      例えば、1つのサイトの中の
    //        あるHTMLでは<script src="myjs/script.js">
    //        またあるHTMLでは<script src="../myjs/script.js">
    //      というように、全てのHTMLで "myjs/script.js" 部分を必ず指定
    //      しているなら、他の "otherjs/script.js" と間違わないように、
    //        sThis_filename = 'myjs/script.js' としてもよい。
    //      ただしこの時 sLocation_from_home は、"myjs" の場所から見た
    //      ホームディレクトリーへの相対パスを意味するので注意。

  // --- その他変数定義 ----------------------------------------------
  var i, s, le; // 汎用変数
  var sUrl = null; // 戻り文字列格納用

  // --- 自JavaScriptを読んでいるタグを探し、homedir(相対の場合あり)を生成
  le = document.getElementsByTagName( 'script' );
  for ( i = 0; i < le.length; i++ ) {
    s = le[ i ].getAttribute( 'src' );
    if ( s.length < sThis_filename.length) {continue; }
    if ( s.substr(s.length-sThis_filename.length) !== sThis_filename) {continue; }
    s = s.substr(0,s.length-sThis_filename.length);
    if (( s.length>0 ) && s.match(/[^\/]$/) ) {continue; }
    sUrl = s + sPath_to_the_home;
    sUrl = (sUrl.match(/\/$/)) ? sUrl : sUrl+'/';
    break;
  }
  if ( i >= le.length ) {
    return null; // タグが見つからなかったらnullを返して終了
  }

  // --- 絶対パス化(.や..は含む) -------------------------------------
  if ( sUrl.match( /^http/i )) {
    // httpから始まるURLになっていたらそのままでよい
  }
  else if ( sUrl.match( /^\// )) {
    // httpから始まらないが絶対パスになっている場合はhttp～ドメイン名までを先頭に付ける
    if (! location.href.match( /^(https?:\/\/[a-z0-9.-]+)/i ) ) {return null; }
    sUrl = RegExp.$1 + sUrl;
  }
  else {
    // 相対パスになっている場合は呼び出し元URLのディレクトリまでの部分を先頭に付ける
    sUrl = location.href.replace(/\/[^\/]*$/, '/') + sUrl;
  }

  // --- カレントディレクトリ表記(.)を除去 ---------------------------
  while ( sUrl.match( /\/\.\// )) {
    sUrl = sUrl.replace( /\/\.\//g, '/' );
  }

  // --- 親ディレクトリ表記(..)を除去 --------------------------------
  sUrl.match( /^(https?:\/\/[A-Za-z0-9.-]+)(\/.*)$/ );
  s = RegExp.$1;
  sUrl = RegExp.$2;
  while ( sUrl.match( /\/\.\.\// )) {
    while ( sUrl.match( /^\/\.\.\// )) {
      sUrl = sUrl.replace( /^\/\.\.\//, '/' );
    }
    sUrl = sUrl.replace( /^\/\.\.$/, '/' );
    while ( sUrl.match( /\/[^\/]+\/\.\.\// )) {
      sUrl = sUrl.replace( /\/[^\/]+\/\.\.\//, '/' );
    }
  }
  sUrl = s + sUrl;

  // --- 正常終了 ----------------------------------------------------
  return sUrl;
}
// wuwei.ajax.js

