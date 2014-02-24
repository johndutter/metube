class Tag < ActiveRecord::Base
  belongs_to :multimedia
  belongs_to :playlist
end
