require 'test_helper'

describe CheckoutAddressForm do

  let(:params) { { name: 'name', line1: 'line1', postal_code: 'code', city: 'city', country: 'pt', phone: '123' } }

  it 'accepts address with name, line1, code, city, country and phone' do
    CheckoutAddressForm.new(Address.new).validate(params).must_equal true
  end

  it 'rejects addresses without name' do
    merged_params = params.merge(name: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

  it 'rejects addresses without line1' do
    merged_params = params.merge(line1: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

  it 'rejects addresses without postal_code' do
    merged_params = params.merge(postal_code: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

  it 'rejects addresses without city' do
    merged_params = params.merge(city: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

  it 'rejects addresses without country' do
    merged_params = params.merge(country: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

  it 'rejects addresses without phone' do
    merged_params = params.merge(phone: '')
    CheckoutAddressForm.new(Address.new).validate(merged_params).must_equal false
  end

end