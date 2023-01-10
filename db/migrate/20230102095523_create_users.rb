# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :nick_name
      t.date :date_of_birth
      t.text :description
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
