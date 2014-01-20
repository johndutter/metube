json.array!(@users) do |user|
  json.extract! user, :id, :username, :salt, :password
  json.url user_url(user, format: :json)
end
