class AddIndexToComments < ActiveRecord::Migration[7.0]
  def change
    add_index :comments, %i[user_id book_id]
  end
end
