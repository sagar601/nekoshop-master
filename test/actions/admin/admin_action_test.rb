require 'user/admin'

module AdminActionTest
  extend Minitest::Spec::DSL

  it 'does not raise error for admins' do
    build_action(user: User::Admin.new).call
  end

  it 'raises error for regular users' do
    proc{ build_action(user: User.new).call }.must_raise AuthService::UnauthorizedActionError
  end

  it 'raises error for guests' do
    proc{ build_action(user: User::Guest.new).call }.must_raise AuthService::UnauthorizedActionError
  end

end