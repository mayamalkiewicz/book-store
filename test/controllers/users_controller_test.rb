# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, :regular)
    @params = { date_of_birth: @user.date_of_birth + 1.year, description: 'New description',
                deleted: true, email: 'new_admin_mail@mail.pl', nick_name: 'admin_nick_name2' }
    @new_password = 'Password2'
    @password_params = { password: @new_password, password_confirmation: @new_password }
  end

  class RequireAdminLoggedIn < UsersControllerTest
    setup do
      @admin = create(:user, :admin)
      log_in(@admin)
    end

    test 'should get index if logged in as the admin' do
      get users_url
      assert_response :success
    end

    test 'should get new if logged in as the admin' do
      get new_user_url
      assert_response :success
    end

    test 'should create user if logged in as the admin' do
      @params[:deleted] = false
      assert_difference('User.count') do
        post users_url, params: { user: @params.merge(@password_params) }
      end
      assert_response :found
    end

    test 'should show user if logged in as the admin' do
      get user_url(@user)
      assert_response :success
    end

    test 'should update admin info if logged in as the admin without updating password' do
      patch user_url(@admin), params: { user: @params }
      assert_redirected_to user_url(@admin)
      @admin.reload
      assert_attributes(@admin, @params)
    end

    test 'should update admin password' do
      patch user_url(@admin), params: { user: @password_params }
      assert_redirected_to user_url(@admin)
      @admin.reload
      assert @admin.authenticate(@new_password)
    end

    test 'should update regular user if logged in as the admin without updating password' do
      patch user_url(@user), params: { user: @params }
      assert_redirected_to user_url(@user)
      @user.reload
      assert_attributes(@user, @params)
    end

    test 'should update regular users password if logged in as the admin' do
      patch user_url(@user), params: { user: @password_params }
      assert_redirected_to user_url(@user)
      @user.reload
      assert @user.authenticate(@new_password)
    end

    test 'should destroy admin if logged in as the admin' do
      delete user_url(@admin)
      assert :deleted
      assert_redirected_to users_url
      assert_equal 'User was successfully deleted.', flash[:notice]
    end

    test 'should destroy regular user if logged in as the admin' do
      delete user_url(@user)
      assert :deleted
      assert_redirected_to users_url
      assert_equal 'User was successfully deleted.', flash[:notice]
    end
  end

  class RequireUserLoggedIn < UsersControllerTest
    setup do
      @user2 = create(:user)
      log_in(@user)
    end

    test 'should get index if logged in as a user' do
      get users_url
      assert_response :success
    end

    test 'should get new if logged in as a user' do
      get new_user_url
      assert_response :success
    end

    test 'should create user if logged in as a user' do
      assert_difference('User.count') do
        @params[:deleted] = false
        post users_url, params: { user: @params.merge(@password_params) }
      end
      assert_response :found
    end

    test 'should get edit if logged in as a user' do
      get edit_user_url(@user)
      assert_response :success
    end

    test 'should update user if logged in as a user without updating password' do
      patch user_url(@user), params: { user: @params }
      assert_redirected_to user_url(@user)
      @user.reload
      assert_attributes(@user, @params)
    end

    test 'should update regular users password if logged in as the regular user' do
      patch user_url(@user), params: { user: @password_params }
      assert_redirected_to user_url(@user)
      @user.reload
      assert @user.authenticate(@new_password)
    end

    test 'should not update other user if logged in as a regular user' do
      patch user_url(@user2)
      assert_redirected_to users_url
      assert_equal 'You must be logged in as this user to view this page.', flash[:alert]
    end

    test 'should destroy user if logged in as a user' do
      delete user_url(@user)
      assert :deleted
      assert_redirected_to users_url
      assert_equal 'User was successfully deleted.', flash[:notice]
    end

    test 'should not destroy other user if logged in as the regular user' do
      delete user_url(@user2)
      assert :deleted
      assert_redirected_to users_url
      assert_equal 'You must be logged in as this user to view this page.', flash[:alert]
    end
  end
end
