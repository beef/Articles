module CommentsHelper

  def comments_list(commentable)
    content_tag :ul, render(:partial => commentable.comments, :locals => { :commentable => commentable }), :id => 'comment-list'  unless commentable.comments.empty?
  end

end
