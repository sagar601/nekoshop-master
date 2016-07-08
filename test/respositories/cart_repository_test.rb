require 'test_helper'

require_relative '../test_support/factories/checkout_factory'

describe CartRepository do

  let(:repo) { CartRepository.new }

  describe '#of_customer' do

    before do
      cart = CartFactory.create!
      @customer = cart.customer
    end

    it 'finds the cart belonging to a customer' do
      cart = repo.of_customer @customer

      cart.must_be_instance_of Cart
      cart.customer.id.must_equal @customer.id
    end

    it 'returns a new, empty, pre-assigned cart if not found' do
      customer = Customer.new id: -1
      cart = repo.of_customer customer

      cart.must_be_instance_of Cart
      cart.is_empty?.must_equal true
      cart.customer.must_equal customer
    end

  end

end