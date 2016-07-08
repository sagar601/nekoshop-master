class CartItemRepository

  def in_user_cart user, item_id
    user.customer.cart.items.find_by_id item_id
  end

end