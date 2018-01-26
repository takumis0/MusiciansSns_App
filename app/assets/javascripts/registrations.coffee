ready = ->
  dateFormat = 'yy-mm-dd';
  
  $('.date-picker').datepicker(
    dateFormat: dateFormat,
    changeMonth: true,
    changeYear: true,
    yearRange: '-100:+0',
    
  );
$(document).ready(ready)
$(document).on('turbolinks:load', ready)