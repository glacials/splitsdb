json.array!(@users) do |user|
  json.extract! user, :email, :handle, :password
  json.url user_url(user, format: :json)
end
