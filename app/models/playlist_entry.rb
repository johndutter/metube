class PlaylistEntry < ActiveRecord::Base
  belongs_to :playlist
  has_one :multimedia
end
