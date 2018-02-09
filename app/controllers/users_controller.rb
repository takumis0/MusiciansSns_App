class UsersController < ApplicationController
  before_action :authenticate_user!, :except=>[:show]
  
  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @favorites = @user.favorites
    @favorite = @favorites.build if signed_in?
  end
  
  
  def autocomplete_user
    #それぞれならオートコンプリート出来る。
    #user_names = User.autocomplete(params[:term]).pluck(:name)
    #user_names = User.joins(:favorites).uniq.autocomplete(params[:term]).pluck(:artist)
    user_names = User.joins(:favorites).uniq.autocomplete(params[:term]).pluck(:song)
    respond_to do |format|
      format.html
      format.json {
        render json: user_names
      }
    end
  end
  
end
