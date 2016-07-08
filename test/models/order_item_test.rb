require 'test_helper'

describe OrderItem do

  let(:item) { OrderItem.new }

  it 'has an order' do
    order = Order.new

    item.order = order
    item.order.must_equal order
  end

  it 'has a name' do
    item.name = 'lorem ipsum'
    item.name.must_equal 'lorem ipsum'
  end

  it 'has a quantity' do
    item.quantity = 9
    item.quantity.must_equal 9
  end

  it 'has a base item price' do
    item.base_price = Money.new(99)
    item.base_price.must_equal Money.new(99)
  end

  it 'knows how much the options alone cost for this item' do
    item.options_cost = Money.new(99)
    item.options_cost.must_equal Money.new(99)
  end

  it 'has the options chosen for this item' do
    variations = [ 'lorem', 'ipsum' ]

    item.variations = variations
    item.variations.must_equal variations
  end

  it 'has the virtual_cat_id of the equivalent cart item cat, at the time of order creation' do
    item.virtual_cat_id = 123
    item.virtual_cat_id.must_equal 123
  end

  it 'has a summary' do
    item.name = 'thing'
    item.quantity = 2

    item.summary.must_include item.name
    item.summary.must_include item.quantity.to_s
  end

end