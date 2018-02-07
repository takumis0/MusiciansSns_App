class User < ActiveRecord::Base
  has_many :favorites, dependent: :destroy
  validates :name, presence: true, length: {maximum: 50}
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  # prefecture_code:integer
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  include JpPrefecture
  jp_prefecture :prefecture_code, method_name: :pref
  
  def self.search(search) #self.でクラスメソッドとしている
    if search != nil # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
      #User.where(['name LIKE ?', "%#{search}%"])
      #User.joins(:favorites).where("favorite.artist like '%#{params[:search]}'").uniq
      #User.joins(:favorites).where(['favorites.artist LIKE ?', "%#{search}%"]).uniq
      User.joins(:favorites).where(['favorites.song LIKE ?', "%#{search}%"]).uniq
    else
      User.all #全て表示。
    end
  end
end
