raise unless ENV['name'] && ENV['pass'] && ENV['mail']

user = [{
  name: ENV['name'],
  mail: ENV['mail'],
  fingerprint: Argon2::Password.create(ENV['pass']),
  token: nil
}]

User.create(user)

