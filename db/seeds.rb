# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = [{ name: 'alice', mail: 'alice@example.net', fingerprint: 'xxx', token: 'xxx' },
         { name: 'bridget', mail: 'bridget@example.net', fingerprint: 'xxx', token: 'yyy' },
         { name: 'ceris', mail: 'ceris@example.net', fingerprint: 'xxx', token: 'zzz' }]
users.each do |user|
  User.create(user)
end
