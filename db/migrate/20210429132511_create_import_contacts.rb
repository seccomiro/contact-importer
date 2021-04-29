class CreateImportContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :import_contacts do |t|
      t.references :import, null: false, foreign_key: true
      t.string :error_message
      t.string :name
      t.string :email
      t.date :birthdate
      t.string :phone
      t.string :address
      t.string :credit_card_number

      t.timestamps
    end
  end
end
