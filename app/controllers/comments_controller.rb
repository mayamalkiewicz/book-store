class CommentsController < ApplicationController
  before_action :find_comment, only: %i[edit update destroy]
  before_action :login_required
  before_action :require_admin_or_account_owner, only: %i[edit update destroy]

  # POST /books/:book_id/comments
  def create
    # create a new comment for the book by the current_user
    @comment = current_user.comments.new(comment_params)
    if current_user.books.include?(@comment.book) && @comment.save
      redirect_to book_path(params[:book_id]), notice: 'Comment was successfully created.'
    else
      redirect_to book_path(params[:book_id]), alert: @comment.errors.full_messages.join(' ')
    end
  end

  # GET /books/:book_id/comments/:id/edit
  def edit
    @book = Book.find(params[:book_id])
  end

  # PATCH/PUT /books/:book_id/comments/:id
  def update
    flash[:notice] = 'Error, comment was not updated!' unless @comment.update(comment_params)
    redirect_to book_path(params[:book_id]), notice: 'Comment was successfully updated.'
  end

  # DELETE /books/:book_id/comments/:id
  def destroy
    flash[:notice] = 'Error, comment was not deleted!' unless @comment.destroy
    redirect_back_or_to book_path(params[:book_id]), notice: 'Comment was successfully deleted.'
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(book_id: params[:book_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  # Checks if the logged in user is the owner or admin to edit/update/delete comments.
  def require_admin_or_account_owner
    return if (current_user.id == @comment.user.id) || current_user.admin?

    flash[:alert] = 'You must be logged in as this user to do this action.'
    redirect_to book_path(params[:book_id])
  end
end
