class FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = current_user
    @favorites = current_user.favorites
    @favorite = current_user.favorites.build(favorite_params)
    if @favorite.save
      respond_to do |format|
        format.js #create.js.erbを呼び出し
      end
    else
      render js: "alert('この曲は既に登録されています。');"
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    render :json => {:favorite => @favorite}
  end
  
  private
    def favorite_params
        params.require(:favorite).permit(:artist, :song)
    end
end