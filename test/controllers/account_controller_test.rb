require 'test_helper'

class AccountControllerTest < ActionController::TestCase

  def signup(user)
    post :create, params: {user: user}
  end

  def login(user)
    post :login_post, params: user
  end

  def should_redir_to_login
    assert_redirected_to login_account_path
  end

  setup do
    @require_auth = [:index, :setting]
    @not_require_auth = [:new, :login, :forgot_password, :reset_password]
    @invalid_users = [
        {email: "", password: "password"},
        {email: "email", password: "password"},
        {email: "email@email.com", password: ""},
        {email: "email@email.com", password: "shortpw"}
      ]
    @valid_user = {email: "email@email.com", password: "password"}
  end

  test "should redirected to login page if not authenticated" do
    @require_auth.each do |act|
      get act
      should_redir_to_login
    end
  end

  test "should failed to create new user with invalid credentials" do
    @invalid_users.each do |cred|
      assert_no_difference("User.count") do
        signup cred
        assert_response :success
      end
    end
  end

  test "should success to create new user with valid credentials" do
    assert_difference("ActionMailer::Base.deliveries.size") do
      assert_difference("User.count") do
        signup @valid_user
        assert_redirected_to confirm_email_account_path
        assert_not_nil session[:user_id]
      end
    end

    email = ActionMailer::Base.deliveries.last

    assert_equal @valid_user[:email], email.to[0]
    [:html_part, :text_part].each do |part|
      assert_match(/confirm/i, email.send(part).body.to_s)
    end
  end

  test "should fail to visit confirm_email page if not authenticated and without token" do
    get :confirm_email
    assert_response :forbidden
  end

  test "should success to confirm email" do
    user = User.create(@valid_user)
    get :confirm_email, params: {token: Crypt.encrypt(@valid_user[:email])}
    assert_redirected_to account_path
    assert User.where(email: @valid_user[:email]).first.is_email_confirmed
  end

  test "should success to login and logout" do
    user = User.create(@valid_user.merge(is_email_confirmed: true))
    login @valid_user
    assert_redirected_to account_path

    @not_require_auth.each do |act|
      get act
      assert_redirected_to account_path
    end
    @require_auth.each do |act|
      get act
      assert_response :success
    end

    get :logout
    @not_require_auth.each do |act|
      get act
      assert_response :success
    end
    @require_auth.each do |act|
      get act
      should_redir_to_login
    end

  end

  test "should sent reset password email" do
    user = User.create(@valid_user)
    assert_difference("ActionMailer::Base.deliveries.size") do
      post :forgot_password_post, params: {email: user.email}
      should_redir_to_login
    end

    email = ActionMailer::Base.deliveries.last

    assert_equal user.email, email.to[0]
    [:html_part, :text_part].each do |part|
      assert_match(/reset your password/i, email.send(part).body.to_s)
    end
  end

  test "should not sent reset password email" do
    get :forgot_password
    assert_no_difference("ActionMailer::Base.deliveries.size") do
      post :forgot_password_post, params: {email: "email"}
      assert_match(/invalid/i, flash[:danger])
      assert_response :success
    end
  end

  test "should success to reset password and success login with new password" do
    user = User.create(@valid_user)
    get :reset_password, params: {token: Crypt.encrypt(user.email), digest: Crypt.encrypt(user.password_digest)}
    assert_response :success
    post :reset_password_post, params: {password: "newpassword"}
    assert_not_equal user.password_digest, User.find_by(email: user.email).password_digest
    should_redir_to_login
    # login failed with old password
    login @valid_user
    assert_response :success
    assert_nil session[:user_id]
    # login success with new password
    login @valid_user.merge(password: "newpassword")
    assert_redirected_to account_path
    assert_equal session[:user_id], user.id
  end

  teardown do
    User.delete_all
  end

end
