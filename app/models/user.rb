class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid format' }
  validates :password, presence: true,
                       format: { with: /\A(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])/x,
                                 message: 'must be present and contain number, small letter and big letter' },
                       length: { minimum: 5, maximum: 50 }
  validates_confirmation_of :password, if: :password_changed?, on: %i[create update]
  validates_presence_of :password_confirmation, if: :password_changed?
  validates :date_of_birth, presence: true
  validate :date_of_birth_cannot_be_in_the_future
  validate :date_of_birth_cannot_be_more_than_100_years_ago
  validates :nick_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { minimum: 2, maximum: 1000,
                                    too_long: '%<count>s characters is the maximum allowed' },
                          allow_blank: true

  validates :deleted, inclusion: { in: [true, false] }
  before_validation :set_default_deleted, on: :create

  private

  # soft delete
  default_scope { where(deleted: false) }

  def date_of_birth_cannot_be_in_the_future
    return unless date_of_birth.present? && date_of_birth > Date.today

    errors.add(:date_of_birth, "can't be in the future")
  end

  def date_of_birth_cannot_be_more_than_100_years_ago
    return unless date_of_birth.present? && date_of_birth < 100.years.ago

    errors.add(:date_of_birth,
               'can not be more than 100 years ago')
  end

  def set_default_deleted
    self.deleted ||= false
  end
end