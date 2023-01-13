# frozen_string_literal: true

require 'test_helper'
require 'faker'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url,
           params: { user: { date_of_birth: @user.date_of_birth, deleted: 'false', description: 'A new user',
                             email: Faker::Internet.email, nick_name: 'john', password: 'johN123', password_confirmation: 'johN123' } }
    end
    assert_redirected_to user_path(User.last)
  end

  test 'should not create user' do
    assert_no_difference('User.count') do
      post users_url,
           params: { user: { date_of_birth: '2000-12-12', deleted: 'false', description: 'A new user',
                             email: 'john@mail.com', nick_name: 'John1', password: 'john123', password_confirmation: 'asdd' } }
    end
    assert_response :unprocessable_entity
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user),
          params: { user: { date_of_birth: @user.date_of_birth, deleted: @user.deleted, description: @user.description,
                            email: @user.email, nick_name: @user.nick_name, password: @user.password } }
    assert_redirected_to user_url(@user)
    @user.reload
    assert_equal @user.date_of_birth, @user.date_of_birth
    assert_equal @user.deleted, @user.deleted
    assert_equal @user.description, @user.description
    assert_equal @user.email, @user.email
    assert_equal @user.nick_name, @user.nick_name
    assert_equal @user.password, @user.password
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
