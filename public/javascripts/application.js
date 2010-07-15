$(function() {
  if($('#new_bill_container').length) {
    $('.hint').prev().each(function() {
      $(this).focus(function() {
        $(this).next('span').css('display','inline');
      });
      $(this).blur(function() {
        $(this).next().css('display','none');
      });
    });

    $('.bill-date').each(function(){
      $(this).hide();
    });
    if($('#bill_frequency').val() != '') {
      check_frequency_val('#bill_frequency');
    }
    $('#bill_frequency').keyup(function() { check_frequency_val('#bill_frequency'); });
  }
});

function check_frequency_val(el) {
  var bill_date_arr = ['#new_bill_weekday','#new_bill_day','#new_bill_month','#new_bill_alternator'];
  var current = '';
  var this_week = $('#alternate_this_week').html();
  var next_week = $('#alternate_next_week').html();

  var d = new Date();
  var month = d.getMonth();
  month++;
  if(month%2==0) {
    var this_month = "even"
    var next_month = "odd"
  } else {
    var this_month = "odd"
    var next_month = "even"
  }

  var val = $(el).val();
  if(val.match(/[a-zA-Z0-9]*(week)/i)) {
    if(!$("#new_bill_weekday").hasClass("visible-date")) {
      $('#new_bill_weekday').addClass('visible-date');
      $('#new_bill_weekday').slideToggle();
    }
    if(val.match(/[a-zA-Z0-9]*(bi)/i) || val.match(/every 2/i)) {
      if(!$("#new_bill_alternator").hasClass("visible-date")) {
        $('#alternator_hint').before('<select id="bill_alternator" name="bill\[alternator\]"><option id="alternate_this_week" value="'+this_week+'">Will Happen This Week</option><option id="alternate_next_week" value="'+next_week+'">Will Happen Next Week</option></select>');
        $('#new_bill_alternator').addClass('visible-date');
        $('#new_bill_alternator').slideToggle();
      }
    } else if($("#new_bill_alternator").hasClass("visible-date")) {
      $("#new_bill_alternator").removeClass("visible-date");
      $('#bill_alternator').remove();
      $("#new_bill_alternator").slideUp();
    }
  } else if(val.match(/[a-zA-Z0-9]*(month)/i)) {
    if(!$("#new_bill_day").hasClass("visible-date")) {
      $('#new_bill_day').addClass('visible-date');
      $('#new_bill_day').slideToggle();
    }
    if(val.match(/[a-zA-Z0-9]*(bi)/i) || val.match(/every 2/i)) {
      if(!$("#new_bill_alternator").hasClass("visible-date")) {
        $('#alternator_hint').before('<select id="bill_alternator" name="bill\[alternator\]"><option id="alternate_this_week" value="'+this_week+'">Will Happen This Week</option><option id="alternate_next_week" value="'+next_week+'">Will Happen Next Week</option></select>');
        $('#new_bill_alternator').slideToggle();
      }
    } else if($("#new_bill_alternator").hasClass("visible-date")) {
      $("#new_bill_alternator").removeClass("visible-date");
      $('#bill_alternator').remove();
      $("#new_bill_alternator").slideUp();
    }
  } else if(val.match(/[a-zA-Z0-9]*(year)/i)) {
    if(!$("#new_bill_day").hasClass("visible-date")) {
      $('#new_bill_day').addClass('visible-date');
      $('#new_bill_day').slideToggle();
    }
    if(!$("#new_bill_month").hasClass("visible-date")) {
      $('#new_bill_month').addClass('visible-date');
      $('#new_bill_month').slideToggle();
    }
  } else {
    $('#bill_alternator').remove();
    for(var i in bill_date_arr) {
      current = bill_date_arr[i];
      if($(current).hasClass('visible-date')) {
        $(current).removeClass('visible-date');
        $(current).slideUp();
      }
    }
  }
}

