class Book < ApplicationRecord
  # soft delete
  default_scope { where(deleted: false) }
  validates :title, presence: true,
                    length: { maximum: 100 }
  validates :date_of_publication, presence: true
  validates :pages, presence: true,
                    numericality: { greater_than_or_equal_to: 1 }
  validates :description, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  before_validation :set_default_deleted, on: :create

  private

  def set_default_deleted
    self.deleted ||= false
  end
end
