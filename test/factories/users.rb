FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  factory :user do
    email
    nick_name { Faker::Internet.username }
    password { Faker::Internet.password(min_length: 5, max_length: 49, mix_case: true,
      special_characters: true) + '1' }
    password_confirmation { password}
    date_of_birth { Faker::Date.between(from: 100.years.ago, to: Date.today) }
    description { Faker::Movies::HarryPotter.quote }
    deleted { false }
  end
end
