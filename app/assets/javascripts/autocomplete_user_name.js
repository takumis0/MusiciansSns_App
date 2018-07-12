/*global $*/

$(window).load(function(){
    var tokens,
        initial_tokenfield = function(){
            $("#user_name_field").tokenfield({ //トークンフィールドの初期化
                autocomplete: {
                    source: function (req, res) {
                        $.ajax({
                        data: {
                            'options': encodeURIComponent($("#user_search_option").val()),
                            'term': req.term
                        },
                        url: "/users/autocomplete_user/" + 'data', //routes.jsでcontrollerに送ってる。
                        dataType: 'json',
                        success: function(data) {
                            res(data); //何やってるか分からなけど、autocomplete作業に必要
                        }});
                    },
                    autoFocus: true,
                    delay: 300,
                    minLength: 2,
                    beautify: false,
                },
                delimiter: '|',
                showAutocompleteOnFocus: true
            });
            $("#user_name_field").tokenfield('setTokens', tokens); //セッションに保存されていた、トークンをセット
        },
        update_tokens = function(){
            if(('sessionStorage' in window) && (window.sessionStorage !== null)) {//sessionStorageに対応？
                sessionStorage.clear(); //セッション初期化
                tokens = $("#user_name_field").tokenfield('getTokensList'); //フィールドの値を変数に代入
                sessionStorage.setItem('taken_token', tokens); //変数をセッションに保存
            }
            console.log("トークンは　" + tokens);
        };
        
    $(document).ready(function(){
        if(('sessionStorage' in window) && (window.sessionStorage !== null)) { //sessionStorageに対応？
            tokens = sessionStorage.getItem('taken_token'); //保存されていたトークンを読み込む
        }
        initial_tokenfield(); //トークンフィールドの宣言 & セッションから読み込んだトークンをフィールドにセット
        $("#user_name_field-tokenfield").keydown(function(e){
            if(e.which == 13) { //Enterキー
                $("#form-group-custom").submit(); //user#indexに移動
                return false;
            }
        });
        $('#user_name_field')
        .on('tokenfield:createdtoken', function (e) {
            update_tokens(); //セッションストレージの初期化 & 現在のトークンフィールド取得
        })
        .on('tokenfield:removedtoken', function (e) {
            update_tokens();
        });
    });
});