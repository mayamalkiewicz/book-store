class BooksController < ApplicationController
  include SessionsHelper
  before_action :login_required
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books
  def index
    @books = Book.all
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to book_url(Book.last), notice: 'Book was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      redirect_to book_url(@book), notice: 'Book was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.update(deleted: true)
    redirect_to books_url, notice: 'Book was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :date_of_publication, :pages, :description, :deleted)
  end
end
