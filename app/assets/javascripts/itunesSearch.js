/*global $*/

$(window).on('load', function(){
  var initial_draggable = function(){
    $('.music_data').draggable({
      revert: false,
      cursorAt: { top: 20, left: 20 },
      helper: function( event ) { //ドラッグ中は音符Glyphiconになる。
        return $( "<span class='glyphicon glyphicon-music' id='music_icon'></span>" );
      }
    });
  };
  
  $(document).ready(function(){
    var
    preFunc = null,
    preInput = '',
    preSelect = '',
    input = '',
    select = '',
    itunesPost = function(input, select)
    {
      var params = {
          term: input,
          country: 'jp',
          media: 'music',
          attribute: select, //songTerm artistTerm genreIndexはindexだからX
          lang: 'ja_jp',
          limit: '20' //表示タイミングをkeyupにするなら10以下の方が良いと思う。
       };
       
       $.ajax({
          url: 'https://itunes.apple.com/search',
          method: 'GET',
          data: params,
          dataType: 'jsonp',
   
          //成功
          success: function(json) {
            showData(json);
          },
   
          //失敗
          error: function() {
            $(function(){
              $("#error").text("＊ エラーが発生しました ＊");
            });
          },
        });
    };
    
    initial_draggable();
    
    $('#inc_select').on('change' ,function() {
      checkForm();
    });
    
    $("#inc_search").keydown(function(e){
      console.log('13キー');
      if(e.which == 13) {
        checkForm();
        return false;
      }
    });
    
    //一旦コメントアウト中、使う可能性アリ
    /*$('#inc_search').on('keyup' ,function() { //keyupだとブラウザ側の処理が目まぐるしすぎるかも…
      console.log("お気に入り検索Keyup呼ばれてる");
      checkForm();
    });*/
    
    var checkForm = function(){
      input = $.trim($('#inc_search').val());   //前後の不要な空白を削除
      select = document.getElementById("inc_select").value;
      if(preInput !== input || preSelect !== select){
        clearTimeout(preFunc);
        preFunc = setTimeout(itunesPost(input,select), 1000);
      }
      preInput = input;
      preSelect = select;
    };
  });
  
  var showData = function(json) {
    $('#iTunes-result').empty();
    for (var i = 0, len = json.results.length; i < len; i++) {
      var result = json.results[i];
      var html_result = '<tr class="music_data">';
      html_result += '<td>' + result.trackName + '</td>';
      html_result += '<td>' + result.artistName + '</td>';
      html_result += '<td>' + result.primaryGenreName + '</td>';
      html_result += '</tr>';
      $('#iTunes-result').append(html_result);
    }
    initial_draggable();
  };
});