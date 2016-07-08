require 'test_helper'

require_relative 'cart_action_behavior'
require_relative '../../test_support/factories/cart_factory'

describe Cart::Update do
  include CartActionBehavior

  before do
    @cart = CartFactory.create! items: 2
    @item = @cart.items.last
    @user = @cart.customer.user
  end

  def build_params quantity
    { 'items' => { @item.id => { 'quantity' => quantity } } }
  end

  def build_action user:, quantity: 1, **others
    Cart::Update.new user: user, params: build_params(quantity), **others
  end


  it 'changes the item quantity' do
    result = Cart::Update.new(user: @user, params: build_params(1)).call

    result.any_errors?.must_equal false
    @item.reload.quantity.must_equal 1
  end

  it 'removes items from cart if quantity is 0' do
    result = Cart::Update.new(user: @user, params: build_params(0)).call

    result.any_errors?.must_equal false
    @cart.items.count.must_equal 1
  end

  it 'returns error if quantity is above stock' do
    result = Cart::Update.new(user: @user, params: build_params(20)).call

    result.any_errors?.must_equal true
    @item.reload.quantity.must_equal 2
  end

  it 'returns error if quantity is negative' do
    result = Cart::Update.new(user: @user, params: build_params(-1)).call

    result.any_errors?.must_equal true
    @item.reload.quantity.must_equal 2
  end

end