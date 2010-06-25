class Admin::ArticlesController < Admin::BaseController
  unloadable
  sortable_attributes :created_at, :published_at, :title, :permalink, :published_to, :body, :description, :allow_comments, :created => 'users.name', :category => 'categories.title', :updated => 'updated_bies_articles.name'

  # GET /articles
  # GET /articles.xml
  def index
    @articles = article_type.paginate :page => params[:page], :per_page => 20, :order => sort_order(:default => 'desc'), :include => [:created_by, :updated_by, :category]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = article_type.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = article_type.new

    respond_to do |format|
      format.html { render :action =>'show' }
      format.xml  { render :xml => @article }
    end
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = article_type.new(params[:article])
    @article.updated_by = @article.created_by = current_user

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to :action => 'index'  }
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
    @article = article_type.find(params[:id])
    @article.updated_by = current_user

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to :action => 'index' }
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
    @article = article_type.find(params[:id])
    @article.destroy
    flash[:notice] = 'Article was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
  end

  def preview
    preview_params = params[:article]
    article = article_type.find_by_id(params[:id])
    preview_params.reverse_merge!(article.attributes) if article
    session[:article_preview] = preview_params
  end

protected

  def article_type
    Article
  end

end
