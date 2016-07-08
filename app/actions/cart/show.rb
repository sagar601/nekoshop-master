class Cart::Show

  def initialize user:, cart_repo: CartRepository.new, checkout_repo: CheckoutRepository.new
    @user = user
    @cart_repo = cart_repo
    @checkout_repo = checkout_repo
  end

  def call
    ActionResult.new cart: cart, checkout: checkout
  end

  private

  def cart
    @cart ||= @cart_repo.of_customer @user.customer
  end

  def checkout
    @checkout ||= (@checkout_repo.of_customer(@user.customer) || Checkout.new(cart: cart))
  end

end