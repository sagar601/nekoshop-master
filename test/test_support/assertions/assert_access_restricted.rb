module Minitest::Assertions

  def assert_access_restricted path, *allowed_user_types
    known_user_types = [ User, User::Admin, User::Guest ]
    unknown_user_types = allowed_user_types - known_user_types

    raise ArgumentError, "unrecogznied user type(s): #{unknown_user_types * ', '}" unless unknown_user_types.empty?

    allowed = known_user_types & allowed_user_types
    blocked = known_user_types - allowed_user_types

    blocked.each do |blocked_type|
      user = UserFactory.create! type: blocked_type

      logout :user
      login_as user, scope: :user

      proc{ visit path }.must_raise AuthService::UnauthorizedActionError
    end

    allowed.each do |allowed_type|
      user = UserFactory.create! type: allowed_type

      logout :user
      login_as user, scope: :user

      visit path
      current_path.must_equal path
    end
  end

end