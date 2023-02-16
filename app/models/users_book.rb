class UsersBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true
  validates :book_id, uniqueness: { scope: :user_id }
end
