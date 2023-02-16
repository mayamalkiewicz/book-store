require 'test_helper'

class UsersBookTest < ActiveSupport::TestCase
  setup do
    @users_book = create(:users_book)
  end

  test 'should be valid' do
    assert @users_book.valid?
  end

  test 'user_id should be present' do
    @users_book.user_id = nil
    assert_not @users_book.valid?
  end

  test 'book should be present' do
    @users_book.book = nil
    assert_not @users_book.valid?
  end

  test 'should be unique' do
    duplicate_book = @users_book.dup
    @users_book.save
    assert_not duplicate_book.valid?
  end
end
