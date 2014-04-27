class CommentsController < ApplicationController
  def create_comment
    # INSERT INTO comments (multimedia_id, parent_id, text, user_id) VALUES (<multimedia_id>, <parent_id>, <text>, <user_id>);
    @comment = Comment.new(comment_params)
    if(@comment.save)
      render :json => {id: @comment[:id]}, status: :ok
    else
      render :json => {message: 'Comment failed.'}, status: :bad_request
    end
  end

  def get_comments
    # SELECT * FROM comments JOIN multimedia ON comments.multimedia_id = multimedia.id WHERE parent_id IS NULL ORDER BY comments.created_at ASC;
    comments = Multimedia.find(params[:multimedia_id]).comments.where('parent_id is NULL').order('created_at ASC').to_a
    comments_return = []
    comments.each do |entry|
      # SELECT username FROM users WHERE id = <id>;
      username = User.find(entry.user_id).username
      # SELECT * FROM comments WHERE parent_id = <parent_id> ORDER BY ASC;
      children = Comment.where('parent_id = ?', entry.id).order('created_at ASC').to_a
      children_return = []
      children.each do |child_entry|
        # SELECT username FROM users WHERE id = <id>;
        child_username = User.find(child_entry.user_id).username
        children_return.push({:id => child_entry.id, :multimedia_id => child_entry.multimedia_id, :parent_id => child_entry.parent_id, :text => child_entry.text, :created_at => child_entry.created_at, :username => child_username})
      end
      comments_return.push({:id => entry.id, :multimedia_id => entry.multimedia_id, :parent_id => entry.parent_id, :text => entry.text, :created_at => entry.created_at, :username => username, children: children_return})
    end
    render :json => {comments: comments_return}, status: :ok
  rescue
    render :json => {message: 'Get comments failed.'}, status: :bad_request
  end

  private
  def comment_params
    params.require(:comment).permit(:multimedia_id, :user_id, :text, :parent_id)
  end
end