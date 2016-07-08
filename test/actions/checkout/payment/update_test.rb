require 'test_helper'

require_relative '../../../test_support/factories/checkout_factory'

describe Checkout::Payments::Update do

  let(:empty_params)          { {} }
  let(:cc_params)             { { token: 'abc', brand: 'Visa', last4: '1234', exp_month: 6, exp_year: 2016 } }

  let(:use_old_card_params)   { { commit: 'use_old_card' } }
  let(:one_time_card_params)  { { commit: 'use_new_card', card: cc_params } }
  let(:remember_card_params)  { { commit: 'use_new_card', card: cc_params, remember_card: 'true' } }

  def build_action checkout, params, money_service = OpenStruct.new
    Checkout::Payments::Update.new user: checkout.customer.user, params: params.stringify_keys, money_service: money_service
  end

  it 'allows customer to use an old credit card for this checkout' do
    checkout = CheckoutFactory.create! payment_method: :customer
    result = build_action(checkout, use_old_card_params).call

    result.updated?.must_equal true
    result.checkout.must_be_instance_of Checkout

    result.checkout.payment_method.must_equal checkout.customer.payment_method
  end

  it 'allows customer to use a new credit card for this checkout only' do
    checkout = CheckoutFactory.create!
    result = build_action(checkout, one_time_card_params).call

    result.updated?.must_equal true
    result.checkout.must_be_instance_of Checkout

    result.checkout.payment_method.card.to_h.must_equal one_time_card_params[:card]
  end

  it 'allows customer to use a new credit card for this checkout and future ones' do
    checkout = CheckoutFactory.create!
    money_service = Monkey.new MoneyService, set_customer_default_card: remember_card_params[:card]
    result = build_action(checkout, remember_card_params, money_service).call

    result.updated?.must_equal true
    result.checkout.must_be_instance_of Checkout

    checkout.customer.payment_method.card.to_h.must_equal remember_card_params[:card]
    result.checkout.payment_method.must_equal checkout.customer.payment_method
  end

  it 'allows the customer to continue without payment method if the checkout is free' do
    checkout = CheckoutFactory.create! free: true
    result = build_action(checkout, empty_params).call

    result.updated?.must_equal true
    result.checkout.must_be_instance_of Checkout
  end

  it 'returns an error if there is not a payment method and the checkout is not free' do
    checkout = CheckoutFactory.create!
    result = build_action(checkout, empty_params).call

    result.updated?.must_equal false
    result.checkout.must_be_instance_of Checkout
    result.error.must_equal :card_required
  end

end