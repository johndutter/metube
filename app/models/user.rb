class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  require 'digest/sha2'
  
  attr_accessor :password_confirmation
  
  before_save :encrypt_password
  after_save  :clear_password
  
  #handle validation of user fields
  validates :username, presence: true, length: {maximum: 24}, uniqueness: true
  validates :encrypted_password, length: {minimum: 6, maximum: 256}
  validates :encrypted_password, :confirmation => true #password_confirmation attr
  
  EMAIL_REGEX = /\A[\w+\-.]+\@[a-z\d\-.]+.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  
  protected 

  def encrypt_password
    logger.info "#{:password}"
    self[:salt] = Digest::SHA2.hexdigest("#{self[:email]}#{Time.now}")
    self[:encrypted_password] = Digest::SHA2.hexdigest("#{self[:salt]}#{self[:encrypted_password]}")
  end
  
  #Remove password after it is stored so that it is not accessible
  def clear_password
    self.encrypted_password = nil
  end
  
  def self.authenticate(login_name="", login_password="")
    #check to see if user is in db
    user = User.find_by_username(login_name)
    logger.info "#{user}\n"
    
    #return user data if password matches
    if user && self.match_password(login_password, user[:encrypted_password], user[:salt])
      return user
    else
      return false
    end
  end   
  
  def self.match_password(login_password="", hashed_password, salt)
    logger.info "Salt is #{salt}\n hashed_is #{hashed_password} \n login_pw is #{login_password}\n"
    match = false
    if(hashed_password == Digest::SHA2.hexdigest("#{salt}#{login_password}"))
      logger.info "THEY MATCH\n"
      match = true
    else
      logger.info "NO MATCH\n"
      match = false
    end
    return match
  end
  
  
end
