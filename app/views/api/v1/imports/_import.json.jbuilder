json.extract! import, :id
json.file_name url_for(import.file).split('/').last
json.file_url polymorphic_url(import.file)
json.status import.status.to_s.humanize
json.headers import.headers
if (import.finished? || import.failed?) && import.import_contacts.with_error.any? && defined?(show_errors) && show_errors
  json.contacts_with_errors import.import_contacts.with_error, partial: 'api/v1/imports/import_contact', as: :import_contact
end
