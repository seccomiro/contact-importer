class CsvUploader < CarrierWave::Uploader::Base
  storage Rails.env.production? ? :fog : :file

  def store_dir
    "#{Rails.env.test? ? 'test_' : ''}uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
