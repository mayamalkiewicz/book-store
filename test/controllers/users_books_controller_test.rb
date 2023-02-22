# frozen_string_literal: true

require 'test_helper'

class UsersBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @users_book = create(:users_book)
    @user = @users_book.user
    @book = @users_book.book
    log_in(@user)
  end

  test 'should create users_book relation' do
    @book = create(:book)
    assert_difference('UsersBook.count') do
      post users_books_path, params: { book_id: @book.id }
    end
    assert_equal 'Book was successfully added to the library.', flash[:notice]
  end

  test 'should not create users_book relation if not logged in' do
    delete sessions_path
    assert_not logged_in?
    post users_books_path, params: { book_id: @book.id }
    assert_redirected_to sessions_login_path
  end

  test 'should destroy users_book relation' do
    assert_difference 'UsersBook.count', -1 do
      delete users_books_path(id: @users_book.id)
    end
    assert :deleted
    assert_nil UsersBook.find_by(id: @users_book.id)
  end
end
