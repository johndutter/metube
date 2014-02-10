class Multimedia < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  #handle validation
  validates :title, uniqueness: true, length: {maximum: 60}
  
  #store uploaded file on our server
  def self.store_media(fileData, fileName, fileType)
    #write files in public folder under uploads directory
    File.open(Rails.root.join('public', 'uploads', fileName + fileType), 'wb') do |file|
      file.write(fileData.read)
    end
  end

  def set_path(fileExtension)
    self[:path] = '/public/uploads/' + (Multimedia.last()[:id] + 1).to_s + fileExtension
  end
end
