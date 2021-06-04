class ImportContact < ApplicationRecord
  belongs_to :import

  scope :with_error, -> { where.not(error_message: nil) }
  scope :without_error, -> { where(error_message: nil) }

  def self.importable_attributes
    [:name, :email, :birthdate, :phone, :address, :credit_card_number]
  end

  def valid_birthdate?
    valid_formats = ['%F', '%Y%m%d']
    valid_formats.any? do |f|
      DateTime.strptime(birthdate, f)
    rescue StandardError
      false
    end
  end

  def error_hash
    JSON.parse(error_message)
  rescue JSON::ParserError
    []
  end
end
