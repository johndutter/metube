class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_entries
  has_many :playlist_sentiments
end
