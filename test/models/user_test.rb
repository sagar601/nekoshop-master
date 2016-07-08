require 'test_helper'

require_relative 'shared_user_behavior_test'

describe User do
  subject { User.new }
  include SharedUserBehaviorTest

  it 'is registered' do
    User.new.registered?.must_equal true
  end

  it 'is not a guest' do
    User.new.guest?.must_equal false
  end

  it 'is not an admin' do
    User.new.admin?.must_equal false
  end
end