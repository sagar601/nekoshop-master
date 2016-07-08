require 'test_helper'

describe Cart do

  it 'references a customer' do
    customer = Customer.new
    cart = Cart.new

    cart.customer = customer
    cart.customer.must_equal customer
  end

  it 'has items' do
    items = [CartItem.new]
    cart = Cart.new

    cart.items = items
    cart.items.must_equal items
  end

  it 'knows how many items are in cart' do
    cart = Cart.new items: [CartItem.new(quantity: 1), CartItem.new(quantity: 5)]
    cart.count.must_equal 6
  end

  it 'knows if it has any items' do
    cart = Cart.new

    cart.is_empty?.must_equal true

    cart.items = [CartItem.new(quantity: 1)]

    cart.is_empty?.must_equal false
  end

  it 'knows if all its item are in stock' do
    item1 = Monkey.imitate CartItem.new, in_stock?: true
    item2 = Monkey.imitate CartItem.new, in_stock?: true
    cart = Cart.new items: [item1, item2]

    cart.in_stock?.must_equal true

    cart.items << Monkey.imitate(CartItem.new, in_stock?: false)

    cart.in_stock?.must_equal false
  end

  it 'knows how much money it costs in total' do
    item1 = Monkey.imitate CartItem.new, subtotal: Money.new(99)
    item2 = Monkey.imitate CartItem.new, subtotal: Money.new(101)
    cart = Cart.new items: [item1, item2]

    cart.total.must_equal Money.new(200)
  end

end