require 'test_helper'

require_relative 'user_factory'

describe UserFactory do

  it 'creates a User by default' do
    user = UserFactory.create!

    user.must_be_instance_of User
    User.first.must_equal user
  end

  it 'can be told which class of user to create' do
    user = UserFactory.create! type: User::Guest

    user.must_be_instance_of User::Guest
    User.first.must_equal user
  end

  it 'has a method for creating Guests' do
    user = UserFactory.create_guest!

    user.must_be_instance_of User::Guest
    User.first.must_equal user
  end

  it 'has a method for creating Guests' do
    user = UserFactory.create_admin!

    user.must_be_instance_of User::Admin
    User.first.must_equal user
  end

  it 'does cleanup' do
    User.count.must_equal 0
    UserFactory.create!
    UserFactory.create!
    User.count.must_equal 2
    UserFactory.cleanup!
    User.count.must_equal 0
  end

end