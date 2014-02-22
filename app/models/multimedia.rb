class Multimedia < ActiveRecord::Base
  belongs_to :user
  has_many :sentiments
  has_many :tags
  has_one :delayed_job
  
  include ActiveModel::ForbiddenAttributesProtection
  include ApplicationHelper
  
  #handle validation
  validates :title, uniqueness: true, length: {maximum: 60}
  
  #store uploaded file on our server
  def self.store_media(fileData, fileName, fileType)
    #write files in public folder under uploads directory
    File.open(Rails.root.join('public', 'uploads', fileName + fileType), 'wb') do |file|
      file.write(fileData.read)
    end
  rescue
    raise ApplicationHelper::FileSaveError.new
  end

  #delete file stored on our server
  def self.delete_media(filePath)
    File.delete(filePath)
  rescue
    raise ApplicationHelper::FileDeleteError.new
  end

end
