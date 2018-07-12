/* global $*/

$(document).ready(function(){
    var users_li = $('#users_index li');
    // リストを非表示
	users_li.hide();
	users_li.css('margin-left', '-140px');
	// 繰り返し処理
	users_li.each(function(i) {
		// 遅延させてフェードイン
		$(this).delay(300 * i).fadeIn(500);
		$(this).animate({'marginLeft':'0px'},500);
	});
});