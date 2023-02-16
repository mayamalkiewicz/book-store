class Book < ApplicationRecord
  scope :active, -> { where(deleted: false) }
  validates :title, presence: true,
                    length: { maximum: 100 }
  validates :date_of_publication, presence: true
  validates :pages, presence: true,
                    numericality: { greater_than_or_equal_to: 1 }
  validates :description, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  before_validation :set_default_deleted, on: :create

  has_many :users_books
  has_many :users, through: :users_books

  def destroy_with_usersbooks
    transaction do
      self.deleted = true
      users_books.destroy_all
      save!
    end
  end

  private

  def set_default_deleted
    self.deleted ||= false
  end
end
