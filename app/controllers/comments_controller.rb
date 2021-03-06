class CommentsController < ApplicationController
  unloadable
  
  before_filter :find_commentable

  def create
    raise ActionController::UnknownAction unless @commentable.allow_comments?
    
    @comment = @commentable.comments.build(params[:comment])
    
    if defined?( Viking )
      viking_response = Viking.check_comment( :user_ip => request.remote_ip,
                                              :article_date => @commentable.published_at,
                                              :comment_author => @comment.name,
                                              :comment_type => 'comment',
                                              :comment_content => @comment.comment,
                                              :comment_author_email => @comment.email,
                                              :user_logged_in => signed_in?,
                                              :referrer => request.referer,
                                              :permalink => @commentable )
                                              
      if viking_response                                        
        logger.info "VIKING RESPONSE: #{viking_response.inspect}"
        @comment.spam_filter = !viking_response[:spam]
        @comment.spam_signature = viking_response[:signature] if @comment.respond_to?(:spam_signature)
      else
        logger.warn "VIKING OPTIONS INCORRECT"
        @comment.spam_filter = true
      end
    else
      @comment.spam_filter = true
    end
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable }
        format.js
        format.json { render :json => @comment.to_json(:except => [:commentable_type, :commentable_id ]), :status => :created, :location => @commentable }
      else
        format.html { render :action => 'new' }
        format.js
        format.json { render :json => @comment.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end
  
protected

  def find_commentable
    case
    when params[:article_id]
      @commentable = Article.published.find(params[:article_id])
    end
    
    raise ActionController::UnknownAction if @commentable.nil?
  end

end
