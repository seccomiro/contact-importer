class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.date :birthdate
      t.string :phone
      t.string :address
      t.references :user, null: false, foreign_key: true
      t.references :credit_card, null: true, foreign_key: true

      t.timestamps
    end
  end
end
