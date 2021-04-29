class Import < ApplicationRecord
  belongs_to :user
  has_many :import_contacts, dependent: :destroy
  enum status: [:on_hold, :processing, :failed, :finished]
  mount_uploader :file, CsvUploader

  default_scope -> { order(:created_at) }

  before_validation :ensure_status

  def ensure_status
    self.status = :on_hold unless status
  end
end
