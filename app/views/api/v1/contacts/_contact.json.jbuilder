json.extract! contact, :id, :name, :email, :phone, :address
json.credit_card do
  json.partial! contact.credit_card
end
