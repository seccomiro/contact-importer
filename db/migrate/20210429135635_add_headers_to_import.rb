class AddHeadersToImport < ActiveRecord::Migration[6.1]
  def change
    add_column :imports, :headers, :jsonb
  end
end
