require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = build(:user)
  end

  # valid user test
  test 'valid - valid user with valid attributes' do
    assert @user.valid?
  end

  # email validation tests

  test 'invalid - email is not present' do
    @user.email = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test 'invalid - wrong email format' do
    @user.email = 'john@invalid_format'
    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test 'invalid - wrong recipient name' do
    @user.email = 'jo@hn@invalid.com'
    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test 'invalid - duplicate email' do
    create(:user, email: 'user@example.com')
    user_2 = build(:user, email: 'user@example.com')
    refute user_2.valid?
    assert_not_nil user_2.errors[:email]
  end

  # password validation tests
  test 'invalid - without password' do
    @user.password = nil
    refute @user.valid?
    assert_not_nil @user.errors[:password]
  end

  test 'invalid - with short password' do
    @user.password = '1234'
    refute @user.valid?
    assert_not_nil @user.errors[:password]
  end

  test 'invalid - with long password' do
    @user.password = 'a' * 51
    refute @user.valid?
    assert_not_nil @user.errors[:password]
  end

  # date_of_birth validation tests
  test 'invalid - without date_of_birth' do
    @user.date_of_birth = nil
    refute @user.valid?
    assert_not_nil @user.errors[:date_of_birth]
  end

  test 'invalid - with date_of_birth in the future' do
    @user.date_of_birth = Date.tomorrow
    refute @user.valid?
    assert_not_nil @user.errors[:date_of_birth]
  end

  test 'invalid - with date_of_birth more than 100 years ago' do
    @user.date_of_birth = 101.years.ago
    refute @user.valid?
    assert_not_nil @user.errors[:date_of_birth]
  end

  # nick_name validation tests
  test 'invalid - without nick_name' do
    @user.nick_name = nil
    refute @user.valid?
    assert_not_nil @user.errors[:nick_name]
  end

  test 'invalid - with short nick_name' do
    @user.nick_name = 'a'
    refute @user.valid?
    assert_not_nil @user.errors[:nick_name]
  end

  test 'invalid - with long nickname' do
    @user.nick_name = 'a' * 101
    refute @user.valid?
    assert_not_nil @user.errors[:nick_name]
  end

  # description validation tests
  test 'invalid - with long description' do
    @user.description = 'a' * 1001
    refute @user.valid?
    assert_not_nil @user.errors[:description]
  end

  test 'invalid - too short description' do
    @user.description = 'a' * 1 || 'a' * 2
    refute @user.valid?
    assert_not_nil @user.errors[:description]
  end

  # deleted validation tests
  test 'invalid - with deleted equal to nill' do
    @user.deleted = nil
    refute !@user.deleted.nil?
  end
end