class MessagesController < ApplicationController
  include MessagesHelper

  def create_message
    if(recipient_exists?(params[:message][:recipient_name]))
      @message = Message.new(message_params)
      if(@message.save)
        render :json => {}, status: :ok
      else
        render :json => {message: 'Unable to create message.'}, status: :bad_request
      end
    else
      render :json => {message: 'Recipient does not exist.'}, status: :bad_request
    end
  end

  def get_sent_messages
    user = User.find(params[:user_id])
    sent_messages = user.messages.where('deleted_by_sender = ?', false).order(created_at: :desc)

    render :json => {sent_messages: sent_messages}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to get sent messages. User could not be found.'}, status: :bad_request

  end

  def get_received_messages
    received_messages = Message.where('recipient_name = ? AND deleted_by_recipient = ?', params[:recipient_name], false).order(created_at: :desc).to_a
    render :json => {received_messages: received_messages}, status: :ok
  end

  def get_message
    @message = Message.find(params[:message_id])
    render :json => {message: @message}, status: :ok

    rescue ActiveRecord::RecordNotFound
      render :json => {message: 'Message not found.'}, status: :bad_request
  end

  def mark_as_read
    @message = Message.find(params[:message_id])
    if (@message.update_attribute(:unread, false))
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to mark message as read.'}, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to mark message as read.  Message could not be found.'}, status: :bad_request
  end

  def delete_as_sender
    @message = Message.find(params[:message_id])

    #if recipient has marked message for deletion, permanently remove from db
    if(@message[:deleted_by_recipient])
      @message.delete
      if(@message.destroyed?)
        render :json => {},  status: :ok
      else
        render :json => {message: 'Unable to delete message.'}, status: :bad_request
      end
    elsif (@message.update_attribute(:deleted_by_sender, true))
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to mark message as deleted.'}, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to mark message as deleted.  Message could not be found.'}, status: :bad_request
  end

  def delete_as_recipient
    @message = Message.find(params[:message_id])

    #if sender has marked message for deletion, permanently remove from db
    if(@message[:deleted_by_sender])
      @message.delete
      if(@message.destroyed?)
        render :json => {}, status: :ok
      else
        render :json => {message: 'Unable to delete message'}, status: :bad_request
      end
    elsif (@message.update_attribute(:deleted_by_recipient, true))
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to mark message as deleted.'}, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to mark message as deleted.  Message could not be found.'}, status: :bad_request
  end

  def suggest_recipients
    partial_recipient = params[:partial_recipient]
  end

  private
    def message_params
      params.require(:message).permit(:user_id, :subject, :contents, :recipient_name)
    end
  
end
