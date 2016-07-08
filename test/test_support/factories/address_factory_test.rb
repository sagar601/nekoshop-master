require 'test_helper'

require_relative 'address_factory'

describe AddressFactory do

  it 'has name, phone number, two address lines, city, postal code and country' do
    address = AddressFactory.build

    %i(name phone line1 line2 city postal_code country).each do |attr|
      address.send(attr).to_s.wont_be_empty
    end
  end

  it 'has a valid country code' do
    address = AddressFactory.build
    country = ISO3166::Country.new address.country

    country.nil?.must_equal false
  end

end