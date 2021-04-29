class CreateCreditCards < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.string :franchise
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end