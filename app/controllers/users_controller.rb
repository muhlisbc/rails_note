class UsersController < ApplicationController

  before_action :authenticate_as_admin!
  before_action :set_user,                      only:   [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  # GET /users/1
  def show
    @notes = @user.notes.limit(10).order(created_at: :desc)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "users.created"
      redirect_to @user
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      flash[:success] = t "users.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    flash[:success] = t "users.deleted"
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
