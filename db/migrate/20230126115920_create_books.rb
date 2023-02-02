class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.date :date_of_publication
      t.integer :pages
      t.text :description
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
