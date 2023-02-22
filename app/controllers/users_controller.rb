# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :login_required, only: %i[show update edit destroy]
  before_action :require_admin_or_account_owner, only: %i[edit update destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id
  def show
    @books = @user.books.includes(:users_books).where(users_books: { user_id: @user.id })
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to logged_in? ? user_url(User.last) : sessions_login_path, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      redirect_to user_url(@user), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.update(deleted: true)
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nick_name, :date_of_birth, :description,
                                 :deleted)
  end

  # Checks if the logged in user is the owner or admin to edit/update/delete profile.
  def require_admin_or_account_owner
    return if current_user.id == @user.id || current_user.admin?

    flash[:alert] = 'You must be logged in as this user to view this page.'
    redirect_to users_url
  end
end
