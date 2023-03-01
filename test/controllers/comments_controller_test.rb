require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = create(:comment)
    @params = { content: @comment.content }
    @params_update = { content: 'Updated comment' }
    @comment2 = create(:comment)
    @book = @comment.book
    @book2 = create(:book)
    @user = @comment.user
    @headers = { referer: user_path(@user) }
  end

  class RequireAdminLogIn < CommentsControllerTest
    setup do
      @admin = create(:user, :admin)
      log_in(@admin)
    end

    test 'should destroy comment of regular user' do
      assert_difference('Comment.count', -1) do
        delete book_comment_path(@book, @comment)
      end
      assert_redirected_to book_path(@book)
      assert_equal 'Comment was successfully deleted.', flash[:notice]
    end

    test 'should get edit' do
      get edit_book_comment_path(@book, @comment)
      assert_response :success
    end

    test 'should update comment' do
      patch book_comment_url(@book, @comment), params: { comment: @params_update }
      assert_redirected_to book_path(@book)
      assert_equal 'Comment was successfully updated.', flash[:notice]
      @comment.reload
      assert_equal 'Updated comment', @comment.content
    end
  end

  class RequireUserLogIn < CommentsControllerTest
    setup do
      log_in(@user)
    end

    test 'should create comment for a book that the user has this book in own collection' do
      users_book = current_user.users_books.create(book: @book)
      @comment.destroy
      assert_difference('Comment.count') do
        post book_comments_url(@book), params: { comment: { content: 'This is a comment' } }
      end
      assert_redirected_to book_path(@book)
      assert_equal 'Comment was successfully created.', flash[:notice]
    end

    test 'should not create comment for a book that the user does not have this book own collection' do
      assert_no_difference('Comment.count') do
        post book_comments_url(@book2), params: { comment: { content: 'This is a comment' } }
      end
      assert_redirected_to book_path(@book2)
    end

    test 'should not create comment with no content' do
      @params[:content] = ''
      assert_no_difference('Comment.count') do
        post book_comments_url(@book), params: { comment: @params }
      end
      assert_redirected_to book_url(@book)
    end

    test 'should not create second comment to the same book' do
      @params[:content] = 'First comment'
      post book_comments_url(@book), params: { comment: @params }
      assert_no_difference('Comment.count') do
        @params[:content] = 'Second comment'
        post book_comments_url(@book), params: { comment: @params }
      end
      assert_redirected_to book_url(@book)
    end

    test 'should destroy comment being on book_path' do
      assert_difference('Comment.count', -1) do
        delete book_comment_path(@book, @comment)
      end
      assert_redirected_to book_path(@book)
      assert_equal 'Comment was successfully deleted.', flash[:notice]
    end

    test 'should destroy comment being on user_path' do
      get user_path(@user)
      assert_difference('Comment.count', -1) do
        delete book_comment_path(@book, @comment), headers: @headers
      end
      assert_redirected_to user_path(@user)
      assert_equal 'Comment was successfully deleted.', flash[:notice]
    end

    test 'should redirect correctly after destroy comment on book_path' do
      @headers[:referer] = book_path(@book)
      get book_path(@book)
      delete book_comment_path(@book, @comment), headers: @headers
      assert_redirected_to book_path(@book)
      assert_equal 'Comment was successfully deleted.', flash[:notice]
    end

    test 'should redirect correctly after destroy comment on user_path' do
      get user_path(@user)
      delete book_comment_path(@book, @comment), headers: @headers
      assert_redirected_to user_path(@user)
      assert_equal 'Comment was successfully deleted.', flash[:notice]
    end

    test 'should not destroy comment of other user' do
      assert_no_difference('Comment.count', -1) do
        delete book_comment_path(@comment2.book, @comment2)
      end
      assert_redirected_to book_path(@comment2.book)
      assert_equal 'You must be logged in as this user to do this action.', flash[:alert]
    end

    test 'should get edit' do
      get edit_book_comment_path(@book, @comment)
      assert_response :success
    end

    test 'should not get edit of other user comment' do
      get edit_book_comment_path(@comment2.book, @comment2)
      assert_redirected_to book_path(@comment2.book)
      assert_equal 'You must be logged in as this user to do this action.', flash[:alert]
    end

    test 'should update comment' do
      patch book_comment_url(@book, @comment), params: { comment: @params_update }
      assert_redirected_to book_path(@book), headers: @headers
      assert_equal 'Comment was successfully updated.', flash[:notice]
      @comment.reload
      assert_equal 'Updated comment', @comment.content
    end

    test 'should not update comment of other user' do
      patch book_comment_url(@comment2.book, @comment2), params: { comment: @params_update }
      assert_redirected_to book_path(@comment2.book)
      @comment.reload
      assert_redirected_to book_path(@comment2.book)
      assert_equal 'You must be logged in as this user to do this action.', flash[:alert]
    end
  end

  class NotLogIn < CommentsControllerTest
    test 'should not create comment as not logged in app visitor' do
      assert_no_difference('Comment.count') do
        post book_comments_path(@book2), params: { comment: { content: 'I am not logged in.' } }
      end
      assert_redirected_to sessions_login_path
      assert_equal 'You must be logged in to view this page.', flash[:alert]
    end
  end
end
