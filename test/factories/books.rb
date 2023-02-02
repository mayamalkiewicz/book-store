FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    date_of_publication { Faker::Date.backward(days: 10_000) }
    pages { Faker::Number.between(from: 4, to: 1000) }
    description { Faker::Book.genre }
    deleted { false }
  end
end
