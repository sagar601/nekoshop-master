require 'test_helper'

require_relative '../test_support/factories/cart_factory'

describe CheckoutExpirationJob do

  before do
    @cart = CartFactory.create! items: 1
    @virtual_cat = @cart.items.first.virtual_cat
    @checkout = @cart.customer.create_checkout cart: @cart

    @original_stock = @virtual_cat.stock

    @stock_reserve = [[ @virtual_cat.id, 1 ]]

    @virtual_cat.stock -= 1
    @virtual_cat.save!
  end

  it 'deletes the checkout object' do
    CheckoutExpirationJob.new.perform @checkout, @stock_reserve
    Checkout.find_by_id(@checkout.id).must_be_nil
  end

  it 'restores reserved stock' do
    CheckoutExpirationJob.new.perform @checkout, @stock_reserve
    @virtual_cat.reload.stock.must_equal @original_stock
  end

end
