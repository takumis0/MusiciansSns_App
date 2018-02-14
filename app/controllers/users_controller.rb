class UsersController < ApplicationController
  #before_action :authenticate_user!, :except=>[:show]
  
  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @favorites = @user.favorites
    @favorite = @favorites.build if signed_in?
  end
  
  def autocomplete_user()
    #オートコンプリートの候補表示部分、
    user_names =  User.autocomplete(params[:term]).pluck(:name) #いらないかも
    
    case params[:options]
    when "artistTerm"
      user_names = User.joins(:favorites).autocomplete_artist(params[:term]).pluck(:artist)
    when "songTerm"
      user_names = User.joins(:favorites).autocomplete_song(params[:term]).pluck(:song)
    else
      user_names += User.joins(:favorites).autocomplete_artist(params[:term]).pluck(:artist)
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
