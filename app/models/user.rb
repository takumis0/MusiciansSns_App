class User < ActiveRecord::Base
  has_many :favorites, dependent: :destroy
  validates :name, presence: true, length: {maximum: 50}
  validates :tw_id, length: { maximum: 15, message: "@TwitterのIDは最大15文字です。@"}, 
                    format:{ with: /\A[A-Za-z]\w*\z/, message: "@TwitterのIDには英数字のみが使用できます。@" }, allow_nil: true
  validates :line_id, length: { maximum: 20, message: "@LINEのIDは最大20文字です。@" }, 
                      format:{ with: /\A[A-Za-z]\w*\z/, message: "@LINEのIDには英数字のみが使用できます。@" }, allow_nil: true
  validates :contact_adress, length: { maximum: 30 , message: "@連絡用アドレスは最大30文字です。@" },
                             format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "@無効なメールアドレスです。@"}, allow_nil: true
  validates :fb_id, length: { maximum: 30 , message: "@FacebookのIDは最大30文字です。@" }, 
                    numericality: { only_integer: true, message: "@FacebookのIDは数字のみが使用できます。@" }, allow_nil: true
  validates :insta_id, length: { maximum: 30, message: "@instagramのユーザーネームは最大30文字です。@" },
                       format:{ with: /\A[A-Za-z]\w*\z/, message: "@instagramのユーザーネームは英数字のみが使用できます。@" }, allow_nil: true
  validates :yt_url, length: { maximum: 100, message: "@100文字を超えるURLは保存出来ません。@" },
                     format:{ with: /\A(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/watch\?v\=+?/, 
                              message: "@有効なURLはhttps://www.youtube.com/watch?v=動画ID に当てはまるものです。@" }, allow_nil: true
  #validates :video_id, length: {is: 11}, format: { with: /\A[A-Za-z]\w*\z/ }, allow_nil: true
  mount_uploader :avatar, AvatarUploader
  mount_uploader :header, HeaderUploader
  
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
