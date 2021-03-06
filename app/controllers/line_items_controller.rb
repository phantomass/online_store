class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:create, :decrease, :increase]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_line

  # GET /line_items
  # GET /line_items.json
  def index
    #@line_items = LineItem.all
    redirect_to root_url
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    redirect_to root_url
  end

  # GET /line_items/new
  def new
    #@line_item = LineItem.new
    redirect_to root_url
  end

  # GET /line_items/1/edit
  def edit
    redirect_to root_url
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)


    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart }
        # format.json { render action: 'show', status: :created, location: @line_item }
        format.js {}
        format.json { head :ok }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def decrease
    @line_item = @cart.decrease(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @cart }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def increase
    @line_item = @cart.increase(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @cart }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

    def invalid_line
      logger.error "Attempt to access invalid line #{params[:id]}"
      redirect_to root_url
    end
end
