require 'test_helper'

describe Order do

  let(:order) { Order.new }

  it 'has items' do
    items = [ OrderItem.new, OrderItem.new ]
    order.items = items
    order.items.must_equal items
  end

  it 'has a total cost' do
    order.total = Money.new(99)
    order.total.must_equal Money.new(99)
  end

  it 'has a shipping cost' do
    order.shipping_cost = Money.new(99)
    order.shipping_cost.must_equal Money.new(99)
  end

  it 'has an address' do
    address = Address.new

    order.address = address
    order.address.must_equal address
  end

  it 'has the id of the charge that paid this order' do
    order.charge_id = 'dummy_charge_id'
    order.charge_id.must_equal 'dummy_charge_id'
  end

  it 'has a customer' do
    customer = Customer.new

    order.customer = customer
    order.customer.must_equal customer
  end

  it 'knows if it is free' do
    order = Order.new total: Money.new(0)
    order.free?.must_equal true

    order = Order.new total: Money.new(1)
    order.free?.must_equal false
  end

  it 'is payable' do
    order = Order.new total: Money.new(0)
    order.pay
    order.paid?.must_equal true

    order = Order.new total: Money.new(1)
    proc{ order.pay }.must_raise Order::ChargeRequiredError
    order.paid?.must_equal false

    order = Order.new total: Money.new(1)
    order.pay 'dummy_charge_id'
    order.paid?.must_equal true
  end

  it 'cancellable' do
    order.cancelled?.must_equal false
    order.cancel
    order.cancelled?.must_equal true
  end

  it 'has a summary' do
    items = [ OrderItem.new(name: 'thing', quantity: 1), OrderItem.new(name: 'thing2', quantity: 2) ]
    order = Order.new items: items

    order.summary.must_include order.id.to_s
    order.summary.must_include '1 x thing'
    order.summary.must_include '2 x thing2'
    order.summary.must_include order.shipping_cost.format
    order.summary.must_include order.total.format
  end

end