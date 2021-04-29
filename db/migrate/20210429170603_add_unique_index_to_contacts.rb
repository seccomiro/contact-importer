class AddUniqueIndexToContacts < ActiveRecord::Migration[6.1]
  def change
    add_index :contacts, [:user_id, :email], unique: true
  end
end
