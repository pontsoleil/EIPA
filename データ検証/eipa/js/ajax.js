/**
 * ajax.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/

function ajaxRequest(url, data, methodType, ms) {
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
        // xhr.upload.addEventListener('progress', function(e) {
        //   var complete = (e.loaded / e.total)*100;
        //   // Percentage of upload completed
        //   console.log(url, methodType, 'xhr.upload progress complete:', complete);
        //   progressbar.move(complete);
        // });
      }
      else if ('GET' === methodType.toUpperCase()) {
        if (data) {
          let param = [];
          for (let d in data) {
            param.push(encodeURIComponent(d)+'='+encodeURIComponent(data[d]));
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

      // history.replaceState({}, null, constants.BASE.INDEX_URL);
      //** see https://stackoverflow.com/questions/13650408/hide-variables-passed-in-url */
      console.log('request sent succesfully to ', url);
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

function AjaxSubmit(form) {
  return new Promise(function(resolve, reject) {

    if (!form.action) {
      reject(new Error('No action specified.'));
    }

    var xhr = new XMLHttpRequest();
    xhr.timeout = 180000; // time in milliseconds 180sec.
    xhr.onload = function () {
      // Request finished. Do processing here.
      // console.log("AjaxSubmit - Success!");
      // console.log( this.responseText );
      resolve(this.responseText);
    };
    xhr.ontimeout = function (e) {
      // XMLHttpRequest timed out. Do something here.
      reject(e);
    };
    // Upload progress on request.upload
    // xhr.upload.addEventListener('progress', function(e) {
    //   var complete = (e.loaded / e.total)*100;
    //   // Percentage of upload completed
    //   // console.log(complete);
    //   progressbar.move(complete);
    // });

    if (form.method.toLowerCase() === "post") {
      xhr.open("post", form.action);
      xhr.send(new FormData(form));
      // history.replaceState({}, null, "/wu_wei/index.html");
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
      // history.replaceState({}, null, constants.BASE.INDEX_URL);
      //** see https://stackoverflow.com/questions/13650408/hide-variables-passed-in-url */
    }
  });
}

function googleTranslate(text) {
  if (!text) { return ''; }
  // 'https://translation.googleapis.com/language/translate/v2?key=AIzaSyC-Vci4nO4HRtcnwrP8OyckvUHZPbpFOP4&q=An Invoice that contains a Document level allowance&target=ja'
  var url = 'https://translation.googleapis.com/language/translate/v2',
      data;
  data = {
    key: 'AIzaSyC-Vci4nO4HRtcnwrP8OyckvUHZPbpFOP4',
    q: text,
    target: 'ja'
  }
  return ajaxRequest(url, data, 'POST', 1000)
  .then(function(res) {
    var json, translations;
// { "data": {
//     "translations": Array[1][
//       { "translatedText": "ドキュメントレベルの許容値VATカテゴリコード",
//         "detectedSourceLanguage": "en"
//       }
//     ]
//   }
// } 
    try {
      json = JSON.parse(res);
      translations = json.data.translations;//[0].translatedText;
      return translations;
    }
    catch(e) {
      console.log(e);
      return 'ERROR:' + JSON.stringify(e);
    }
  })
  .catch(function(err) {
    console.log(err);
    return 'ERROR:' + JSON.stringify(err);
  });
}

// ajax.js
