class Admin::CommentsController < Admin::BaseController
  unloadable
  sortable_attributes :created_at, :name, :comment

  def index

    case
    when params[:article_id]
      @commentable = Article.find_by_id( params[:article_id] )
      @comments = @commentable.comments.paginate :page => params[:page], :order => sort_order
    else
      @comments = Comment.paginate :page => params[:page], :order => sort_order
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to( :back ) }
      format.xml  { head :ok }
    end
  end
end
