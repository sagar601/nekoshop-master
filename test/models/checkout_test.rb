require "test_helper"

describe Checkout do
  let(:checkout) { Checkout.new }

  it 'has a cart' do
    cart = Cart.new
    checkout.cart = cart
    checkout.cart.must_equal cart
  end

  it 'has a customer' do
    customer = Customer.new
    checkout.customer = customer
    checkout.customer.must_equal customer
  end

  it 'has a shipping cost' do
    checkout.shipping_cost.must_be_instance_of Money
  end

  it 'knows if it can determine the shipping cost' do
    checkout.shipping_cost_determinable?.must_equal false
    checkout.address = Address.new country: :pt
    checkout.shipping_cost_determinable?.must_equal true
  end

  it 'has a total' do
    checkout.cart = Monkey.imitate Cart.new, total: Money.new(10)
    checkout.total.must_be_instance_of Money
  end

  it 'knows if it is free' do
    def checkout.total; Money.new(0); end
    checkout.free?.must_equal true

    def checkout.total; Money.new(1); end
    checkout.free?.must_equal false
  end

  describe '#address' do

    it 'is the customer address if the checkout has none' do
      address = Address.new line1: 'lorem ipsum'
      checkout.customer = Customer.new address: address

      checkout.address.must_equal address
    end

    it 'is the one in the checkout if there is one' do
      address = Address.new line1: 'lorem ipsum'
      checkout.address = address

      checkout.address.must_equal address

      address2 = Address.new line1: 'dolor sit amet'
      checkout.customer = Customer.new address: address2

      checkout.address.must_equal address
    end

  end

  it 'knows if it belongs to a guest customer' do
    checkout.customer = Customer.new user: User.new
    checkout.guest?.must_equal false

    checkout.customer = Customer.new user: User::Admin.new
    checkout.guest?.must_equal false

    checkout.customer = Customer.new user: User::Guest.new
    checkout.guest?.must_equal true
  end

  describe '#payment_method' do

    it 'has one' do
      payment_method = PaymentMethod.new
      checkout.payment_method = payment_method
      checkout.payment_method.must_equal payment_method
    end

    it 'starts without one' do
      checkout.payment_method.must_be_nil
    end

    it "is the one of the customer if the checkout's is not there" do
      payment_method = PaymentMethod.new
      checkout.customer = Customer.new payment_method: payment_method

      checkout.payment_method.must_equal payment_method
    end

    it 'knows when it has one' do
      checkout.has_payment_method?.must_equal false

      checkout.customer = Customer.new payment_method: PaymentMethod.new
      checkout.has_payment_method?.must_equal true

      checkout.payment_method = PaymentMethod.new
      checkout.has_payment_method?.must_equal true
    end

  end

  it 'knows how to expire itself safely' do
    checkout.expire!
    checkout.destroyed?.must_equal true
  end

end
