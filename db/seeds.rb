# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

UsersBook.delete_all
Comment.delete_all

User.delete_all

FactoryBot.create(:user, :admin)

25.times do
  FactoryBot.create(:user)
end

Book.delete_all

25.times do
  book = FactoryBot.create(:book)
  User.all.each do |user|
    FactoryBot.create(:users_book, user:, book:)
    FactoryBot.create(:comment, book:, user:)
  end
end
