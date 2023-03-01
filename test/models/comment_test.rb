require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = build(:comment)
  end

  test 'should save comment with user_id, book_id and content' do
    comment = Comment.new(user: create(:user), book: create(:book), content: 'Test comment')
    assert comment.save, 'Could not save the comment'
  end

  test 'should not save comment without user_id and book_id' do
    assert_not @comment.save, 'Saved the comment without user_id and book_id'
  end

  test 'should not save comment without content' do
    @comment.content = ''
    assert_not @comment.save, 'Saved the comment without content'
    assert_not @comment.valid?
  end

  test 'should not be valid without a user' do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test 'should not be valid without a book' do
    @comment.book = nil
    assert_not @comment.valid?
  end

  test 'should not save comment if user has already commented on the book' do
    @comment.save

    second_comment = Comment.new(user: @comment.user, book: @comment.book, content: 'Some other content')
    assert_not second_comment.save
  end
end
