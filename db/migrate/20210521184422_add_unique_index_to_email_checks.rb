class AddUniqueIndexToEmailChecks < ActiveRecord::Migration[6.1]
  def change
    add_index :email_checks, [:email], unique: true
  end
end
