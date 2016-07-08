require 'test_helper'

require_relative '../../test_support/factories/checkout_factory'

describe 'Checkout Confirm Step', :capybara do

  before do
    @checkout = CheckoutFactory.create! address: :checkout, payment_method: :customer
    @customer = @checkout.customer
    @user = @customer.user
  end

  after do
    Warden.test_reset!
  end

  it 'displays the shipping address' do
    login_as @user, scope: :user
    visit new_checkout_confirm_path

    address = @checkout.address

    page.must_have_content address.name
    page.must_have_content address.phone
    page.must_have_content address.line1
    page.must_have_content address.line2
    page.must_have_content address.city
    page.must_have_content address.postal_code
    page.must_have_content ISO3166::Country.new(address.country).name
  end

  it 'displays the payment_method' do
    login_as @user, scope: :user
    visit new_checkout_confirm_path

    payment_method = @checkout.payment_method

    page.must_have_content payment_method.card.brand
    page.must_have_content payment_method.card.last4
    page.must_have_content payment_method.card.exp_year
  end

  it 'displays costs' do
    login_as @user, scope: :user
    visit new_checkout_confirm_path

    within '.Checkout-SimpleCostBreakdown' do
      page.must_have_content @checkout.shipping_cost.format
      page.must_have_content @checkout.total.format
    end
  end

  it 'it allows the customer to finish the purchase', :vcr do
    give_a_card_to @customer

    login_as @user, scope: :user
    visit new_checkout_confirm_path

    page.find('#confirm_checkout').click

    Order.count.must_equal 1
    current_path.must_equal orders_path
    assert_positive_flash_message
  end

  it 'it redirects the customer to the payment method page if card is rejected', :vcr do
    give_a_card_to @customer, bad_card: true

    login_as @user, scope: :user
    visit new_checkout_confirm_path

    page.find('#confirm_checkout').click

    Order.count.must_equal 0
    current_path.must_equal edit_checkout_payment_path
    assert_negative_flash_message
  end

  it 'redirects to the cart page if checkout has expired' do
    login_as @user, scope: :user
    visit new_checkout_confirm_path

    @checkout.expire!

    page.find('#confirm_checkout').click

    current_path.must_equal cart_path

    visit new_checkout_confirm_path
    current_path.must_equal cart_path
  end

  def give_a_card_to customer, bad_card: false
    money_service = MoneyService.new
    card_number = bad_card ? '4000000000000341' : '4242424242424242'
    card = { object: 'card', number: card_number, exp_month: 6, exp_year: Time.current.year + 1, cvc: 123 }

    @customer.update_attribute :external_id , money_service.create_customer(@customer)

    stripe_customer = Stripe::Customer.retrieve @customer.external_id
    stripe_customer.source = card
    stripe_customer.save
  end

end