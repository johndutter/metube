class SubscriptionsController < ApplicationController
  def create_subscription
    @subscription = Subscription.new(subscription_params)
    if(@subscription.save)
      render :json => {id:@subscription[:id]}, status: :ok
    else
      render :json => {message: 'Subscription failed.'}, status: :bad_request
    end
  end

  def get_user_subscriptions
    all_subscriptions = User.find(params[:user_id]).subscriptions.to_a
    render :json => {subscriptions: all_subscriptions}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to get user subscriptions. Could not find user with id:' + params[:user_id]}, status: :bad_request
  end

  def is_user_subscribed?
    @subscription = Subscription.where('user_id = ? AND subscription_id = ?', params[:user_id], params[:subscription_id]).to_a[0]
    if(@subscription != nil)
      render :json => {subscribed: true}, status: :ok
    else
      render :json => {subscribed: false}, status: :bad_request
    end
  end

  def delete_subscription
    @subscription = Subscription.where('user_id = ? AND subscription_id = ?', params[:user_id], params[:subscription_id]).to_a[0]
    @subscription.destroy

    if(@subscription.destroyed?)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to unsubscribe.'}, status: :bad_request
    end
  end

  private
  def subscription_params
    params.require(:subscription).permit(:user_id, :subscription_id)
  end
end
