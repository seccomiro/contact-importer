class ImportContact < ApplicationRecord
  belongs_to :import

  scope :with_error, -> { where.not(error_message: nil) }
  scope :without_error, -> { where(error_message: nil) }

  def self.importable_attributes
    [:name, :email, :birthdate, :phone, :address, :credit_card_number]
  end

  def valid_birthdate?
    valid_formats = ['%F', '%Y%m%d']
    valid_formats.any? { |f| DateTime.strptime(birthdate, f) rescue false }
  end
end
