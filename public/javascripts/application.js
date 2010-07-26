$(function() {
  var type = '';
  var item = '';

  if($('#new_bill_container').length || $('#edit_bill_container').length) {
    item = 'bill_';
  } else if($('#new_income_container').length || $('#edit_income_container').length) {
    item = 'income_';
  } else if($('#edit_recurring_bill_container').length) {
    type = 'recurring_';
    item = 'bill_';
  } else if($('#edit_recurring_income_container').length) {
    type = 'recurring_';
    item = 'income_';
  }

  //New/Edit Page
  if($('.form_field').length) {
    $('.form_field').each(function() {
      $(this).focus(function() {
        $(this).next().next('.hint').fadeIn();
      });
      $(this).blur(function() {
        $(this).next().next('.hint').fadeOut();
      });
    });

    $('.form_field').each(function() {
      check_field(type,item,this);
      $(this).blur(function() {
        check_field(type,item,this);
      });
    });
    var frequency = '#'+type+item+'frequency';

    check_frequency_empty(type,item,frequency);

    $(frequency).bind('keyup', function() {
      check_frequency_val(type,item,frequency);
    });
  }

  //Edit Page
  if($('#edit_bill_container').length) {
      $('#bill_freq').hide();
  }

  //Show Bill Page
  if($('.item_container').length) {
    $('.ind_item').hover(function() {
      $(this).children('.item_options').fadeIn();
    },
    function() {
      $(this).children('.item_options').fadeOut();
      $('.confirm').each(function() {
        $(this).hide();
      });
    });
  }

  $('body').click(function() {
    $('.confirm').hide();
  });

  $('.item_options').click(function(event){
    event.stopPropagation();
  });

});

function check_field(type,item,el) {
  var el = $(el);
  var el_id = el.attr('id');
  var len = el.val().length;
  var image = el.next('.icon');
  var item = item;

  if(len < 1) {
    change_error_icon(image,'error');
  } else {
    change_error_icon(image,'okay');
  }

  if(el_id == type+item+'name') {
    if(len >= 15 || len < 1) {
      change_error_icon(image,'error');
    } else {
      change_error_icon(image,'okay');
    }
  } else if(el_id == type+item+'frequency') {
    if(el.val().match(/week/i) || el.val().match(/month/i) || el.val().match(/year/i) || el.val().match(/once/i) || el.val().match(/one time/i) || el.val().match(/1/i) || el.val().match(/one/i)) {
      change_error_icon(image,'okay');
    } else {
      change_error_icon(image,'error');
    }
  } else if(el_id == type+item+'weekday') {
    if(check_weekday(el.val())) {
      change_error_icon(image,'okay');
    } else {
      change_error_icon(image,'error');
    }
  } else if(el_id == type+item+'month') {
    if(check_month(el.val())) {
      change_error_icon(image,'okay');
    } else {
      change_error_icon(image,'error');
    }
  } else if(el_id == type+item+'day') {

  } else if(el_id == type+item+'amount') {
    if(el.val().match(/[\d]+[\.][\d]+/i) || el.val().match(/[\d]+/i)) {
      change_error_icon(image,'okay');
    } else {
      change_error_icon(image,'error');
    }
  }
}

function check_weekday(weekday) {
  switch(true) {
    case /mon/i.test(weekday): return 'Monday';
    break;
    case /tue/i.test(weekday): return 'Tuesday';
    break;
    case /wed/i.test(weekday): return 'Wednesday';
    break;
    case /thur/i.test(weekday): return 'Thursday';
    break;
    case /thru/i.test(weekday): return 'Thursday';
    break;
    case /fri/i.test(weekday): return 'Friday';
    break;
    case /sat/i.test(weekday): return 'Saturday';
    break;
    case /sun/i.test(weekday): return 'Sunday';
    break
    default: return false;
  }
}

function check_day(day) {

}

function check_month(month) {
  switch(true) {
    case /jan/i.test(month): return 'January';
    break;
    case /feb/i.test(month): return 'February';
    break;
    case /mar/i.test(month): return 'March';
    break;
    case /apr/i.test(month): return 'April';
    break;
    case /may/i.test(month): return 'May';
    break;
    case /jun/i.test(month): return 'June';
    break;
    case /jul/i.test(month): return 'July';
    break;
    case /aug/i.test(month): return 'August';
    break;
    case /sep/i.test(month): return 'September';
    break;
    case /oct/i.test(month): return 'October';
    break;
    case /nov/i.test(month): return 'November';
    break;
    case /dec/i.test(month): return 'December';
    break;
    default: return false;
  }
}

function change_error_icon(image,state) {
  if(state == 'error') {
    image.removeClass('okay-icon');
    image.addClass('error-icon');
    image.attr('src','/images/icons/red-x.png');
  } else {
    image.removeClass('error-icon');
    image.addClass('okay-icon');
    image.attr('src','/images/icons/large-check.png');
  }
}

function confirm_action(el) {
  $('.confirm').hide();
  $(el).fadeIn();
}

function check_frequency_empty(type,item,frequency) {
  if(!isEmpty($(frequency).val())) {
    check_frequency_val(type,item,frequency);
  } else {
    clear_form(type,item,false);
  }
}

function check_frequency_val(type,item,el) {
  var freq_val = $(el).val();

  var weekday = type+item+'weekday';
  var alternator = type+item+'alternator';
  var month = type+item+'month';
  var day = type+item+'day';


  var item_weekday = $('#'+weekday).parent();
  var item_alternator = $('#'+alternator).parent();
  var item_month = $('#'+month).parent();
  var item_day = $('#'+day).parent();
  var item_extra_fields = [item_weekday,item_day,item_month,item_alternator];
  var show_arr = [];

  if(freq_val.match(/(week)/i)) {
    show_arr = [item_weekday];
    if(freq_val.match(/(bi)/i) || freq_val.match(/every 2/i)) {
      show_arr.push(item_alternator);
    }
  } else if(freq_val.match(/(month)/i) || freq_val.match(/once/i) || freq_val.match(/one time/i) || freq_val.match(/one/i)) {
    show_arr = [item_day];
    if(freq_val.match(/(bi)/i) || freq_val.match(/every 2/i)) {
      show_arr.push(item_alternator);
    }
  } else if(freq_val.match(/(year)/i)) {
    show_arr = [item_month,item_day];
  }

  for(var i in item_extra_fields) {
    field = item_extra_fields[i];
    if(!include(show_arr,field)) {
      if(!field.hasClass('hide-this')) {
        remove_from_view(field,true);
      }
    }
  }

  for(var i in show_arr) {
    show = show_arr[i];
    if(show.hasClass('hide-this')) {
      add_to_view(show);
    }
  }
}

function add_to_view(el) {
  el.removeClass('hide-this');
  el.slideDown();
}

function remove_from_view(el,slide) {
  el.addClass('hide-this');
  slide ? el.slideUp() : el.hide();
}

function clear_form(type,item,slide) {
  var weekday = type+item+'weekday';
  var alternator = type+item+'alternator';
  var month = type+item+'month';
  var day = type+item+'day';

  var item_weekday = $('#'+weekday).parent();
  var item_alternator = $('#'+alternator).parent();
  var item_month = $('#'+month).parent();
  var item_day = $('#'+day).parent();
  var item_extra_fields = [item_weekday,item_day,item_month,item_alternator];

  for(var i in item_extra_fields) {
    current = item_extra_fields[i];
    if($(current).is(':visible')) {
      remove_from_view($(current),slide);
    }
  }
}

function include(arr,obj) {
    return (arr.indexOf(obj) != -1);
}

function isEmpty( inputStr ) { return !(inputStr&&inputStr.length) }

