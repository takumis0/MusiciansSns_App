/* global $*/
$(document).ready(function(){
    var rotate;
    $('#record_image').on('click' ,function() {
        if($(this).hasClass('rotate_image')){
            rotate = $(this).css('transform');
            $(this).css('transform', rotate);
            $(this).removeClass('rotate_image');
        } else {
            $(this).addClass('rotate_image');
        }
    });
});