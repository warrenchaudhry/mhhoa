// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require moment
//= require tempusdominus-bootstrap-4
//= require_tree .

$(function(){
  $('#datepicker').datetimepicker({ format: 'YYYY-MM-DD', ignoreReadonly: true, defaultDate: new Date() });

  $('.payment_chkbox').on('change', function(e){
    $this = $(this);
    chkBoxID = $this.attr('id');
    idx = chkBoxID.split('-')[1];
    idx = parseInt(idx);
    idPrefix = chkBoxID.split('-')[0];
    var tRow = $this.parent().parent();
    if ( !$this.is(':checked') ){
      for(i = (idx + 1);i <= 12;i++){
        //console.log(i);
        chk = $('#' + idPrefix + '-' + i);
        console.log(chk);
        if (chk.is(':checked') && !chk[0].hasAttribute('disabled')) {
          chk.prop('checked', false).val(false);
        }
        chk.prop('disabled', true);
      }
    }else{
      nextChkBox = $('#' + idPrefix + '-' + (idx + 1));
      console.log(nextChkBox)
      if (!nextChkBox.is(':checked')){
        nextChkBox.removeAttr('disabled');
      };
    }




  });
});

