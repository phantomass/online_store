class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize, :categories_find_all

  protected

    def authorize
      return if User.count.zero? #*
      unless User.find_by(id: session[:user_id])
        redirect_to root_url
      end
    end

    def categories_find_all
      @categories = Category.order('name')
    end
end
