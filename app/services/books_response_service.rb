class BooksResponseService < ApplicationService
  class InvalidSortingParameterError < StandardError; end
  include BooksResponseServicesHelper

  def initialize(params)
    @params = params
  end

  def call
    @books = Book.includes(:users_books, comments: :user)
    filter_books
    sort_books
    @books.map { |book| book_as_json(book) }
  end

  private

  def filter_books
    conditions = []
    values = []

    if @params[:title].present?
      conditions << 'title LIKE ?'
      values << "%#{@params[:title]}%"
    end

    if @params[:date_of_publication_since].present?
      conditions << 'date_of_publication >= ?'
      values << @params[:date_of_publication_since]
    end

    if @params[:date_of_publication_after].present?
      conditions << 'date_of_publication >= ?'
      values << @params[:date_of_publication_after]
    end

    return if conditions.empty?

    @books = @books.where(conditions.join(' AND '), *values)
  end

  def sort_books
    return unless @params[:sort].present?

    case @params[:sort]
    when 'title'
      @books = @books.order(title: :asc)
    when 'created_at'
      @books = @books.order(created_at: :asc)
    when 'date_of_publication'
      @books = @books.order(date_of_publication: :asc)
    else
      raise InvalidSortingParameterError, 'Invalid sort parameter'
    end
  end
end
