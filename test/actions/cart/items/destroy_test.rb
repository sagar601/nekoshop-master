require 'test_helper'

describe Cart::Items::Destroy do

  stubbed_item = Class.new CartItem do
    def destroy!
      @destroyed = true
    end

    def destroyed?
      @destroyed
    end
  end

  def make_repo item = nil
    Monkey.new CartItemRepository, in_user_cart: item
  end

  it "removes an item from the user's shopping cart" do
    item = stubbed_item.new id: 1
    repo = make_repo item

    result = Cart::Items::Destroy.new(user: User.new, item_id: item.id, item_repo: repo).call

    result.destroyed?.must_equal true
    item.destroyed?.must_equal true
  end

  it 'returns the destroyed item' do
    item = stubbed_item.new id: 1
    repo = make_repo item

    result = Cart::Items::Destroy.new(user: User.new, item_id: item.id, item_repo: repo).call

    result.item.must_equal item
  end

  it 'does nothing if the item is not in the cart' do
    result = Cart::Items::Destroy.new(user: User.new, item_id: 99, item_repo: make_repo).call

    result.destroyed?.must_equal false
  end

end