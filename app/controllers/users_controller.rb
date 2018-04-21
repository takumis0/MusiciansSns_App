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
  
  def edit_avatar_image #プロフィール画像変更
    @user = current_user
    @user.avatar = params[:user][:attr_avatar]
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def edit_header_image #ヘッダー画像変更
    @user = current_user
    @user.header = params[:user][:attr_header]
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def edit_introduction #自己紹介文 変更
    @user = current_user
    @user.introduction = params[:user][:introduction]
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_twitter_id #Twitter_ID 変更
    @user = current_user
    @user.tw_id = params[:user][:tw_id].strip
    if @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_twitter_id #Twitter_ID 削除
    @user = current_user
    @user.tw_id = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_line_id #LINE_ID 変更
    @user = current_user
    @user.line_id = params[:user][:line_id].strip
    if @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_line_id #LINE_ID 削除
    @user = current_user
    @user.line_id = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_facebook_id #Facebook_ID 変更
    @user = current_user
    @user.fb_id = params[:user][:fb_id].strip
    if @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_facebook_id #Facebook_ID 削除
    @user = current_user
    @user.fb_id = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_adress_id #コンタクト用アドレス 変更
    @user = current_user
    @user.contact_adress = params[:user][:contact_adress].strip
    if @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_adress_id #コンタクト用アドレス 削除
    @user = current_user
    @user.contact_adress = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_instagram_id #insta_id 変更
    @user = current_user
    @user.insta_id = params[:user][:insta_id].strip
    if @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_instagram_id #insta_id 削除
    @user = current_user
    @user.insta_id = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def registration_youtube_url
    @user = current_user
    new_yt_url = params[:user][:yt_url]
    @user.yt_url = new_yt_url
    if @user.valid?(:yt_url)
      @user.video_id = view_context.make_video_id(new_yt_url)
      @user.save
      redirect_to :action => 'show', :id => @user.id
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to :action => 'show', :id => @user.id
    end
  end
  
  def destroy_youtube_url
    @user = current_user
    @user.yt_url = nil
    @user.video_id = nil
    @user.save
    redirect_to :action => 'show', :id => @user.id
  end
  
  def search(search)
    @existKeyBool = true #検索ワードの有無
    if search == nil || search == ''
      @title = 'All Users'
      @existKeyBool = false
      User.all
    else
      @title = 'Searched Users'
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
  
  def more_index #もっと読み込むアクション
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
  
  private
    def user_params
        params.require(:user).permit(:name, :email, :introduction, :prefecture_code, :birthday, :avatar, :header, 
                                     :tw_id, :line_id, :contact_adress, :fb_id, :insta_id)
    end
end