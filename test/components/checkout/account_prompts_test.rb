require 'test_helper'

describe Components::Checkout::AccountPrompts do

  it 'has a return url' do
    component = Components::Checkout::AccountPrompts.new return_url: 'dummy_url'
    component.return_url.must_equal 'dummy_url'
  end
end