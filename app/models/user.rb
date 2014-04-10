class User < ActiveRecord::Base
  has_many :sentiments
  has_many :multimedias
  has_many :playlist_sentiments
  has_many :playlists
  has_many :subscriptions
  has_many :messages

  include ActiveModel::ForbiddenAttributesProtection
  require 'digest/sha2'
  
  #handle validation of user fields
  validates :username, presence: true, length: {maximum: 24}, uniqueness: true
  validates :encrypted_password, length: {minimum: 6, maximum: 256}
  
  EMAIL_REGEX = /\A[\w+\-.]+\@[a-z\d\-.]+.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :firstname, length: {maximum: 24}
  validates :lastname, length: {maximum: 24}
  validates :phone, length: {maximum: 24}
  
  def encrypt_password
    self[:salt] = Digest::SHA2.hexdigest("#{self[:email]}#{Time.now}")
    self[:encrypted_password] = Digest::SHA2.hexdigest("#{self[:salt]}#{self[:encrypted_password]}")
  end

  protected
  
  def self.authenticate(login_name="", login_password="")
    #check to see if user is in db
    user = User.find_by_username(login_name)
    
    #return user data if password matches
    if user && self.match_password(login_password, user[:encrypted_password], user[:salt])
      return user
    else
      return false
    end
  end   
  
  def self.match_password(login_password="", hashed_password, salt)
    return hashed_password == Digest::SHA2.hexdigest("#{salt}#{login_password}")
  end
  
  
end
