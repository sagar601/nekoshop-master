require 'test_helper'

describe Checkout::Payments::Edit do

  it 'has the current checkout' do
    checkout = Checkout.new
    user = User.new
    repo = Monkey.new CheckoutRepository, of_customer: checkout

    result = Checkout::AddressActions::Edit.new(user: user, checkout_repo: repo).call
    result.checkout.must_equal checkout
  end

end