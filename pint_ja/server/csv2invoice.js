/**
 * csv2invoice.js
 * csv2invoice module
 **/
csv2invoice = ( function () {
  var windowObjectReference;
  var features = 'menubar=no,location=no,resizable=yes,scrollbars=yes,status=no';
  
  function openWindow(url) {
    windowObjectReference = window.open(url, 'csv2invoice', 'width=1200,height=900,' + features);
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
      $('#csv2invoiceModal').modal('toggle');
      if ('{' !== responseText[0]) {
        snackbar.open({ type: 'error', message: responseText});
        return;
      } else if (responseText.indexOf('#! /bin/sh') >= 0) {
        responseText = 'ERROR Cannnot execute bin/sh';
        snackbar.open({ type: 'error', message: responseText });
      } else{
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
        // html
        let html = location.href.match(/^(.*)\/upload\.html$/)[1]+'/server/'+response.html;
        let html_name = name+'.html';
        $('#html input').val(html_name);
        $('#html input').on('click', function(e) {
          openWindow(html);
        });
        $('#html a').attr('href',html);
        $('#html a').removeAttr('d-none')
        // xml
        let xml = location.href.match(/^(.*)\/upload\.html$/)[1]+'/server/'+response.xml;
        let xml_name = name+'.xml';
        $('#xml input').val(xml_name);
        $('#xml input').on('click', function(e) {
          openWindow(xml);
        });
        $('#xml a').attr('href',xml);
        $('#xml a').removeAttr('d-none')
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

// csv2invoice.js