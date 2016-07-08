require 'test_helper'

require_relative 'shared_user_behavior_test'

describe User::Admin do
  subject { User::Admin.new }
  include SharedUserBehaviorTest

  it 'is registered' do
    User::Admin.new.registered?.must_equal true
  end

  it 'is not a guest' do
    User::Admin.new.guest?.must_equal false
  end

  it 'is an admin' do
    User::Admin.new.admin?.must_equal true
  end
end