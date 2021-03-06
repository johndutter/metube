class UsersController < ApplicationController
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.encrypt_password
    if @user.save
      render :json => { user_id: @user[:id] }, status: :ok
    else
      render :json => { user_id: '' }, status: :bad_request
    end
  end

  def get_user_info
    if check_login
      @user = User.find(session[:user_id])
      render :json => { username: @user[:username], userid: @user[:id], loggedin: true }, status: :ok
    else
      render :json => { username: '', userid: '', loggedin: false }, status: :ok
    end
  end

  def get_user_profile
    if check_login
      @user = User.find(session[:user_id])
      render :json => { email: @user[:email], firstname: @user[:firstname], lastname: @user[:lastname], phone: @user[:phone] }, status: :ok
    else
      render :json => { }, status: :bad_request
    end
  end

  def update_user_profile
    if check_login
      @user = User.find(session[:user_id])
      if @user.update(user_profile_params)
        render :json => { }, status: :ok
      else
        render :json => { }, status: :bad_request
      end
    else
      render :json => { }, status: :bad_request
    end
  end

  def update_user_password
    if check_login
      @user = User.find(session[:user_id])
      @user = User.authenticate(@user[:username], params[:oldpassword])
      @user[:encrypted_password] = params[:encrypted_password]
      @user.encrypt_password
      if @user.save
        render :json => { }, status: :ok
      else
        render :json => { }, status: :bad_request
      end
    else
      render :json => { }, status: :bad_request
    end
  end

  def get_uploader_info
    @user = User.find(params[:id])
    render :json => { username: @user[:username] }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => { message: 'Unable to get uploader info.' }, status: :bad_request
  end

  def get_sentiment_info
    @multimedia = Multimedia.find(params[:multimedia_id])
    likes = @multimedia.sentiments.where(:like => true).count
    dislikes = @multimedia.sentiments.where(:dislike => true).count

    if check_login
      @user = User.find(session[:user_id])
      @sentiment = @user.sentiments.where(:multimedia_id => params[:multimedia_id])  

      if @sentiment.empty?
        render :json => { like: false, dislike: false, likes: likes, dislikes: dislikes }, status: :ok
      else
        render :json => { like: @sentiment[0][:like], dislike: @sentiment[0][:dislike], likes: likes, dislikes: dislikes }, status: :ok
      end
      
    else
      render :json => { like: false, dislike: false, likes: likes, dislikes: dislikes }, status: :ok
    end
  rescue
    render :json => { }, status: :bad_request
  end

  def sentiment_multimedia
    if check_login
      @user = User.find(session[:user_id])
      @multimedia = Multimedia.find(params[:multimedia_id])

      @sentiment = @user.sentiments.where(:multimedia_id => params[:multimedia_id])

      if @sentiment.empty?
        if params[:option] == "like"
          Sentiment.create(:user_id => @user.id, :multimedia_id => @multimedia.id, :like => true, :dislike => false)
        else
          Sentiment.create(:user_id => @user.id, :multimedia_id => @multimedia.id, :dislike => true, :like => false)
        end
      else
        if params[:option] == "like"
          @sentiment[0].update_attribute(:like, true)
          @sentiment[0].update_attribute(:dislike, false)
        else
          @sentiment[0].update_attribute(:like, false)
          @sentiment[0].update_attribute(:dislike, true)
        end
      end

      @sentiment = @user.sentiments.where(:multimedia_id => params[:multimedia_id]) # definitely created by now
      likes = @multimedia.sentiments.where(:like => true).count
      dislikes = @multimedia.sentiments.where(:dislike => true).count
      render :json => { like: @sentiment[0][:like], dislike: @sentiment[0][:dislike], likes: likes, dislikes: dislikes }, status: :ok
    else
      render :json => { }, status: :bad_request
    end
  rescue
    render :json => { }, status: :bad_request
  end

  def get_user_multimedia_in_progress
    @user = User.find(params[:user_id])
    videos_in_progress = []

    @user.multimedias.map.each do |multimedia|
      delayed_job = multimedia.delayed_job
      if(delayed_job != nil && delayed_job[:failed_at] == nil)
        videos_in_progress.push(multimedia)
      end
    end
    render :json => {videosInProgress: videos_in_progress}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {}, status: :bad_request
  end

  # get user sentiment for specified playlist
  def get_playlist_sentiment
    playlist_sentiment = PlaylistSentiment.where('user_id = ? AND playlist_id = ?', params[:user_id], params[:playlist_id]).to_a[0]
    if(playlist_sentiment != nil)
      render :json => {like: playlist_sentiment[:like]}, status: :ok
    else
      render :json => {like: 0}, status: :ok
    end
  end

  # like or unlike a playlist
  def update_playlist_sentiment
    if check_login
      playlist_sentiment = PlaylistSentiment.where('user_id = ? AND playlist_id = ?', params[:user_id], params[:playlist_id]).to_a[0]
      update_success = false
      # sentiment must be created if it doesn't exist
      if(playlist_sentiment == nil)
        PlaylistSentiment.create({user_id: params[:user_id], playlist_id: params[:playlist_id], like: true})
        update_success =true
      else
        if(params[:sentiment] == 'like')
          update_success = playlist_sentiment.update_attribute(:like, true)
        else
          update_success = playlist_sentiment.update_attribute(:like, false)
        end
      end

      if(update_success)
        render :json => {}, status: :ok
      else
        render :json =>{message: 'Unable to update playlist sentiment.'}, status: :bad_request
      end
    else
      render :json => {message: 'Unable to update playlist sentiment.'}, status: :bad_request
    end
  end

  # get a list of channels (users)
  def get_channels
    channels = User.find(:all, :select => 'id, username, firstname, lastname', :order => 'created_at DESC')
    return_channels = Array.new
    for channel in channels
      subscriber_count = Subscription.where(subscription_id: channel.id).count
      media_count = User.find(channel.id).multimedias.count
      return_channels.push({id: channel.id, username: channel.username, firstname: channel.firstname, lastname: channel.lastname, subscriber_count: subscriber_count, multimedia_count: media_count })
    end
    render :json => {channels: return_channels}, status: :ok
  end

  # out of the top 20 randomly select 5 channels
  def get_few_channels
    channels = User.find(:all, :select => 'users.id, users.username, count(subscriptions.subscription_id) as subscribers', :joins => 'left outer join subscriptions on subscriptions.subscription_id = users.id', :group => 'users.id', :order => 'subscribers DESC', :limit => 20)
    
    # if array > 5 then shuffle and pick 5
    if channels.length > 5
      channels = channels.shuffle
      channels = channels.slice(0,5)
    end
    render :json => {channels: channels}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :encrypted_password, :password_confirmation, :firstname, :lastname, :phone)
    end

    def user_profile_params
      params.require(:user).permit(:email, :firstname, :lastname, :phone)
    end
end
