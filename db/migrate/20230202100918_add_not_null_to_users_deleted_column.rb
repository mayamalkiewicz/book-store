class AddNotNullToUsersDeletedColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :deleted, :boolean, default: false, null: false
  end
end
