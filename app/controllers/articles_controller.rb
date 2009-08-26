class ArticlesController < ApplicationController
  unloadable
  
  def index
    @page_title = 'Articles'
    if params[:category_id]
      @category = Category.find_by_permalink(params[:category_id])
      @page_title << " in category #{@category.title}"
    end
    if params[:tag]
      @page_title << " tagged with '#{params[:tag]}'"
    end
    if params[:user_id]
      @user = User.find_by_permalink(params[:user_id])
      @page_title << " writen by #{@user.name}"
    end
    if params[:year]
      @page_title << " from #{params[:day]} #{Date::MONTHNAMES[params[:month].to_i] unless params[:month].nil?} #{params[:year]}"
    end
    
    @articles = Article.in_time_delta( params[:year], params[:month], params[:day] ).published.tagged_with(params[:tag], :on => :tags).authored_by(@user).categorised(@category).paginate( :page => params[:page], :per_page => params[:per_page] || 6, :order => 'published_at DESC', :include => [:created_by] )
    
    @tags = Article.published.authored_by(@user).categorised(@category).tag_counts
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @articles }
      format.json { render :json => @articles }
      format.rss 
      format.js 
    end
  end

  def show
    @article = Article.published.find_by_permalink(params[:year], params[:month], params[:day], params[:permalink])
    
    @page_title = @article.title
    @page_description = @article.description
    @page_keywords = @article.tag_list
    
    @tags = @article.tag_counts
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end
  
  def preview
    @page_class = 'show'
    @article = Article.new(session[:article_preview])
    @article.published_at = Time.now
    @article.permalink = 'preview'
    session[:article_preview] = nil
    render :action => "show"
  end
end