require 'test_helper'

require_relative 'concerns/is_addressable_test'

describe Customer do
  subject { Customer.new }
  include AddressableTest

  it 'references a user' do
    user = User.new
    customer = Customer.new

    customer.user = user
    customer.user.must_equal user
  end

  it 'has an external id' do
    customer = Customer.new

    customer.external_id = 'abcd'
    customer.external_id.must_equal 'abcd'
  end

  it 'has an address' do
    address = Address.new
    customer = Customer.new

    customer.address = address
    customer.address.must_equal address
  end

  it 'has a shopping cart' do
    cart = Cart.new
    customer = Customer.new

    customer.cart = cart
    customer.cart.must_equal cart
  end

  it 'has an empty shopping cart by default' do
    customer = Customer.new

    customer.cart.wont_be_nil
    customer.cart.is_empty?.must_equal true
  end

  it 'has a payment_method' do
    customer = Customer.new
    payment_method = PaymentMethod.new

    customer.payment_method = payment_method
    customer.payment_method.must_equal payment_method
  end

  it 'knows if it is prepared to handle payments' do
    customer = Customer.new
    customer.prepared_for_money?.must_equal false

    customer.external_id = 'dummy_external_id'
    customer.prepared_for_money?.must_equal true
  end

  describe '#ensure_prepared_for_money!' do

    it 'creates a customer object in the external service if one does not exist there already' do
      money_service = Monkey.new MoneyService, create_customer: 'dummy_external_id'
      customer = Customer.new id: 123, user: User.new(email: 'a@b.c')
      def customer.save!; end

      customer.prepared_for_money?.must_equal false

      customer.ensure_prepared_for_money! money_service

      customer.prepared_for_money?.must_equal true
    end

    it 'does not call the expensive service if it is already in registered in the external service' do
      customer = Customer.new external_id: 'dummy_external_id'
      money_service = Monkey.new MoneyService, create_customer: 'dummy_external_id'
      def money_service.create_customer; @called = true; end
      def money_service.called?; @called; end

      customer.ensure_prepared_for_money! money_service

      money_service.called?.wont_equal true
    end

  end

  it 'has orders' do
    orders = [ Order.new, Order.new ]
    customer = Customer.new

    customer.orders = orders
    customer.orders.must_equal orders
  end

end
