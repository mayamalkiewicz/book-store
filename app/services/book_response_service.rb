class BookResponseService < ApplicationService
  include BooksResponseServicesHelper

  def initialize(params)
    @book = Book.includes(:users_books, comments: :user).find(params[:id])
  end

  def call
    book_as_json(@book)
  end
end
