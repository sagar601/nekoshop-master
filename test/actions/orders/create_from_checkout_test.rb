require 'test_helper'

require_relative '../../test_support/factories/checkout_factory'

describe Orders::CreateFromCheckout do

  let(:dummy_money_service) { Monkey.new MoneyService, charge_checkout: 'dummy_charge_id' }
  let(:dummy_mailer) { MockMailer.new }

  def action checkout, money_service = dummy_money_service, mailer = dummy_mailer
    Orders::CreateFromCheckout.new user: checkout.customer.user, money_service: money_service, mailer: mailer
  end

  before do
    @checkout = CheckoutFactory.create! payment_method: :customer
  end

  it 'creates an order' do
    result = action(@checkout).call

    result.created?.must_equal true
    result.order.must_equal Order.last
  end

  it 'charges the customer' do
    assert_correct_charge = Proc.new do |checkout|
      checkout.must_equal @checkout
      checkout.total.must_equal @checkout.total
    end

    dummy_money_service.stub :charge_checkout, assert_correct_charge do
      action(@checkout, dummy_money_service).call
    end
  end

  it 'does not charge for free orders' do
    @checkout = CheckoutFactory.create! free: true
    charged = false

    trap_charge = proc{ charged = true }

    dummy_money_service.stub :charge_checkout, trap_charge do
      action(@checkout, dummy_money_service).call
    end

    charged.must_equal false
  end

  it 'returns an error if cart is empty' do
    @checkout.cart.items.each &:destroy!
    result = action(@checkout).call

    result.created?.must_equal false
    result.error.must_equal :empty_cart
  end

  it 'returns an error if credit card is rejected' do
    result = nil

    dummy_money_service.stub :charge_checkout, proc{ raise MoneyService::CardRejectedError } do
      result = action(@checkout, dummy_money_service).call
    end

    result.created?.must_equal false
    result.error.must_equal :card_rejected
  end

  it 'deletes the checkout and shopping cart after the order is created' do
    result = action(@checkout).call

    Checkout.count.must_equal 0
    Cart.count.must_equal 0
  end

  it 'sends an email' do
    result = action(@checkout).call

    dummy_mailer.sent_email? OrderMailer, :new_order, result.order
  end

end