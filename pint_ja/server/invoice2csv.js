/**
 * invoice2csv.js
 * invoice2csv module
 **/
invoice2csv = ( function () {
  var windowObjectReference;
  var features = 'menubar=no,location=no,resizable=yes,scrollbars=yes,status=no';
  
  function openWindow(url) {
    windowObjectReference = window.open(url, 'invoice2csv', 'width=1200,height=900,' + features);
  }

  function upload(form) {
    $('#csv2invoiceModal').on('shown.bs.modal', function (e) {
      progressbar.open();
      progressbar.move(0);
    });
    progressbar.open();
    progressbar.move(0);
    AjaxSubmit(form)
    .then(responseText => {
      $('#invoice2csvModal').modal('toggle');
      if ('{' !== responseText[0]) {
        snackbar.open({ type: 'error', message: responseText});
        return;
      } else if (responseText.indexOf('#! /bin/sh') >= 0) {
        responseText = 'ERROR Cannnot execute bin/sh';
        snackbar.open({ type: 'error', message: responseText });
      } else {
        var response;
        try {
          response = JSON.parse(responseText);
        } catch (e) {
          console.log(e);
          snackbar.open({ message: responseText, type: 'warning' });
          return;
        }
        console.log(response);
        let name = response.name;//.match(/^(.*)\.csv$/)[1];
        snackbar.open({ type: 'success', message: name + ' uploaded'});
        // csv
        let csv = location.href.match(/^(.*)\/upload\.html$/)[1]+'/server/'+response.csv;
        let csv_name = name+'.csv';
        $('#csv input').val(csv_name);
        $('#csv input').on('click', function(e) {
          openWindow(csv);
        });
        $('#csv a').attr('href',csv);
        $('#csv a').removeAttr('d-none')
        // html
        let html = location.href.match(/^(.*)\/upload\.html$/)[1]+'/server/'+response.html;
        let html_name = name+'.html';
        $('#html input').val(html_name);
        $('#html input').on('click', function(e) {
          openWindow(html);
        });
        $('#html a').attr('href',html);
        $('#html a').removeAttr('d-none')
        // table
        let table = location.href.match(/^(.*)\/upload\.html$/)[1]+'/server/'+response.table;
        let table_name = name+'_table.html';
        $('#table input').val(table_name);
        $('#table input').on('click', function(e) {
          openWindow(table);
        });
        $('#table a').attr('href',table);
        $('#table a').removeAttr('d-none')
      }
    })
    .catch(e => {
      console.log(e);
    });
  }

  return {
    upload: upload
  };
})();

// invoice2csv.js