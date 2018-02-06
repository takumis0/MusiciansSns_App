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
end
