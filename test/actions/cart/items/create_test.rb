require 'test_helper'

describe Cart::Items::Create do

  before do
    @user = User.create! email: Faker::Internet.email, password: 'password'
    @virtual_cat = VirtualCat.create stock: 10, cat: Cat.create!(name: 'Spotty')

    @params = { item: { virtual_cat_id: @virtual_cat.id } }
    @action = Cart::Items::Create.new(user: @user, params: @params)
  end

  it 'adds an item to cart' do
    result = @action.call

    result.created?.must_equal true
    result.item.must_equal @user.customer.cart.items.first
  end

  it 'increases item quantity if the item is already in cart' do
    existing_item = CartItem.create!(cart: @user.customer.cart, virtual_cat: @virtual_cat, quantity: 1)

    result = @action.call

    result.created?.must_equal true
    result.item.must_equal existing_item
    result.item.quantity.must_equal 2
  end

  it 'returns an error if the virtual cat is out of stock' do
    @virtual_cat.update_attribute :stock, 0

    result = @action.call

    result.created?.must_equal false
    result.error.must_equal :cat_not_available
  end

end