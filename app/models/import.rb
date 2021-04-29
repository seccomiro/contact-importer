class Import < ApplicationRecord
  belongs_to :user
  mount_uploader :file, CsvUploader
end
