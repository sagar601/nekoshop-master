require 'test_helper'

require_relative '../../test_support/factories/cart_factory'

describe Checkout::Create do

  let(:scheduler) { MockWorkerService.new }
  let(:money_service) { Monkey.new MoneyService, create_customer: 'dummy_external_id' }

  before do
    @cart = CartFactory.create! items: 1
    @customer = @cart.customer
    @user = @customer.user
  end

  it 'creates and returns a new checkout if the current customer has none' do
    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call

    result.created?.must_equal true
    result.checkout.must_equal @customer.checkout
  end

  it 'returns the existing checkout if the current customer has one' do
    checkout = @customer.create_checkout cart: @cart

    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call

    result.created?.must_equal true
    result.checkout.must_equal checkout
  end

  it 'preemptively reserves stock' do
    item = @cart.items.first
    virtual_cat = item.virtual_cat
    old_stock = virtual_cat.stock

    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call

    virtual_cat.reload.stock.must_equal (old_stock - item.quantity)
  end

  it 'refuses to checkout if there is not enough stock' do
    item = @cart.items.first
    virtual_cat = item.virtual_cat

    item.update_attribute :quantity, (virtual_cat.stock + 1)

    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call

    result.created?.must_equal false
    result.error.must_equal :not_enough_stock
  end

  it 'schedules a checkout cancellation' do
    Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call
    scheduler.has_job?(CheckoutExpirationJob, wait: 15.minutes).must_equal true
  end

  it 'refuses to create checkouts for empty carts' do
    @cart.items.each &:destroy!
    @cart.reload

    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call

    result.created?.must_equal false
    result.error.must_equal :cannot_checkout_empty_cart
  end

  it 'ensures the customer exists is ready to handle payment stuff' do
    @user.customer.prepared_for_money?.must_equal false

    result = Checkout::Create.new(user: @user, scheduler: scheduler, money_service: money_service).call
    @user.customer.prepared_for_money?.must_equal true
  end

end