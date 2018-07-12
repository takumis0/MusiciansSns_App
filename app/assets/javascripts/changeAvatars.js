/* global $*/
$(document).ready(function(){
    var avatar_image = $('#image_inAvatar'),
        avatar_select_link = $('#user_attr_avatar'),
        avatar_link = $('#submit_for_avatar'),
        header_image = $('#image_inCardheader'),
        header_select_link = $('#user_attr_header'),
        header_link = $('#submit_for_header');
        
    avatar_image.addClass('for_linkers');
    header_image.addClass('for_linkers');
    $('.favorite').addClass('for_linkers');
    
    avatar_image.on('click', function(){
        avatar_select_link[0].click();
    });
    avatar_select_link.change(function(data){
        avatar_link[0].click();
    });
    header_image.on('click', function(){
        header_select_link[0].click();
    });
    header_select_link.change(function(){
        header_link[0].click();
    });
});