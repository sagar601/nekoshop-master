require "test_helper"

require_relative 'payment_method_behavior_test'

describe PaymentMethod::OneTimeCardPaymentMethod do

  subject{ PaymentMethod::OneTimeCardPaymentMethod.new }
  include PaymentMethodBehaviorTest

  it 'has a checkout' do
    checkout = Checkout.new

    subject.checkout = checkout
    subject.checkout.must_equal checkout
  end

  it 'is invalid without a card with a token' do
    subject.card = CreditCard.new
    subject.validate
    subject.errors[:card].wont_be_empty

    subject.card = CreditCard.new token: 'dummy_token'
    subject.validate
    subject.errors[:card].must_be_empty
  end

  it 'returns Stripe charge params that charge the credit card' do
    subject.card = CreditCard.new token: 'dummy_token'
    subject.stripe_charge_params.must_equal source: 'dummy_token'
  end

end