require 'test_helper'

class BookTest < ActiveSupport::TestCase
  setup do
    @book = build(:book)
  end

  test 'valid - valid book parameters' do
    assert @book.valid?
  end

  test 'title not present' do
    @book.title = nil
    assert_not @book.valid?
    assert_not_nil @book.errors[:title]
  end

  test 'title should not be longer than 100 characters' do
    book = Book.new(title: 'a' * 101)
    assert_not book.valid?
  end

  test 'should not save book without date of publication' do
    book = Book.new
    assert_not book.save
  end

  test 'should not save book with pages less than 1' do
    book = Book.new(pages: 0)
    assert_not book.valid?
  end

  test 'should not save book without description' do
    book = Book.new
    assert_not book.save
  end

  test 'should not save book with deleted attribute set to true' do
    book = Book.new(deleted: true)
    assert_not book.valid?
  end
end
