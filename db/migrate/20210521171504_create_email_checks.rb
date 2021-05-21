class CreateEmailChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :email_checks do |t|
      t.string :email
      t.integer :status

      t.timestamps
    end
  end
end
