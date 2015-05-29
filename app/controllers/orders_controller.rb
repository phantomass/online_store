class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_order

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate(:page => params[:page], :per_page => 10).order('updated_at')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to root_path
      flash[:danger] = "Ваша корзина пуста!"
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
    redirect_to orders_url
  end

  # POST /orders
  # POST /orders.json
  def create
    if @cart.line_items.empty?
      redirect_to root_path
      flash[:danger] = "Ваша корзина пуста!"
      return
    end
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderNotifier.received(@order).deliver
        if @order.pay_type == "PayPal"
          format.html { redirect_to @order.paypal_url(products_url) }
        else
          format.html { redirect_to root_path }
          flash[:success] = "Спасибо за ваш заказ!"
          format.json { render action: 'show', status: :created, location: @order }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order }
        flash[:success] = "Заказ обновлен!"
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      flash[:success] = "Заказ удален"
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end

    def invalid_order
      logger.error "Attempt to access invalid order #{params[:id]}"
      redirect_to root_url
    end
end
