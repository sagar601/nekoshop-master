require 'test_helper'

require_relative '../../test_support/factories/cart_factory'

describe 'Checkout Address Step', :capybara do

  let(:dummy_address) { Address.new name: 'name', line1: 'line1', line2: 'line2', postal_code: '123', city: 'city', country: 'AF', phone: '123' }

  before do
    @cart = CartFactory.create! items: 3, checkout: true
    @customer = @cart.customer
    @user = @customer.user
    @checkout = @customer.checkout
  end

  after do
    Warden.test_reset!
  end

  it 'starts pre-filled with the customer address if available' do
    @customer.address = dummy_address
    @customer.save!

    login_as @user, scope: :user
    visit edit_checkout_address_path

    assert_address_in_form dummy_address
  end

  it 'allows the customer to set the address for the current checkout' do
    login_as @user, scope: :user
    visit edit_checkout_address_path

    fill_address_in_form dummy_address
    find('#next_checkout_step').click

    @checkout.reload.address.must_equal dummy_address
  end

  it 'allows the customer to save the address for all future checkouts' do
    login_as @user, scope: :user
    visit edit_checkout_address_path

    fill_address_in_form dummy_address
    check 'remember_address'
    find('#next_checkout_step').click

    Customer.find(@user.customer.id).address.must_equal dummy_address
  end

  it 'moves on to the next step, payment method' do
    login_as @user, scope: :user
    visit edit_checkout_address_path

    fill_address_in_form dummy_address
    find('#next_checkout_step').click

    current_path.must_equal edit_checkout_payment_path
  end

  it 'rejects blank addresses' do
    login_as @user, scope: :user
    visit edit_checkout_address_path

    find('#next_checkout_step').click

    current_path.must_equal checkout_address_path
    page.must_have_selector 'form#edit_address .negative.message'
  end

  it 'redirects to the cart page if checkout has expired' do
    login_as @user, scope: :user
    visit edit_checkout_address_path

    @checkout.expire!

    fill_address_in_form dummy_address
    find('#next_checkout_step').click

    current_path.must_equal cart_path

    visit edit_checkout_address_path
    current_path.must_equal cart_path
  end


  private

  def fill_address_in_form address
    within 'form#edit_address' do
      fill_in 'address_name', with: address.name
      fill_in 'address_line1', with: address.line1
      fill_in 'address_line2', with: address.line2
      fill_in 'address_postal_code', with: address.postal_code
      fill_in 'address_city', with: address.city
      fill_in 'address_phone', with: address.phone
    end
  end

  def assert_address_in_form address
    within 'form#edit_address' do
      page.find('#address_name').value.must_equal address.name
      page.find('#address_line1').value.must_equal address.line1
      page.find('#address_line2').value.must_equal address.line2
      page.find('#address_postal_code').value.must_equal address.postal_code
      page.find('#address_city').value.must_equal address.city
      page.find('#address_phone').value.must_equal address.phone
    end
  end

end