/**
 * googleTranslate.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
function googleTranslate(text) {
  if (!text) { return ''; }
  // 'https://translation.googleapis.com/language/translate/v2?key=***&q=An Invoice that contains a Document level allowance&target=ja'
  var url = 'https://translation.googleapis.com/language/translate/v2',
      data;
  data = {
    key: '***',
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

// googleTranslate.js
