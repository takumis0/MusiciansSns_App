/* global $*/
$(document).ready(function(){ 
    var clicked_bool = false;
   $('.user_index_li').on('click' ,function() {
       if(clicked_bool) return;
       console.log('クリックする。');
       $(this).find('a')[0].click();
       clicked_bool = true;
    });
});