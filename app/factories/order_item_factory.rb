class OrderItemFactory
  using Augmented::Objects

  def from_cart_items cart_items
    cart_items.map do |item|
      OrderItem.new item.pick *%i(name variations quantity base_price options_cost virtual_cat_id)
    end
  end

end