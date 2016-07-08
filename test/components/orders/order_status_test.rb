require 'test_helper'

describe Components::Orders::OrderStatus do

  # see note in order_status.rb about a possible status type

  it 'has a different colors for paid and cancelled orders' do
    order = Monkey.new Order, paid?: false, cancelled?: false
    paid_order = Monkey.new Order, paid?: true, cancelled?: false
    cancelled_order = Monkey.new Order, paid?: false, cancelled?: true

    [order, paid_order, cancelled_order].map{ |order| Components::Orders::OrderStatus.new(order: order).color }.uniq.count.must_equal 3
  end

  it 'has a different text for paid and cancelled orders' do
    order = Monkey.new Order, paid?: false, cancelled?: false
    paid_order = Monkey.new Order, paid?: true, cancelled?: false
    cancelled_order = Monkey.new Order, paid?: false, cancelled?: true

    [order, paid_order, cancelled_order].map{ |order| Components::Orders::OrderStatus.new(order: order).status }.uniq.count.must_equal 3
  end

end