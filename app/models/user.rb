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
  
  scope :autocomplete, ->(term) {
    #where("name LIKE ?", "#{term}%").order(:name)
    joins(:favorites).where('name LIKE ? OR favorites.song LIKE ? OR favorites.artist LIKE ?', "#{term}%","#{term}%","#{term}%").uniq
  }
  
  def self.search(search) #self.でクラスメソッドとしている
    if search != nil # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
      
      User.joins(:favorites).where(['name LIKE ? OR favorites.song LIKE ? OR favorites.artist LIKE ?', "%#{search}%","%#{search}%","%#{search}%"]).uniq
    else
      User.all #全て表示。
    end
  end
end
