require 'test_helper'

require_relative '../test_support/factories/cart_factory'

describe CartItemRepository do

  let(:repo) { CartItemRepository.new }

  describe '#in_user_cart' do

    before do
      @cart = CartFactory.create! items: 1
      @item = @cart.items.first
      @user = @cart.customer.user
    end

    it "retrieves an item currently present in a user's cart" do
      repo.in_user_cart(@user, @item.id).must_equal @item
    end

    it 'returns nil if not found' do
      repo.in_user_cart(@user, @item.id + 1).must_equal nil
    end

  end
end