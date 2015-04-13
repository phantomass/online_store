class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
  end

  def about

  end

  def services

  end

  def contacts

  end
end
