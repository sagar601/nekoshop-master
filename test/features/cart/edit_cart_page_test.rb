require 'test_helper'

require_relative '../../test_support/factories/cart_factory'

describe 'Edit Cart Page', :capybara do

  before do
    @cart = CartFactory.create! items: 3
    @items = @cart.items
    @user = @cart.customer.user
  end

  after do
    Warden.test_reset!
  end

  it 'allows customer to update cart item quantities' do
    login_as @user, scope: :user
    visit edit_cart_path

    item = @items.third
    item.quantity.wont_equal 1

    fill_in "items[#{item.id}][quantity]", with: 1
    find('.Cart-UpdateCartButton').click

    current_path.must_equal cart_path
    assert_positive_flash_message
    item.reload.quantity.must_equal 1
  end

  it 'rejects updates when quantity is above the available stock' do
    login_as @user, scope: :user
    visit edit_cart_path

    item = @items.third
    old_quantity = item.quantity

    fill_in "items[#{item.id}][quantity]", with: (item.virtual_cat.stock + 1)
    find('.Cart-UpdateCartButton').click

    assert_error_displayed_in_table
    item.reload.quantity.must_equal old_quantity
  end

  it 'removes items from cart if quantity is set to 0' do
    login_as @user, scope: :user
    visit edit_cart_path

    item = @items.second
    old_item_count = @cart.items.count

    fill_in "items[#{item.id}][quantity]", with: 0
    find('.Cart-UpdateCartButton').click

    current_path.must_equal cart_path
    assert_positive_flash_message
    @cart.items.count.must_equal old_item_count - 1
  end

  it 'rejects negative quantities' do
    login_as @user, scope: :user
    visit edit_cart_path

    item = @items.first
    old_quantity = item.quantity

    fill_in "items[#{item.id}][quantity]", with: -1
    find('.Cart-UpdateCartButton').click

    assert_error_displayed_in_table
    item.reload.quantity.must_equal old_quantity
  end

  it 'updates items independently' do
    login_as @user, scope: :user
    visit edit_cart_path

    error_item = @items.first
    fill_in "items[#{error_item.id}][quantity]", with: (error_item.virtual_cat.stock + 1)

    item = @items.third
    item.quantity.wont_equal 1
    fill_in "items[#{item.id}][quantity]", with: 1

    find('.Cart-UpdateCartButton').click

    assert_error_displayed_in_table
    item.reload.quantity.must_equal 1
  end

  def assert_error_displayed_in_table
    page.must_have_selector '.Cart-ItemsTable tbody .Cart-ItemsTable_item-errors', count: 1
  end

end