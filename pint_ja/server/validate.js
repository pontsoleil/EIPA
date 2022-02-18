/**
 * validate.js
 * validate module
 **/
validate = ( function () {

  function validate(form) {
    var html, htmls;
    var basic, pint, jp;
    basic = $('input:checkbox[name="basicChecked"]:checked').val();
    if (basic) {
      basic=$('input:checkbox[name="basicChecked"]').closest('div').data('basename');
      $('<input />')
      .attr('type', 'hidden')
      .attr('name', 'basic')
      .attr('value', basic)
      .appendTo('#validateForm');      
    }
    pint = $('input:checkbox[name="pintChecked"]:checked').val();
    if (pint) {
      pint=$('input:checkbox[name="pintChecked"]').closest('div').data('basename');
      $('<input />')
      .attr('type', 'hidden')
      .attr('name', 'pint')
      .attr('value', basic)
      .appendTo('#validateForm');      
    }
    jp = $('input:radio[name="jpChecked"]:checked').val();
    $('<input />')
    .attr('type', 'hidden')
    .attr('name', 'jp')
    .attr('value', jp)
    .appendTo('#validateForm'); 

    $('#validateModal')
    .on('shown.bs.modal', function (e) {
      progressbar.move(0);
      $('#spin').addClass('d-none')
      $('#log').html('')
    });

    progressbar.open();
    $('#spin').removeClass('d-none');

    AjaxSubmit(form)
    .then(response => {
      $('#spin').addClass('d-none')
      progressbar.move(0);
      html = response;
      html = html.replaceAll(/\/ebs\/www\/sambuichi\.jp\/public_html\/jp_pint\/server\//ig,'');
      html = html.replaceAll(/validate\/xslt\//ig,'');
      html = html.replaceAll(/data\/[0-9]{4}\/[0-9]{2}\/[^\/\]]*\//ig,'');
      html = html.replaceAll(/\*:Invoice\[namespace-uri\(\)='urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'\]/ig,'ubl:Invoice');
      html = html.replaceAll(/\*:([a-zA-Z]*)\[namespace-uri\(\)='urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'\]/ig,'cac:$1');
      html = html.replaceAll(/\*:([a-zA-Z]*)\[namespace-uri\(\)='urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'\]/ig,'cbc:$1');
      console.log(html);
      html = html.replaceAll(/\[INFO\]/ig,'<br>[INFO]');
      html = html.replaceAll(/\[WARNING\]/ig,'<br>[WARNING]');
      html = html.replaceAll(/\[ERROR\]/ig,'<br>[ERROR]');
      htmls = html.split('<br>');
      htmls = htmls.filter(function(d) {
        return d.match(/\[INFO\] --- ph-schematron-maven-plugin:5.2.0:validate/) ||
        d.match(/\[INFO\] Validating XML file/) || 
        d.match(/\[INFO\] Total time:/) ||
        d.match(/\[INFO\] Finished at:/) ||
        d.match(/\[INFO\] BUILD SUCCESS/) ||
        (
          ! d.match(/\[INFO\] /) && 
          ! d.match(/\[ERROR\] Failed to execute /) &&
          ! d.match(/\[ERROR\] To see /) &&
          ! d.match(/\[ERROR\] Re-run /) &&
          ! d.match(/\[ERROR\] For more /) &&
          ! d.match(/\[ERROR\] \[Help 1\]/) &&
          '[ERROR] \n' != d )
        }
      );
      htmls = htmls.map(function(d) {
        if (d.match(/\[INFO\] --- ph-schematron-maven-plugin:5.2.0:validate/)) {
          d = d.replace('[INFO] --- ph-schematron-maven-plugin:5.2.0:validate','<br>-- ');
          d = d.replace('@ pint-validation-rules ','');
        }
        else if (d.match(/\[INFO\] BUILD SUCCESS/)) {
          d = d.replace('BUILD','');
        }
        return d;
      });
      html = htmls.join('<br>');
      // console.log(html);
      $('#log').html(html)
    })
    .catch(e => {
      console.log(e);
    });
  }

  function initModule() {  }

  return {
    initModule: initModule,
    validate: validate
  };
})();

