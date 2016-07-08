class Checkout::Payments::Edit

  def initialize user:, checkout_repo: CheckoutRepository.new
    @user = user
    @repo = checkout_repo
  end

  def call
    ActionResult.new checkout: checkout
  end

  private

  def checkout
    @checkout ||= @repo.of_customer(@user.customer) or raise Checkout::CheckoutExpiredError
  end

end