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
  
  def self.search(search)
    if search != nil
      patterns = search.split(", ") #searchを配列に
      where_body = ''
      patterns.each do | pattern |
        fixed_pattern = pattern.gsub("'", "''")
        where_body += ' OR ' unless where_body.blank?
        where_body += "(name LIKE '%#{fixed_pattern}%' OR favorites.song LIKE '%#{fixed_pattern}%' OR favorites.artist LIKE '%#{fixed_pattern}%')"
      end
      User.eager_load(:favorites).where(where_body).order("favorites.artist ASC")
    else
      User.all #全て表示。
    end
  end
end
