class SessionsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def new
    @secur1 = {"qwerty"=>nil, "action"=>"new", "controller"=>"sessions"}
    @secur = params
    if @secur == @secur1
      if session[:user_id]
        redirect_to admin_url
      end
    else
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end
  end

  def create
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Неверная комбинация имени и пароля"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Сеанс работы завершен"
  end
end
