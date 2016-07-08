require 'test_helper'

describe ::Components::Site::MenuBar::CartCounter do

  it 'has a cart' do
    cart = Object.new
    component = ::Components::Site::MenuBar::CartCounter.new cart: cart

    component.cart.must_equal cart
  end
end