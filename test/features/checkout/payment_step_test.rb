require 'test_helper'

require_relative '../../test_support/factories/checkout_factory'

describe 'Checkout Payment Step', :capybara do

  before do
    @checkout = CheckoutFactory.create! payment_method: :customer, address: :checkout
    @customer = @checkout.customer
    @user = @customer.user
  end

  after do
    Warden.test_reset!
  end

  it 'allows the customer to use a new credit card for this checkout' do
    # FIXME hammer one of the javascript drivers into working with Docker so I can test this page
  end

  it 'allows the customer to use an older credit card for this checkout' do
    login_as @user, scope: :user
    visit edit_checkout_payment_path

    page.find('#use_old_card_button').click

    current_path.must_equal new_checkout_confirm_path
  end

  it 'redirects to the cart page if checkout has expired' do
    login_as @user, scope: :user
    visit edit_checkout_payment_path

    @checkout.expire!

    page.find('#use_old_card_button').click

    current_path.must_equal cart_path

    visit edit_checkout_payment_path
    current_path.must_equal cart_path
  end

end