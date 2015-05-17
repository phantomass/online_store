class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    @products = Product.paginate(:page => params[:page], :per_page => 9).order('price')
  end

  def about

  end

  def services

  end

  def contacts

  end
end