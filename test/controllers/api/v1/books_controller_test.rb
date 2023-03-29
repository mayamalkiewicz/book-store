require 'test_helper'

class Api::V1::BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @books = create_list(:book, 3) do |book, index|
      book.title = "Title #{index + 1}"
      book.date_of_publication = Time.current - (index + 1).months
      book.save
    end
    @books.push(create(:book, title: 'Book from future', date_of_publication: Time.current + 1.year))
  end

  test 'should get index' do
    get api_v1_books_url
    assert_response :success
    assert_equal Book.count, JSON.parse(response.body).size
  end

  test 'should get index with title sorting' do
    get api_v1_books_url(sort: 'title')
    assert_response :success

    books = JSON.parse(response.body)
    sorted_books = books.sort_by { |book| book['title'] }
    assert_equal sorted_books, books
  end

  test 'should return error when sort parameter is invalid' do
    get api_v1_books_url(sort: 'invalid_sort_parameter')
    assert_response :unprocessable_entity

    error_message = JSON.parse(response.body)
    error_message_string = error_message.map { |key, value| "#{key}: #{value}" }.join

    assert_equal 'error: Invalid sort parameter', error_message_string
  end

  test 'should get index with creation date sorting' do
    get api_v1_books_url(sort: 'created_at')
    assert_response :success

    books = JSON.parse(response.body)
    sorted_books = books.sort_by { |book| book['created_at'] }
    assert_equal sorted_books, books
  end

  test 'should get index with sorting by date of publication' do
    get api_v1_books_url(sort: 'date_of_publication')
    assert_response :success

    books = JSON.parse(response.body)
    sorted_books = books.sort_by { |book| book['date_of_publication'] }
    assert_equal sorted_books, books
  end

  test 'should get index with title filtering' do
    get api_v1_books_url(title: 'Title 1')
    assert_response :success

    books = JSON.parse(response.body)
    filtered_books = Book.where('title LIKE ?', 'Title 1')
    assert_equal filtered_books.count, books.size
    assert_equal 1, books.size
  end

  test 'should get index with title filtering when no books match the title' do
    get api_v1_books_url(title: 'wrong_title')
    assert_response :success

    books = JSON.parse(response.body)
    filtered_books = Book.where('title LIKE ?', 'wrong_title')
    assert_equal filtered_books.count, books.size
    assert_equal 0, books.size
  end

  test 'should get index with date_of_publication_since filtering' do
    date = Time.current
    get api_v1_books_url(date_of_publication_since: date)
    assert_response :success

    response_books = JSON.parse(response.body)
    filtered_books = Book.where('date_of_publication >= ?', date)
    assert_equal filtered_books.count, response_books.size
    assert_equal 1, response_books.size
    filtered_invalid_books = Book.where('date_of_publication <= ? ', date)
    assert_not_equal filtered_invalid_books.count, response_books.size
    assert_equal 3, filtered_invalid_books.count
  end

  test 'should pass when there is no books matching with filtering date_of_publication_since' do
    date = Time.now
    book_to_remove = @books.last
    book_to_remove.destroy
    assert_nil Book.find_by(id: book_to_remove.id)

    get api_v1_books_url(date_of_publication_since: date)
    assert_response :success

    response_books = JSON.parse(response.body)
    filtered_books = Book.where('date_of_publication >= ?', date)
    assert_equal 0, filtered_books.count
  end

  test 'should get index with date_of_publication_after filtering' do
    date = Time.current

    get api_v1_books_url(date_of_publication_after: date)
    assert_response :success

    response_books = JSON.parse(response.body)
    filtered_books = Book.where('date_of_publication >= ?', date)
    assert_equal filtered_books.count, response_books.size
    assert_equal 1, response_books.size
    filtered_invalid_books = Book.where('date_of_publication <= ? ', date)
    assert_not_equal filtered_invalid_books.count, response_books.size
    assert_equal 3, filtered_invalid_books.count
  end

  test 'should pass when there is no books matching with filtering date_of_publication_after' do
    date = Time.current
    book_to_remove = @books.last
    book_to_remove.destroy
    assert_nil Book.find_by(id: book_to_remove.id)

    get api_v1_books_url(date_of_publication_after: date)
    assert_response :success

    response_books = JSON.parse(response.body)
    filtered_books = Book.where('date_of_publication >= ?', date)
    assert_equal 0, filtered_books.size
  end

  test 'should show book' do
    book = @books.first
    get api_v1_book_url(book)
    assert_response :success

    assert_equal book.id, response.parsed_body['id']
  end

  test 'should show error in JSON if there is no book' do
    get api_v1_book_url(id: 0)
    assert_response :not_found

    error_message = JSON.parse(response.body)
    error_message_string = error_message.map { |key, value| "#{key}: #{value}" }.join

    assert_equal 'error: Not found.', error_message_string
  end
end
