class UsersBooksController < ApplicationController
  before_action :login_required

  # POST /users_books
  def create
    book = Book.find(params[:book_id])
    users_book = current_user.users_books.build(book:)

    if users_book.save
      redirect_to book_path(book), notice: 'Book was successfully added to the library.'
    else
      redirect_to book_path(book), alert: 'Failed to add book to the library.'
    end
  end

  # DELETE /users_books
  def destroy
    users_book = UsersBook.find(params[:id])
    if users_book.destroy && UsersBook.where(id: params[:id]).empty?
      redirect_to user_url(users_book.user_id), notice: 'Book was successfully removed from the library.'
    else
      redirect_to user_url(users_book.user_id), alert: 'Failed to remove book from the library.'
    end
  end
end
