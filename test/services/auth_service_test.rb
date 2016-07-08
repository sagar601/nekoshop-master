require 'test_helper'

describe AuthService do

  let(:user) { User.new id: 123 }
  let(:admin) { User::Admin.new id: 456 }
  let(:guest) { User::Guest.new id: 789 }
  let(:action) { Object.new }
  let(:service) { AuthService.new }

  def assert_proper_error error, expected_user, expected_action
    error.user_id.must_equal expected_user.id
    error.action.must_equal expected_action
  end

  specify '#authorize_admin raises an error if the user is not an admin' do
    errors = []

    begin
      service.authorize_admin user, action
    rescue AuthService::UnauthorizedActionError => e
      errors << e
      assert_proper_error e, user, action
    end

    begin
      service.authorize_admin guest, action
    rescue AuthService::UnauthorizedActionError => e
      errors << e
      assert_proper_error e, guest, action
    end

    service.authorize_admin admin, action

    errors.count.must_equal 2
  end

  specify '#authorize_user raises an error if the user is not an admin or user' do
    errors = []

    begin
      service.authorize_user guest, action
    rescue AuthService::UnauthorizedActionError => e
      errors << e
      assert_proper_error e, guest, action
    end

    service.authorize_user user, action
    service.authorize_user admin, action

    errors.count.must_equal 1
  end

end