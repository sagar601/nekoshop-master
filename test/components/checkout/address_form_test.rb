require 'test_helper'

describe Components::Checkout::AddressForm do

  let(:address) { Address.new(line1: 'lorem ipsum') }
  let(:form) { Components::Checkout::AddressForm.new address: address, rememberable: false }

  it 'has an address' do
    form.address.must_equal address
  end

  it 'knows when to show the remember address checkbox' do
    form.rememberable.must_equal false
  end

end