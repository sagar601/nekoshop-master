class Components::Checkout::StartCheckoutButton

  def initialize cart:
    @cart = cart
  end

  def disabled?
    @cart.is_empty?
  end

end