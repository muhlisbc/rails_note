require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = {email: "email@email.com", password: "password"}
    @user2 = {email: "email2@email.com", password: "password"}
  end

  test "should fail to visit users page if not authenticated" do
    [:index, :new].each do |act|
      get url_for(controller: "users", action: act)
      assert_redirected_to login_account_path
    end
  end

  test "should fail to visit users page if not admin" do
    User.create @user
    post login_account_url, params: @user
    [:index, :new].each do |act|
      get url_for(controller: "users", action: act)
      assert_response :forbidden
    end
  end

  test "should success to visit users page if admin" do
    User.create @user.merge(is_admin: true)
    post login_account_url, params: @user
    [:index, :new].each do |act|
      get url_for(controller: "users", action: act)
      assert_response :success
    end
  end

  test "should fail to create new user" do
    assert_no_difference("User.count") do
      post users_url, params: {user: @user}
      assert_redirected_to login_account_path
    end

    User.create @user
    post login_account_url, params: @user
    assert_no_difference("User.count") do
      post users_url, params: {user: @user}
      assert_response :forbidden
    end
  end

  test "should success to create new user" do
    User.create @user.merge(is_admin: true)
    post login_account_url, params: @user
    assert_difference("User.count") do
      post users_url, params: {user: @user2}
      user = User.last
      assert_redirected_to user_url(user)
      get user_url(user)
      assert_response :success
    end
  end

  test "should fail to update user" do
    user = User.create @user

    patch user_url(user), params: {user: {email: "newemail@email.com"}}
    assert_equal user.email, User.first.email
    assert_redirected_to login_account_path

    user2 = User.create @user2
    post login_account_url, params: @user2
    patch user_url(user), params: {user: {email: "newemail@email.com"}}
    assert_equal user.email, User.first.email
    assert_response :forbidden
  end

  test "should success to update user" do
    user  = User.create @user.merge(is_admin: true)
    user2 = User.create @user2
    post login_account_url, params: @user
    patch user_url(user2), params: {user: {email: "newemail@email.com"}}
    assert_not_equal user2.email, User.last.email
    assert_redirected_to user_url(user2)
  end

  test "should fail to delete user" do
    user  = User.create @user
    assert_no_difference("User.count") do
      delete user_url(user)
      assert_redirected_to login_account_path
    end

    user2 = User.create @user2
    post login_account_url, params: @user2

    assert_no_difference("User.count") do
      delete user_url(user)
      assert_response :forbidden
    end
  end

  test "should success to delete user" do
    user  = User.create @user.merge(is_admin: true)
    user2 = User.create @user2
    post login_account_url, params: @user
    assert_difference("User.count", -1) do
      delete user_url(user2)
      assert_redirected_to users_url
    end
  end

  teardown do
    User.delete_all
  end
end
