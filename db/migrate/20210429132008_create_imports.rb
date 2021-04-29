class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file
      t.integer :status

      t.timestamps
    end
  end
end
