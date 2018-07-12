/* global $*/
$(document).ready(function(){ 
   function nowLoading(){
         $("#more_link").replaceWith("<a id='more_link'>読込中</a>");
   }
   $(window).on("scroll", function() {
      var scrollHeight = $(document).height();
      var scrollPosition = $(window).height() + $(window).scrollTop();
      if (((scrollHeight - scrollPosition) / scrollHeight === 0) && document.getElementById("more_link") != null) {
         $('#more_link')[0].click(); // #more_linkをクリックした事に
         nowLoading();
      }
   });
});