class ImportContact < ApplicationRecord
  belongs_to :import

  def self.importable_attributes
    [:name, :email, :birthdate, :phone, :address, :credit_card_number]
  end
end
