module MessagesHelper
  def recipient_exists?(recipient_name)
    # SELECT * FROM user WHERE username = <username>;
    recipient = User.where('username = ?', recipient_name)
    return recipient.any?
  end
end
