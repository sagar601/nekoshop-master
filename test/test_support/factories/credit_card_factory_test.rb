require 'test_helper'

require_relative 'credit_card_factory'

describe CreditCardFactory do

  it 'builds credit cards' do
    CreditCardFactory.build.must_be_instance_of CreditCard
  end

end