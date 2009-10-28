class Admin::CategoriesController < Admin::BaseController
  unloadable
  sortable_attributes :title, :description 

  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.paginate :page => params[:page], :order => sort_order

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @category }
    end
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(admin_categories_url) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(admin_categories_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:notice] = 'Category was successfully deleted.'
    else
      flash[:error] = 'Category could not be deleted as it has content associated with it'
    end

    respond_to do |format|
      format.html { redirect_to(admin_categories_url) }
      format.xml  { head :ok }
    end
  end
end
