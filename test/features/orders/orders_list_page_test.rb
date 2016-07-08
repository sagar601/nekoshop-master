require 'test_helper'

require_relative '../../test_support/factories/user_factory'
require_relative '../../test_support/factories/address_factory'

describe 'Orders list page', :capybara do

  before do
    @user = UserFactory.create!
    @customer = Customer.create! user: @user

    @order1 = Order.create! customer: @customer, address: AddressFactory.build, total: Money.new(123)
    @order2 = Order.create! customer: @customer, address: AddressFactory.build, total: Money.new(987)
  end

  it 'is accessible to users and admins only' do
    assert_access_restricted orders_path, User, User::Admin
  end

  it 'displays the most recent customer orders' do
    login_as @user, scope: :user
    visit orders_path

    page.must_have_content @order1.address.line1
    page.must_have_content @order1.total.format

    page.must_have_content @order2.address.line1
    page.must_have_content @order2.total.format
  end

end