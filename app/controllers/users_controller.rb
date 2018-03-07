class UsersController < ApplicationController
  #before_action :authenticate_user!, :except=>[:show]
  
  def index
    @users = search(params[:search]).paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @user = User.find(params[:id])
    @favorites = @user.favorites
    @favorite = @favorites.build if signed_in?
  end
  
  def search(search)
    @existKeyBool = true #検索ワードの有無
    if search == nil || search == ''
      @existKeyBool = false
      User.all
    else
      patterns = search.split("|") #searchを配列に
      having_word_users_id = [] #全トークンに対応するuser_id配列
      @number_words = Hash.new{|hash, key| hash[key] = {} } #2次元ハッシュの初期化
      patterns.each do | pattern | #トークン毎に分割
        fixed_pattern = pattern.strip #余計な余白を削除
        each_pattern_users_id = User.joins(:favorites) #一つのトークンについてuser_idを取得
                                    .where("favorites.song LIKE ? OR favorites.artist LIKE ?", fixed_pattern, fixed_pattern).pluck(:id)
        having_word_users_id += each_pattern_users_id #取得済みのトークンと足す
        
        having_word_users_id.uniq.each do |usersId| 
          @number_words[usersId][fixed_pattern] = each_pattern_users_id.count(usersId) #user_id毎にハッシュ{トークン => そのトークンの参照回数}を代入
        end
      end
      having_word_users_id = having_word_users_id.group_by{|e| e}.sort_by{|_,v|-v.size}.map(&:first) #出現回数順にソート + ユニーク化
      for_case = '' #CASE文に入れる文字列 初期化
      having_word_users_id.each do |i|
        for_case += "CASE id WHEN '#{i}' THEN 1 ELSE 2 END, " #CASE文に入れる文字列 組み立て
      end
      having_word_users = User.where(id: having_word_users_id).group(:id).order(for_case + 'id') #order by caseで、id順番指定
      having_word_users
    end
  end
  
  def more_index
    index
  end
  
  def autocomplete_user()
    # オートコンプリートの候補表示部分、
    #user_names =  User.autocomplete(params[:term]).pluck(:name)
    
    case params[:options] # user_search_option(select)で選んだoptionを取得
    when "artistTerm"
      user_names = User.joins(:favorites).autocomplete_artist(params[:term]).pluck(:artist)
    when "songTerm"
      user_names = User.joins(:favorites).autocomplete_song(params[:term]).pluck(:song)
    else
      user_names = User.joins(:favorites).autocomplete_artist(params[:term]).pluck(:artist)
      user_names += User.joins(:favorites).autocomplete_song(params[:term]).pluck(:song)
    end
    respond_to do |format|
      format.html
      format.json {
        render json: user_names
      }
    end
  end
end