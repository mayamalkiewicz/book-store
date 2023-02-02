require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:book)
    @user = create(:user)
  end

  test 'should get index' do
    log_in_user
    get books_url
    assert_response :success
  end

  test 'should get new' do
    log_in_user
    get new_book_url
    assert_response :success
  end

  test 'should create book' do
    log_in_user
    assert_difference('Book.count') do
      post books_url,
           params: { book: { date_of_publication: @book.date_of_publication,
                             deleted: false,
                             description: @book.description,
                             pages: @book.pages,
                             title: @book.title } }
    end
    assert_redirected_to book_url(Book.last)
  end

  test 'should show book' do
    log_in_user
    get book_url(@book)
    assert_response :success
  end

  test 'should get edit' do
    log_in_user
    get edit_book_url(@book)
    assert_response :success
  end

  test 'should update book' do
    log_in_user
    patch book_url(@book),
          params: { book: { date_of_publication: @book.date_of_publication, deleted: @book.deleted,
                            description: @book.description, pages: @book.pages, title: @book.title } }
    assert_redirected_to book_url(@book)
    @book.reload
    assert_equal @book.date_of_publication, @book.date_of_publication
    assert_equal @book.deleted, @book.deleted
    assert_equal @book.description, @book.description
    assert_equal @book.pages, @book.pages
    assert_equal @book.title, @book.title
  end

  test 'should destroy book' do
    log_in_user
    delete book_url(@book)
    assert :deleted
    assert_redirected_to books_url
    assert_equal 'Book was successfully deleted.', flash[:notice]
  end
end
