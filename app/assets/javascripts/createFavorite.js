/*global $*/

$(document).ready(function(){
  var ajaxPost = function(musician, title) //favoriteハッシュをコントローラに送信
      {
        $.ajax({
            url: '/favorites#create',
            type: "POST",
            data: {"favorite":{"song":title, "artist":musician}},
            //成功
            success: function() {
              initial_draggable();
            }, 
            //失敗
            error : function() {
            },
        });
      },
      initial_draggable = function() //Draggable要素が追加された時のための初期化群
      {
        $('.favorite').draggable({
          containment: $('#favorites_contents'), //このidの範囲でドラッグ出来る。
          revert: false, //ドロップすると元の位置に戻る。
          cursorAt: { top: 20, left: 20 }, //ドラッグ中のカーソルの位置
          helper: function( event ) { //ドラッグ中は音符Glyphiconになる。
            return $( "<span class='glyphicon glyphicon-music' id='music_icon'></span>" );
          }
        });
        $('#trash_favorites_area').droppable({
          accept: '.favorite', //このクラスをもつ要素だけがドロップ出来る。
          hoverClass: "trash_icon_active", //draggableが重なるとclassを適用
          drop: function(event, ui) { //ドロップされた時に呼ばれる。ui.draggableにはドロップされた要素のjQueryオブジェクトが入っている。
            var delete_link_obj = ui.draggable.find("a"); //deleteリンクを取得
            delete_link_obj.click(); //見た目上では隠してあるdeleteリンクをクリック。
          }
        });
        $('#my_favorites').droppable({
          accept: '.music_data',
          hoverClass: "trash_icon_active", //draggableが重なるとclassを適用
          drop: function(event, ui) {
            var tr_element = ui.draggable[0], //jQueryオブジェクト => HTMLオブジェクト して変数化
            artistTerm = unescapeHTML(tr_element.children[1].innerHTML),
            titleTerm = unescapeHTML(tr_element.children[0].innerHTML);
            ajaxPost(artistTerm, titleTerm);
          }
        });
      };
      
  initial_draggable(); //Draggable & Droppable初期化
  
  $(document).on('ajax:complete', '.favorite_delete', function(event, ajax, status){ //favorite_deleteで、そのidのfavoriteがフェードアウトする。
    var response;
    response = $.parseJSON(ajax.responseText); //ajaxで受け取ったfavorite・JSONをjQueryオブジェクトに変換
    $('#favorite_' + response.favorite.id).fadeOut(300); //受け取ったfavoriteのidで指定した、パーシャルを削除
  });
  
  function unescapeHTML(str) { //HTMLの特殊文字等をAjax送信に変換
    return str.replace(/&lt;/g,'<')
              .replace(/&gt;/g,'>')
              .replace(/&amp;/g,'&');
  }
});

