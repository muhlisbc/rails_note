class AccountController < ApplicationController

  before_action :authenticate!,               only:   [:index, :setting, :setting_post]
  before_action :already_signed_in?,          except: [:index, :setting, :setting_post, :logout, :confirm_email]
  before_action :user_from_token_and_digest,  only:   [:reset_password, :reset_password_post]
  before_action :user_from_email,             only:   [:login_post, :forgot_password_post]

  # Show current_user's latest notes
  # GET /acoount
  def index
    @notes = @user.notes.limit(10).order(created_at: :desc)
  end

  # Account setting
  # GET /account/setting
  def setting

  end

  # Update account setting
  # POST /account/setting
  def setting_post
    if @user.update(password: params[:password])
      flash[:success] = t "account.updated"
    else
      flash[:danger]  = {msg: t("account.update_failed"), list: @user.errors.full_messages}
    end
    render :setting
  end

  # Show alert if current_user not admin and email address is not confirmed
  # If param token is present, set is_email_confirmed to true
  # Otherwise render 403 page
  # GET /account/confirm_email
  def confirm_email
    if params[:token].present?
      user = User.find_by(email: Crypt.decrypt(params[:token]))
      user.update(is_email_confirmed: true)
      flash[:success] = t "account.confirmed"
      redirect_to account_path
    else
      if !current_user || current_user.is_email_confirmed
        page_403
      else
        render :confirm_email, layout: "authpage"
      end
    end
  end

  # Show signup form
  # GET /account/new
  def new
    @user = User.new
    render :new, layout: "authpage"
  end

  # Create new user account
  # POST /account/new
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      UserMailer.confirm_email(@user.email).deliver_now
      redirect_to confirm_email_account_path
    else
      flash[:danger]    = {msg: t("account.create_failed"), list: @user.errors.full_messages}
      render :new, layout: "authpage"
    end
  end

  # Show login form
  # GET /account/login
  def login
    render :login, layout: "authpage"
  end

  # Authenticate user
  # POST /account/login
  def login_post
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to account_path
    else
      flash[:danger]    = t "account.invalid_credential"
      render :login, layout: "authpage"
    end
  end

  # Logout
  # GET /account/logout
  def logout
    session[:user_id] = nil
    redirect_to login_account_path
  end

  def forgot_password
    render :forgot_password, layout: "authpage"
  end

  def forgot_password_post
    if @user
      UserMailer.reset_password(@user.email, @user.password_digest).deliver_now
      flash[:success] = t "account.reset_password_email_sent"
      redirect_to login_account_path
    else
      flash[:danger] = t "account.invalid_email"
      render :forgot_password, layout: "authpage"
    end
  end

  def reset_password
    render :reset_password, layout: "authpage"
  end

  def reset_password_post
    @user.update(password: params[:password])
    flash[:success] = t "account.password_reseted"
    redirect_to login_account_path
  end

  private

    def user_params(permited = [:email, :password])
      params.require(:user).permit(permited)
    end

    def email_confirmed?
      if !@user.is_admin && !@user.email_confirmed
        redirect_to confirm_email_account_path
      end
    end

    def already_signed_in?
      redirect_to account_path if current_user
    end

    def user_from_email
      @user ||= User.where(email: params[:email]).first
    end

    def user_from_token_and_digest
      @user ||= User.find_by(email: Crypt.decrypt(params[:token]), password_digest: Crypt.decrypt(params[:digest]))
    end

end
