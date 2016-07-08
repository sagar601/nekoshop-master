require 'test_helper'

describe Components::Checkout::StartCheckoutButton do

  it 'is enabled if there any items in cart' do
    cart = Monkey.new Cart, is_empty?: false
    button = Components::Checkout::StartCheckoutButton.new cart: cart

    button.disabled?.must_equal false
  end

  it 'is disabled if cart is empty' do
    cart = Monkey.new Cart, is_empty?: true
    button = Components::Checkout::StartCheckoutButton.new cart: cart

    button.disabled?.must_equal true
  end

end