require 'test_helper'

describe Checkout::AddressActions::Edit do

  def build_repo checkout
    Monkey.new CheckoutRepository, of_customer: checkout
  end

  it 'has the checkout address' do
    address = Address.new line1: 'lorem ipsum'
    checkout = OpenStruct.new(address: address)
    user = OpenStruct.new

    result = Checkout::AddressActions::Edit.new(user: user, checkout_repo: build_repo(checkout)).call
    result.address.line1.must_equal address.line1
  end

  it 'has the current checkout' do
    checkout = OpenStruct.new(address: Address.new)
    user = OpenStruct.new

    result = Checkout::AddressActions::Edit.new(user: user, checkout_repo: build_repo(checkout)).call
    result.checkout.must_equal checkout
  end

end