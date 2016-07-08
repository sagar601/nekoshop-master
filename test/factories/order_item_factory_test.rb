require 'test_helper'

describe OrderItemFactory do

  it 'transforms a collection o CartItems into equivalent OrderItems' do
    cart_items = [
      Monkey.imitate(CartItem.new,
        name: 'item1',
        variations: [],
        quantity: 1,
        base_price: Money.new(99),
        options_cost: Money.new(150),
        virtual_cat_id: 11
      ),
      Monkey.imitate(CartItem.new,
        name: 'item2',
        variations: [ 'var1', 'var2' ],
        quantity: 5,
        base_price: Money.new(50),
        options_cost: Money.new(199),
        virtual_cat_id: 22
      ),
    ]

    order_items = OrderItemFactory.new.from_cart_items cart_items

    order_items.zip(cart_items).each do |order_item, cart_item|

      %i(name variations quantity base_price options_cost virtual_cat_id).map do |attr|
        order_item.send(attr) == cart_item.send(attr)
      end
      .reduce(:&).must_equal true

    end
  end

end