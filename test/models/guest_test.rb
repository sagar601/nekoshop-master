require 'test_helper'

require_relative 'shared_user_behavior_test'

describe User::Guest do
  subject { User::Guest.new }
  include SharedUserBehaviorTest

  it 'is not registered' do
    User::Guest.new.registered?.must_equal false
  end

  it 'is a guest' do
    User::Guest.new.guest?.must_equal true
  end

  it 'is not an admin' do
    User::Guest.new.admin?.must_equal false
  end
end