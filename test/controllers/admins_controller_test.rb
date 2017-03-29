require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user   = {email: "email@email.com", password: "password"}
    @user2  = {email: "email2@gmail.com", password: "password"}
  end

  test "should fail to visit admin page" do
    get admin_url
    assert_redirected_to login_account_path

    User.create @user
    post login_account_url, params: @user
    get admin_url
    assert_response :forbidden
  end

  test "should success to visit admin page" do
    User.create @user.merge(is_admin: true)
    post login_account_url, params: @user
    get admin_url
    assert_response :success
  end

  test "should fail to visit stat page" do
    formats = ["html", "json"]

    formats.each do |fmt|
      get stat_admin_url("user"), params: {format: fmt}
      assert_redirected_to login_account_path
    end

    User.create @user
    post login_account_url, params: @user
    formats.each do |fmt|
      get stat_admin_url("user"), params: {format: fmt}
      assert_response :forbidden
    end
  end

  test "should success visit stat page and show correct stat" do
    user = User.create @user.merge(is_admin: true)
    post login_account_url, params: @user

    get stat_admin_url("user")
    assert_response 404

    [
      ["note", DateTime.new(2015, 3, 4).utc, {content: "content", user_id: user.id}, 1],
      ["user", DateTime.new(2014, 2, 11).utc, @user2, {"confirmed" => 0, "unconfirmed" => 1}]
    ].each do |ctrl, date, data, count|
      ctrl.capitalize.constantize.create! data.merge(created_at: date)
      [date, DateTime.now.utc].each do |dt|
        get stat_admin_url(ctrl), params: {format: "json", year: dt.year, month: dt.month}
        assert_response :success

        parsed_data = JSON.parse(@response.body)["data"]

        assert_equal dt.year,                 parsed_data["year"].to_i
        assert_equal dt.month,                parsed_data["month"].to_i
        assert_equal dt.at_end_of_month.day,  parsed_data["days"].count

      end
    end
  end

  teardown do
    User.delete_all
    Note.delete_all
  end

end
