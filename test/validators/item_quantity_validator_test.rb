require 'test_helper'

describe ItemQuantityValidator do

  it 'validates false and adds error when quantity is a negative number' do
    [-1, 0, 1].map do |q|

      item = CartItem.new quantity: q
      item.virtual_cat = VirtualCat.new(stock: 20)
      validator = ItemQuantityValidator.new

      [ validator.validate(item), item.errors.empty? ]

    end.must_equal [
      [false, false],
      [true, true],
      [true, true],
    ]
  end

  it 'validates false and adds error when quantity is a above the available stock' do
    [19, 20, 21].map do |q|

      item = CartItem.new quantity: q
      item.virtual_cat = VirtualCat.new(stock: 20)
      validator = ItemQuantityValidator.new

      [ validator.validate(item), item.errors.empty? ]

    end.must_equal [
      [true, true],
      [true, true],
      [false, false],
    ]
  end

end