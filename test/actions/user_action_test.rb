module UserActionTest
  extend Minitest::Spec::DSL

  it 'does not raise error for admins' do
    build_action(user: User::Admin.new).call
  end

  it 'does not raise error for regular users' do
    build_action(user: User.new).call
  end

  it 'raises error for guests' do
    proc{ build_action(user: User::Guest.new).call }.must_raise AuthService::UnauthorizedActionError
  end

end