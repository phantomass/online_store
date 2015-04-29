class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.all
  end

  def about

  end

  def services

  end

  def contacts

  end
end
