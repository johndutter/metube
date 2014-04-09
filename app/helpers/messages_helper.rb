module MessagesHelper
  def recipient_exists?(recipient_name)
    recipient = User.where('username = ?', recipient_name)
    return recipient.any?
  end
end
