require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:book)
    @params = { date_of_publication: @book.date_of_publication + 1.year,
                deleted: true,
                description: 'Book description',
                pages: 123,
                title: 'The book' }
  end

  class RequireAdminLogIn < BooksControllerTest
    setup do
      @admin = create(:user, :admin)
      log_in(@admin)
    end

    test 'should get index if logged in as admin' do
      get books_url
      assert_response :success
    end

    test 'should get new if logged in as admin' do
      get new_book_url
      assert_response :success
    end

    test 'should create book if logged in as admin' do
      @params[:deleted] = false
      assert_difference('Book.count') do
        post books_url,
             params: { book: @params }
      end
      assert_redirected_to book_url(Book.last)
    end

    test 'should show book if logged in as admin' do
      get book_url(@book)
      assert_response :success
    end

    test 'should get edit if logged in as admin' do
      get edit_book_url(@book)
      assert_response :success
    end

    test 'should update book if logged in as admin' do
      patch book_url(@book),
            params: { book: @params }
      assert_redirected_to book_url(@book)
      @book.reload
      assert_attributes(@book, @params)
    end

    test 'should destroy users_book relation if delete book - logged in as admin' do
      users_book = create(:users_book)
      book = users_book.book
      assert_difference('UsersBook.count', -1) do
        delete book_path(book)
      end
      assert :deleted
      assert_redirected_to books_url
      assert_not_nil Book.where(deleted: true).find(book.id)
      assert_nil UsersBook.find_by(id: users_book.id)
    end

    test 'should create book with valid image' do
      @params[:deleted] = false
      @params[:image] = fixture_file_upload('test.jpeg', 'image/jpeg')

      post books_url, params: { book: @params }

      new_book = Book.last
      image_data = JSON.parse(new_book.image_data)
      image_filename = image_data.dig('metadata', 'filename')

      assert_not_nil new_book.image_data
      assert_equal image_filename, 'test.jpeg'
    end

    test 'should not create book with invalid file format' do
      @params[:deleted] = false
      @params[:image] = fixture_file_upload('test.txt', 'text/txt')

      post books_url, params: { book: @params }

      assert_response :unprocessable_entity
    end
  end

  class RequireUserLogIn < BooksControllerTest
    setup do
      @user = create(:user, :regular)
      log_in(@user)
    end

    test 'should get index as regular user' do
      get books_url
      assert_response :success
    end

    test 'should not get new as regular user' do
      get new_book_url
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:notice]
    end

    test 'should not create book as a regular user' do
      assert_no_difference('Book.count') do
        post books_url,
             params: { book: @params }
      end
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:notice]
    end

    test 'should show book if logged in as a regular user' do
      get book_url(@book)
      assert_response :success
    end

    test 'should not get edit if logged in as regular user' do
      get edit_book_url(@book)
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:notice]
    end

    test 'should not update book if logged in as regular user' do
      patch book_url(@book),
            params: { book: @params }
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:notice]
    end
  end
end
