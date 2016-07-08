require 'test_helper'

describe CartItem do

  it 'has a quantity' do
    item = CartItem.new

    item.quantity = 10
    item.quantity.must_equal 10
  end

  it 'references a shopping cart' do
    cart = Cart.new
    item = CartItem.new

    item.cart = cart
    item.cart.must_equal cart
  end

  it 'references a virtual cat' do
    cat = VirtualCat.new
    item = CartItem.new

    item.virtual_cat = cat
    item.virtual_cat.must_equal cat
  end

  it 'takes its name from the virtual cat' do
    cat = Monkey.imitate VirtualCat.new, name: 'Spotty'

    CartItem.new(virtual_cat: cat).name.must_equal 'Spotty'
  end

  it 'takes its base price from the virtual cat' do
    cat = Monkey.imitate VirtualCat.new, base_price: Money.new(99)

    CartItem.new(virtual_cat: cat).base_price.must_equal Money.new(99)
  end

  it 'knows its unit price' do
    cat = Monkey.imitate VirtualCat.new, price: Money.new(50)
    item = CartItem.new virtual_cat: cat

    item.unit_price.must_equal Money.new(50)
  end

  it 'knows its subtotal' do
    cat = Monkey.imitate VirtualCat.new, price: Money.new(50)
    item = CartItem.new virtual_cat: cat, quantity: 3

    item.subtotal.must_equal Money.new(150)

    cat = Monkey.imitate VirtualCat.new, price: Money.new(0)
    item = CartItem.new virtual_cat: cat, quantity: 3

    item.subtotal.zero?.must_equal true
  end

  it 'knows if there is enough of it in stock' do
    cat = Monkey.imitate VirtualCat.new, price: Money.new(50)
    cat.stock = 4
    item = CartItem.new virtual_cat: cat, quantity: 5

    item.in_stock?.must_equal false

    cat.stock = 5
    item.in_stock?.must_equal true

    cat.stock = 10
    item.in_stock?.must_equal true

    # what if the cat was removed from store before cart checkout?
    item.virtual_cat = nil
    item.in_stock?.must_equal false
  end

  it 'knows the variation names of its virtual cat' do
    variations = [
      Monkey.imitate(Variation.new, name: 'lorem'),
      Monkey.imitate(Variation.new, name: 'ipsum')
    ]

    cat = Monkey.imitate VirtualCat.new, variations: variations
    item = CartItem.new virtual_cat: cat

    item.variations.must_contain %w(lorem ipsum)
  end

end