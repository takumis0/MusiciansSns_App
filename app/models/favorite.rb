class Favorite < ActiveRecord::Base
    belongs_to :user
    default_scope -> { order('created_at DESC') }
    validates :user_id, presence: true, uniqueness:{ scope:[:song, :artist]}
    #validates :artist, :uniqueness => {:scope => :song}
end
