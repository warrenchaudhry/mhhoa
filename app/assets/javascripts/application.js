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
    var ORelem = document.getElementById('base_receipt_no');
    $this = $(this);
    chkBoxID = $this.attr('id');
    idx = chkBoxID.split('-')[1];
    idx = parseInt(idx);
    idPrefix = chkBoxID.split('-')[0];
    var tRow = $this.parent().parent();
    assignOrNum(ORelem.value, tRow);
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
      // console.log(nextChkBox)
      if (!nextChkBox.is(':checked')){
        nextChkBox.removeAttr('disabled');
      };
    }
  });

  function assignOrNum(or_num, currentRow) {
    var ORelem = document.getElementById('base_receipt_no');
    checkedBoxes = currentRow.find('.payment_chkbox:checked');
    targetId = currentRow.data('item-id');
    orLen = or_num.length;
    ORinput = currentRow.find('#payments_' + targetId + '_receipt_no');
    console.log('Input val = ' + ORinput.val());
    nextSeq = or_num;
    if (checkedBoxes.length == 1 && ORinput.val().length == 0) {
      nextSeq = parseInt(or_num) + 1;
      ORinput.val(zeroPad(nextSeq, orLen));
    } else if (checkedBoxes.length == 0) {
      nextSeq = parseInt(or_num) - 1;

      ORinput.val(null);
    }
    newORNum = zeroPad(nextSeq, orLen);
    ORelem.value = newORNum;
  }

  function zeroPad(num, places) {
    return String(num).padStart(places, '0')
  }

});

