class ImportContact < ApplicationRecord
  belongs_to :import

  scope :with_error, -> { where.not(error_message: nil) }

  def self.importable_attributes
    [:name, :email, :birthdate, :phone, :address, :credit_card_number]
  end
end
