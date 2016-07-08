require 'test_helper'

describe Address do

  let(:address) do
    Address.new({
      name: 'name',
      line1: 'line1',
      line2: 'line2',
      postal_code: 'postal_code',
      city: 'city',
      country: 'country',
      phone: 'phone'
    })
  end

  it 'has a name' do
    address.name.must_equal 'name'
  end

  it 'has a line' do
    address.line1.must_equal 'line1'
  end

  it 'has another line' do
    address.line2.must_equal 'line2'
  end

  it 'has a postal code' do
    address.postal_code.must_equal 'postal_code'
  end

  it 'has a city' do
    address.city.must_equal 'city'
  end

  it 'has a country' do
    address.country.must_equal 'country'
  end

  it 'has a phone' do
    address.phone.must_equal 'phone'
  end

  it 'is blank if every field is blank' do
    address.blank?.must_equal false

    address = Address.new
    address.blank?.must_equal true
  end

  it 'compares to another address by value' do
    identical_address = Address.new({
      name: 'name',
      line1: 'line1',
      line2: 'line2',
      postal_code: 'postal_code',
      city: 'city',
      country: 'country',
      phone: 'phone'
    })

    (address == identical_address).must_equal true

    different_address = Address.new({
      name: 'different name',
      line1: 'line1',
      line2: 'line2',
      postal_code: 'postal_code',
      city: 'city',
      country: 'country',
      phone: 'phone'
    })

    (address == different_address).must_equal false
  end

end