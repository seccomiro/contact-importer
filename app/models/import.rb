class Import < ApplicationRecord
  belongs_to :user
  has_many :import_contacts, dependent: :destroy
  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }
  has_one_attached :file

  validates :file, presence: true

  default_scope -> { order(:created_at) }

  before_validation :ensure_status

  def headers_filled?
    headers&.all? { |_, v| v.present? } || false
  end

  private

  def ensure_status
    self.status = :on_hold unless status
  end
end
