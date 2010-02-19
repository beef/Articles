class Admin::ArticlesController < Admin::BaseController
  unloadable
  sortable_attributes :created_at, :published_at, :title, :permalink, :published_to, :body, :description, :allow_comments, :created => 'users.name', :updated => 'updated_bies_articles.name' 

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.paginate :page => params[:page], :per_page => 20, :order => sort_order(:default => 'desc'), :include => [:created_by, :updated_by]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html { render :action =>'show' }
      format.xml  { render :xml => @article }
    end
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.updated_by = @article.created_by = current_user

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(admin_articles_url) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    @article.updated_by = current_user

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(admin_articles_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = 'Article was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
      format.xml  { head :ok }
    end
  end
  
  def preview
    preview_params = params[:news_article]
    article = Article.find_by_id(params[:id])
    preview_params.reverse_merge!(article.attributes) if article
    session[:article_preview] = preview_params
  end
end
