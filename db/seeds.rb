# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#mock user data created for testing purposes
user_data = [
  {username: 'Jassiem', salt: '1234', password: 'secret'},
  {username: 'John', salt: '1235', password: 'secret2'},
  {username: 'Jack', salt: '1236', password: 'secret3'}
]

user_data.each do |user|
  User.create(username: user[:username], salt: user[:salt], password: user[:password], created_at: Time.now, updated_at: Time.now)
end
