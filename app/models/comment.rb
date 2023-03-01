class Comment < ApplicationRecord
  validates :user_id, uniqueness: { scope: :book_id, message: "You've already made a comment!" }
  validates :content, presence: { message: 'Content of comment can not be empty!' }

  belongs_to :book
  belongs_to :user

  validates :user_id, presence: true
  validates :book_id, presence: true
end
