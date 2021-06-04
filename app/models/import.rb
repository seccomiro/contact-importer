class Import < ApplicationRecord
  belongs_to :user
  has_many :import_contacts, dependent: :destroy
  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }

  validates :file, presence: true

  default_scope -> { order(:created_at) }

  before_validation :ensure_status
  after_create_commit :ensure_headers, unless: :headers
  has_one_attached :file

  def headers_valid?
    ImportContact.importable_attributes.map(&:to_s).all? do |attribute|
      headers&.any? { |_, v| v == attribute }
    end
  end

  private

  def ensure_status
    self.status = :on_hold unless status
  end

  def ensure_headers
    importer = CsvImporter.new(self)
    self.headers = importer.fetch_headers
    save
  end
end
