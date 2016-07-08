class AuthService

  def authorize_admin user, action
    raise UnauthorizedActionError.new user, action unless user.admin?
  end

  def authorize_user user, action
    raise UnauthorizedActionError.new user, action if user.guest?
  end


  class UnauthorizedActionError < RuntimeError

    def initialize user, action
      @user_id = user.id
      @action = action
    end

    attr_reader :user_id, :action

  end

end
