class Components::Checkout::SimpleCostBreakdown

  def initialize checkout:
    @checkout = checkout
  end

  def subtotal
    @checkout.cart.total.format
  end

  def shipping_cost
    @checkout.shipping_cost.format
  end

  def total
    @checkout.total.format
  end

end