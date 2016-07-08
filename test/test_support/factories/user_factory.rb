class UserFactory

  def self.create_admin!
    create! type: User::Admin
  end

  def self.create_guest!
    create! type: User::Guest
  end

  def self.create! type: User
    type.create! name: Faker::Name.name, email: Faker::Internet.email, password: 'password'
  end

  def self.cleanup!
    User.all.each &:destroy!
  end

end