class SubscriptionsController < ApplicationController
  def create_subscription
    # INSERT INTO subscriptions VALUES (<user_id>, <subscription_id>);
    @subscription = Subscription.new(subscription_params)
    if(@subscription.save)
      render :json => {id:@subscription[:id]}, status: :ok
    else
      render :json => {message: 'Subscription failed.'}, status: :bad_request
    end
  end

  def get_user_subscriptions
    # SELECT * FROM subscriptions WHERE user_id = <user_id>;
    all_subscriptions = User.find(params[:user_id]).subscriptions.to_a
    render :json => {subscriptions: all_subscriptions}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to get user subscriptions. Could not find user with id:' + params[:user_id]}, status: :bad_request
  end

  def is_user_subscribed?
    # SELECT * FROM subscriptions WHERE user_id = <user_id> AND subscription_id = <subscription_id>;
    @subscription = Subscription.where('user_id = ? AND subscription_id = ?', params[:user_id], params[:subscription_id]).to_a[0]
    if(@subscription != nil)
      render :json => {subscribed: true}, status: :ok
    else
      render :json => {subscribed: false}, status: :bad_request
    end
  end

  def delete_subscription
    # SELECT * FROM subscriptions WHERE user_id = <user_id> AND subscription_id = <subscription_id>;
    @subscription = Subscription.where('user_id = ? AND subscription_id = ?', params[:user_id], params[:subscription_id]).to_a[0]
    # DELETE FROM subscriptions WHERE user_id = <user_id> AND subscription_id = <subscription_id>;
    @subscription.destroy

    if(@subscription.destroyed?)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to unsubscribe.'}, status: :bad_request
    end
  end

  def get_user_subscriptions_overview
    # SELECT subscriptions.subscription_id as id, users.username FROM subscriptions LEFT OUTER JOIN users ON users.id = subscriptions.subscription_id WHERE user_id = <user_id> ORDER BY subscriptions.created_at DESC LIMIT 5;
    subscriptions = Subscription.where('user_id = ?', params[:user_id]).find(:all, :select => 'subscriptions.subscription_id as id, users.username', :joins => 'left outer join users on users.id = subscriptions.subscription_id', :order => 'subscriptions.created_at DESC', :limit => 5).to_a
    render :json => {subscriptions: subscriptions}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to get user subscriptions. Could not find user with id:' + params[:user_id]}, status: :bad_request
  end

  def get_channel_stats
    # SELECT * FROM users WHERE id = <subscription_id>;
    user = User.find(params[:subscription_id])

    #get total videos, total images, total media, total playlists, total subscribers, and total views
    # SELECT COUNT(*) FROM multimedia WHERE user_id = <user_id> AND mediaType = <'video'>;
    total_videos = user.multimedias.where('mediaType = ?', 'video').count
    # SELECT COUNT(*) FROM multimedia WHERE user_id = <user_id> AND mediaType = <'image'>;
    total_images = user.multimedias.where('mediaType = ?', 'image').count
    # SELECT COUNT(*) FROM multimedia WHERE user_id = <user_id> AND mediaType = <'audio'>;
    total_audio = user.multimedias.where('mediaType = ?', 'audio').count
    # SELECT COUNT(*) FROM playlists WHERE user_id = <user_id>;
    total_playlists = user.playlists.count
    total_views = user[:views]
    # SELECT COUNT(*) FROM subscriptions WHERE subscription_id = <subscription_id>;
    total_subscribers = Subscription.where('subscription_id = ?', params[:subscription_id]).count

    render :json => {channel_stats: {total_videos: total_videos, total_images: total_images, total_audio: total_audio, total_playlists: total_playlists, total_subscribers: total_subscribers, total_views: total_views}}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json =>{message: 'Unable to get channel stats. Channel with id:' + params[:subscription_id] + ' could not be found'}, status: :bad_request
  end

  def update_view_count
    # SELECT * FROM users WHERE id = <user_id>;
    @user = User.find(params[:subscription_id])

    # UPDATE users SET views = views + 1 WHERE id = <subscription_id>;
    @user.increment!(:views)
    if(@user.save)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to update view count.'}, status: :bad_request
    end
  end

  private
  def subscription_params
    params.require(:subscription).permit(:user_id, :subscription_id)
  end
end
