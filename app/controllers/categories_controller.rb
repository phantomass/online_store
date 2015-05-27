class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize, only: [:show]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_category

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.order('name')
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @products = Product.paginate(:page => params[:page], :per_page => 9).where(category_id: params[:id])
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category }
        flash[:success] = "Категория создана!"
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category }
        flash[:success] = "Категория создана!"
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end

    def invalid_category
      logger.error "Attempt to access invalid category #{params[:id]}"
      redirect_to root_url
    end
end
