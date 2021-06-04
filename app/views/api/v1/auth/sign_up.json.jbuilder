json.status :success
json.data do
  json.user @user, partial: 'api/v1/auth/user', as: :user
end
