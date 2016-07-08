require "test_helper"

require_relative 'payment_method_behavior_test'

describe PaymentMethod::CustomerCardPaymentMethod do
  subject{ PaymentMethod::CustomerCardPaymentMethod.new }
  include PaymentMethodBehaviorTest

  it 'has a customer' do
    customer = Customer.new

    subject.customer = customer
    subject.customer.must_equal customer
  end

  it 'returns Stripe charge params that charge a customer object on Stripe' do
    customer = Customer.new external_id: 'dummy_external_id'
    subject.customer = customer

    subject.stripe_charge_params.must_equal customer: 'dummy_external_id'
  end

end