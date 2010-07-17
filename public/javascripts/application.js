$(function() {
  //New/Edit Bill Page
  if($('#new_bill_container').length || $('#edit_bill_container').length) {
    $('.hint').prev().each(function() {
      $(this).focus(function() {
        $(this).next('span').fadeIn();
      });
      $(this).blur(function() {
        $(this).next().fadeOut();
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


  //Edit Bill Page
  if($('#edit_bill_container').length) {
      $('#bill_freq').hide();

      var day = $('#bill_weekday').val();
      $('#bill_weekday').val(convert_day_to_weekday(day));

  }

  //Show Bill Page
  if($('#show_bills_container').length) {
    $('.bill_options_container').each(function() {
      //$(this).hide();
    });
    $('.ind_bill').each(function() {
      $(this).hover(function() {
        $(this).children('.bill_options').fadeIn();
      },
      function() {
        $(this).children('.bill_options').fadeOut();
      });
    });
  }
});

function check_frequency_val(el) {
  var action = $('#bill_action').html();
  var bill_date_arr = ['#'+action+'_bill_weekday','#'+action+'_bill_day','#'+action+'_bill_month','#'+action+'_bill_alternator'];
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
    if(!$('#'+action+'_new_bill_weekday').hasClass('visible-date')) {
      $('#'+action+'_bill_weekday').addClass('visible-date');
      $('#'+action+'_bill_weekday').slideToggle();
    }
    if(val.match(/[a-zA-Z0-9]*(bi)/i) || val.match(/every 2/i)) {
      if(!$('#'+action+'_bill_alternator').hasClass('visible-date')) {
        if(action != 'edit') {
          $('#alternator_hint').before('<select id="'+action+'_bill_alternator" name="'+action+'_bill\[alternator\]"><option id="alternate_this_week" value="'+this_week+'">Will Happen This Week</option><option id="alternate_next_week" value="'+next_week+'">Will Happen Next Week</option></select>');
        }
        $('#'+action+'_bill_alternator').focus(function() {
          $(this).next('.hint').fadeIn();
        });
        $('#'+action+'_bill_alternator').blur(function() {
          $(this).next('.hint').fadeOut();
        });
        $('#'+action+'_bill_alternator').addClass('visible-date');
        $('#'+action+'_bill_alternator').slideToggle();
      }
    } else if($('#'+action+'_bill_alternator').hasClass('visible-date')) {
      $('#'+action+'_bill_alternator').removeClass('visible-date');
      $('#'+action+'_bill_alternator').remove();
      $('#'+action+'_bill_alternator').slideUp();
    }
  } else if(val.match(/[a-zA-Z0-9]*(month)/i)) {
    if(!$('#'+action+'_bill_day').hasClass('visible-date')) {
      $('#'+action+'_bill_day').addClass('visible-date');
      $('#'+action+'_bill_day').slideToggle();
    }
    if(val.match(/[a-zA-Z0-9]*(bi)/i) || val.match(/every 2/i)) {
      if(!$('#'+action+'_bill_alternator').hasClass('visible-date')) {
        if(action != 'edit') {
          $('#alternator_hint').before('<select id="'+action+'_bill_alternator" name="'+action+'_bill\[alternator\]"><option id="alternate_this_week" value="'+this_week+'">Will Happen This Week</option><option id="alternate_next_week" value="'+next_week+'">Will Happen Next Week</option></select>');
        }
        $('#'+action+'_bill_alternator').focus(function() {
          $(this).next('.hint').fadeIn();
        });
        $('#'+action+'_bill_alternator').blur(function() {
          $(this).next('.hint').fadeOut();
        });
        $('#'+action+'_bill_alternator').addClass('visible-date');
        $('#'+action+'_bill_alternator').slideToggle();
      }
    } else if($('#'+action+'_bill_alternator').hasClass('visible-date')) {
      $('#'+action+'_bill_alternator').removeClass('visible-date');
      $('#'+action+'_bill_alternator').remove();
      $('#'+action+'_bill_alternator').slideUp();
    }
  } else if(val.match(/[a-zA-Z0-9]*(year)/i)) {
    if(!$('#'+action+'_bill_day').hasClass('visible-date')) {
      $('#'+action+'_bill_day').addClass('visible-date');
      $('#'+action+'_bill_day').slideToggle();
    }
    if(!$('#'+action+'_bill_month').hasClass('visible-date')) {
      $('#'+action+'_bill_month').addClass('visible-date');
      $('#'+action+'_bill_month').slideToggle();
    }
  } else {
    $('#'+action+'_bill_alternator').remove();
    for(var i in bill_date_arr) {
      current = bill_date_arr[i];
      if($(current).hasClass('visible-date')) {
        $(current).removeClass('visible-date');
        $(current).slideUp();
      }
    }
  }
}

function convert_day_to_weekday(day) {
  switch(day) {
    case '1':
      return "Monday";
      break;
    case '2':
      return "Tuesday";
      break;
    case '3':
      return "Wednesday";
      break;
    case '4':
      return "Thursday";
      break;
    case '5':
      return "Friday";
      break;
    case '6':
      return "Saturday";
      break;
    case '7':
      return "Sunday";
      break;
  }
}

