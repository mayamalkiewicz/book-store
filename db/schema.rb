# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_228_102_021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'books', force: :cascade do |t|
    t.string 'title'
    t.date 'date_of_publication'
    t.integer 'pages'
    t.text 'description'
    t.boolean 'deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'comments', force: :cascade do |t|
    t.text 'content', null: false
    t.bigint 'book_id', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_comments_on_book_id'
    t.index %w[user_id book_id], name: 'index_comments_on_user_id_and_book_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.string 'nick_name'
    t.date 'date_of_birth'
    t.text 'description'
    t.boolean 'deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'role', default: 0
  end

  create_table 'users_books', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'book_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_users_books_on_book_id'
    t.index ['user_id'], name: 'index_users_books_on_user_id'
  end

  add_foreign_key 'comments', 'books'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'users_books', 'books'
  add_foreign_key 'users_books', 'users'
end
