FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 4) }
    book
    user
  end
end
