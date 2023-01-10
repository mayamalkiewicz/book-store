# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(email: 'user1@example.com', password: 'password', nick_name: 'User 1', date_of_birth: '1990-01-01', description: 'User 1 description', deleted: 'false')
User.create(email: 'user2@example.com', password: 'password', nick_name: 'User 2', date_of_birth: '1991-01-01', description: 'User 2 description', deleted: 'false')
User.create(email: 'user3@example.com', password: 'password', nick_name: 'User 3', date_of_birth: '1992-01-01', description: 'User 3 description', deleted: 'false')