class Admin::UsersController < Admin::BaseController

  def dashboard
    user = User.all

  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
