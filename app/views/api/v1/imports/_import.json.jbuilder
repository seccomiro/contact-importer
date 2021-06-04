json.extract! import, :id
json.file_name url_for(import.file).split('/').last
json.file_url polymorphic_url(import.file)
json.status import.status.to_s.humanize
