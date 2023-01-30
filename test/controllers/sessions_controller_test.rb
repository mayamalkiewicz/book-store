require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end
  
  test 'should get login' do
    get sessions_login_url
    assert_response :success
  end

  test "should login and redirect to user's page" do
    log_in_user
    assert_redirected_to @user
    assert logged_in?
  end

  test "should not login with invalid information" do
    get sessions_login_url
    post sessions_path, params: { session: { email: "", password: "" } } 
    assert_response :redirect
    assert_redirected_to sessions_login_path
  end

  test "should display alert message for invalid login" do
    post sessions_path, params: { session: { email: @user.email, password: 'wrong_password' } }
    assert_response :redirect
    assert_redirected_to sessions_login_path
    assert_equal 'Invalid email/password combination, try again!', flash[:alert]
    assert_not logged_in?
  end

  test "should create session" do
    log_in_user
    assert_redirected_to user_url(@user)
    assert_response :redirect
    assert_equal 'You are logged in!', flash[:notice]
    assert logged_in?
  end

  test "should destroy session" do
    log_in_user
    delete sessions_path
    assert_response :redirect
    assert_redirected_to users_path
    assert_equal 'You are logged out!', flash[:notice]
    assert_not logged_in?
  end
  
  test "should not redirect to login when already logged in" do
    log_in_user
    get sessions_login_path
    assert_redirected_to users_path
    assert_response :redirect
    assert_equal 'You must be logged out to view this page.', flash[:alert]
  end

  test "should redirect to login page if trying to access edit page while logged out" do
    get edit_user_path(@user)
    assert_redirected_to sessions_login_path
    assert_equal "You must be logged in to view this page.", flash[:alert]
  end

  test "should be able to sign-up a new user when already logged in" do
    log_in_user
    post users_path, params: { user: { date_of_birth: '2000-12-12', deleted: 'false', description: 'A new user',
    email: Faker::Internet.email, nick_name: 'john', password: 'johN123', password_confirmation: 'johN123' } }
    new_user = User.last
    assert_redirected_to user_path(new_user)
    assert_response :redirect
  end

  test "should not be able to log-in as a deleted user" do
    deleted_user = create(:user, deleted: true)
    post sessions_path, params: { session: { email: deleted_user.email, password: deleted_user.password } }
    assert_response :redirect
    assert_redirected_to sessions_login_path
    assert_equal flash[:alert], 'Invalid email/password combination, try again!'
  end

end