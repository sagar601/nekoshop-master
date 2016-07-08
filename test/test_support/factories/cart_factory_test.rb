require 'test_helper'

require_relative 'cart_factory'

describe CartFactory do

  before do
    @cart = CartFactory.create! items: 3
  end

  it 'creates a cart with the specified number of items in it' do
    @cart.persisted?.must_equal true
    @cart.items.count.must_equal 3
  end

  it 'creates a user and a customer to go with the cart' do
    @cart.customer.wont_be_nil
    @cart.customer.persisted?.must_equal true

    @cart.customer.user.wont_be_nil
    @cart.customer.user.persisted?.must_equal true
  end

  describe 'each cart item' do

    it 'refers to a different cat' do
      cat_ids = @cart.items.map{ |item| item.virtual_cat.cat.id }.compact.uniq
      cat_ids.length.must_equal 3
    end

    it 'is stocked' do
      @cart.items.all?(&:in_stock?).must_equal true
    end

    it 'has quantity equal to its index list' do
      @cart.items.map(&:quantity).must_equal [1,2,3]
    end

    describe 'each of the cats' do

      before do
        @cats = @cart.items.map(&:virtual_cat)
      end

      it 'has a unique name' do
        @cats.map(&:name).uniq.length.must_equal 3
      end

      it 'has a unique price' do
        @cats.map(&:price).uniq.length.must_equal 3
      end

    end

  end

  it 'creates a checkout if told so' do
    @cart.customer.checkout.must_be_nil

    cart = CartFactory.create! items: 1, checkout: true

    cart.customer.checkout.wont_be_nil
  end

  describe '#cleanup' do

    it 'deletes carts, items, cats, users, customers and checkouts' do
      CartFactory.cleanup!

      Cart.count.must_equal 0
      CartItem.count.must_equal 0
      Cat.count.must_equal 0
      VirtualCat.count.must_equal 0
      User.count.must_equal 0
      Customer.count.must_equal 0
      Checkout.count.must_equal 0
    end

  end

end