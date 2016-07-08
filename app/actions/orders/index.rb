class Orders::Index

  def initialize user:, params:, order_repo: OrderRepository.new, auth: AuthService.new
    @user = user
    @params = params
    @repo = order_repo
    @auth = auth
  end

  def call
    @auth.authorize_user @user, self.class

    ActionResult.new orders: orders
  end

  private

  def orders
    @repo.most_recent_of_customer @user.customer
  end

  def page
    @params['page'] || 1
  end

end