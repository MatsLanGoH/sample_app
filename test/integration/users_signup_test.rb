require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:testuser)
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar"} }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "password and confirmation do not match" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "Test User",
                                         email: "user@good.com",
                                         password:              "foobar",
                                         password_confirmation: "barfoo"} }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Mini Tester",
                                         email: "mini@me.com",
                                         password:              "supertest",
                                         password_confirmation: "supertest"} }
    end
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_select 'div.alert.alert-success'
  end

end

