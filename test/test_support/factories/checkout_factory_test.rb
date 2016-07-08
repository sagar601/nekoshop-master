require 'test_helper'

require_relative 'checkout_factory'

describe CheckoutFactory do

  it 'creates a checkout complete with a cart and customer by default' do
    checkout = CheckoutFactory.create!

    checkout.cart.must_be_kind_of Cart
    checkout.customer.must_be_kind_of Customer
  end

  describe 'payment method' do

    it 'does not exist by default' do
      checkout = CheckoutFactory.create!
      checkout.has_payment_method?.must_equal false
    end

    it "can be configured to use the customer's payment method" do
      checkout = CheckoutFactory.create! payment_method: :customer
      checkout.payment_method.must_be_kind_of PaymentMethod::CustomerCardPaymentMethod
      checkout.payment_method.must_equal checkout.customer.payment_method
    end

    it 'has a credit card when it exists' do
      checkout = CheckoutFactory.create! payment_method: :customer
      checkout.payment_method.card.last4.wont_be_empty
    end

  end

  describe 'cost' do

    it 'is not free by default' do
      checkout = CheckoutFactory.create!
      checkout.free?.must_equal false
    end

    it 'can be configured to be free' do
      checkout = CheckoutFactory.create! free: true
      checkout.free?.must_equal true
    end

  end

  describe 'cart' do

    it 'is not empty by default' do
      checkout = CheckoutFactory.create!
      checkout.cart.is_empty?.must_equal false
    end

    it "must belong to the checkout's customer" do
      checkout = CheckoutFactory.create!
      checkout.cart.customer.must_equal checkout.customer
    end

  end

  describe 'customer' do

    it 'also has a user by default' do
      checkout = CheckoutFactory.create!
      checkout.customer.user.must_be_kind_of User
    end

  end

  describe 'address' do

    it 'is blank by default' do
      checkout = CheckoutFactory.create!
      checkout.address.blank?.must_equal true
    end

    it 'can be configured to have one' do
      checkout = CheckoutFactory.create! address: :checkout
      checkout.address.blank?.must_equal false
    end

  end

  describe '#cleanup!' do

    it 'deletes checkout, customer, users and carts' do
      CheckoutFactory.cleanup!

      Checkout.count.must_equal 0
      Customer.count.must_equal 0
      User.count.must_equal 0
      Cart.count.must_equal 0
    end

  end

end