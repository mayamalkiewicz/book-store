class User < ApplicationRecord
  enum role: { regular: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid format' }
  has_secure_password
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])/x,
                                 message: 'must be present and contain number, small letter and big letter' },
                       length: { minimum: 5, maximum: 50 },
                       on: :create
  validates :password_confirmation, presence: true,
                                    on: :create
  validates :date_of_birth, presence: true
  validate :date_of_birth_cannot_be_in_the_future
  validate :date_of_birth_cannot_be_more_than_100_years_ago
  validates :nick_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { minimum: 2, maximum: 1000,
                                    too_long: '%<count>s characters is the maximum allowed' },
                          allow_blank: true

  has_many :users_books
  has_many :books, through: :users_books
  has_many :comments

  private

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
end
