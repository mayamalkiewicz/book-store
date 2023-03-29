class Api::V1::BooksController < ApplicationController
  # GET /api/v1/books
  def index
    render json: BooksResponseService.call(index_params)
  rescue BooksResponseService::InvalidSortingParameterError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
    render json: BookResponseService.call(params)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Not found.' }, status: :not_found
  end

  private

  def index_params
    params.permit(:title, :date_of_publication_after, :date_of_publication_since,
                  :date_of_publication, :created_at, :sort)
  end
end
