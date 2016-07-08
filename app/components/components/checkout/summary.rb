class Components::Checkout::Summary

  def initialize checkout:, wrapped: true, show_items: true
    @checkout = checkout
    @wrapped = wrapped
    @show_items = show_items
  end

  def wrapper_classes
    @wrapped ? 'ui secondary segment' : ''
  end

  def number_of_items
    @checkout.cart.count
  end

  def show_shipping_cost?
    @checkout.shipping_cost_determinable?
  end

  def shipping_cost
    @checkout.shipping_cost.format
  end

  def total
    @checkout.total.format
  end

  def items
    @checkout.cart.items
  end

  def show_items?
    @show_items
  end

end