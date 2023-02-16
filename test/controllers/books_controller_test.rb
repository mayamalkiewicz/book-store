require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:book)
    @user = create(:user)
    log_in_user
  end

  test 'should get index' do
    get books_url
    assert_response :success
  end

  test 'should get new' do
    get new_book_url
    assert_response :success
  end

  test 'should create book' do
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
    get book_url(@book)
    assert_response :success
  end

  test 'should get edit' do
    get edit_book_url(@book)
    assert_response :success
  end

  test 'should update book' do
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

  test 'should destroy users_book relation if delete book' do
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
end
