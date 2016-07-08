require 'test_helper'

describe Components::Address do

  let(:address)   { Address.new name: 'Marianne', city: 'SomeCity', country: 'es' }
  let(:component) { Components::Address.new address: address }

  it 'has a decorated address' do
    component.address.name.must_equal address.name
    component.address.city.must_equal address.city
  end

  it 'uses the country name instead of code in the country field' do
    component.address.country.must_equal 'Spain'
  end

  it 'has an optional title, blank by default' do
    component.title.to_s.must_be_empty

    component = Components::Address.new address: address, title: 'lorem ipsum'
    component.title.must_include 'lorem ipsum'
  end

  it 'has configurable wrapper_classes' do
    component.wrapper_classes.to_s.must_be_empty

    component = Components::Address.new address: address, wrapper_classes: 'dummy classes'
    component.wrapper_classes.must_equal 'dummy classes'
  end

end