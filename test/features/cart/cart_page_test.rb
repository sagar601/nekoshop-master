require 'test_helper'

require_relative '../../test_support/factories/cart_factory'
require_relative '../../test_support/factories/checkout_factory'

describe 'Cart Page', :capybara, :vcr do

  before do
    @cart = CartFactory.create! items: 3
    @items = @cart.items
    @user = @cart.customer.user
  end

  after do
    Warden.test_reset!
  end

  it 'lists each item in the cart' do
    login_as @user, scope: :user
    visit cart_path

    page.must_have_selector '.Cart-ItemsTable tbody tr', count: 3

    within '.Cart-ItemsTable tbody' do
      @items.each do |item|
        page.must_have_content item.name
        page.must_have_content item.quantity
        page.must_have_content item.subtotal
      end
    end
  end

  it 'allows customer to remove items from cart' do
    login_as @user, scope: :user
    visit cart_path

    page.all('.Cart-ItemsTable tbody tr [data-method=delete]').first.click

    @cart.items.count.must_equal 2
  end

  it 'allows customer to update cart item quantities' do
    login_as @user, scope: :user
    visit cart_path

    find('.Cart-ChangeQuantitiesButton').click

    current_path.must_equal edit_cart_path
  end

  it 'shows the total cost of the cart' do
    login_as @user, scope: :user
    visit cart_path

    within '.Checkout-Summary' do
      page.must_have_content @cart.total.format
    end
  end

  it 'shows shipping costs if available' do
    checkout = CheckoutFactory.create! address: :checkout
    user = checkout.customer.user

    login_as user, scope: :user
    visit cart_path

    within '.Checkout-Summary' do
      page.must_have_content checkout.shipping_cost.format
    end
  end

  it 'allows customers to start the checkout process if cart is not empty' do
    login_as @user, scope: :user
    visit cart_path

    find('.Checkout-StartCheckoutButton').click

    current_path.must_equal edit_checkout_address_path

    @cart.items.each &:destroy

    visit cart_path
    page.must_have_selector '.Checkout-StartCheckoutButton[disabled]'
  end

  it 'shows an error when attemping to start the checkout if items are no longer in stock' do
    login_as @user, scope: :user
    visit cart_path

    @items.first.virtual_cat.update_attribute :stock, 0

    find('.Checkout-StartCheckoutButton').click

    current_path.must_equal cart_path
    assert_negative_flash_message
  end

  it 'shows a friendly message if cart is empty' do
    login_as @user, scope: :user
    visit cart_path

    page.wont_have_selector '.Cart-ItemsTable_empty-cart-message'

    @cart.destroy!
    visit cart_path

    page.must_have_selector '.Cart-ItemsTable_empty-cart-message'
  end

  it 'shows the friendly empty cart message for fresh guests' do
    login_as User::Guest.new, scope: :user
    visit cart_path

    page.must_have_selector '.Cart-ItemsTable_empty-cart-message'
  end

end