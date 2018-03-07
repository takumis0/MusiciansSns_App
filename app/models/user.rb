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
  
  #autocomplete表示部で使う、スコープ
  #scope :autocomplete, ->(term){
  #  where('name LIKE ?', "#{term}%")
  #}
  scope :autocomplete_song, ->(term) {
    joins(:favorites).where('favorites.song LIKE ?',"#{term}%").uniq
  }
  scope :autocomplete_artist, ->(term) {
    joins(:favorites).where('favorites.artist LIKE ?',"#{term}%").uniq
  }
end
