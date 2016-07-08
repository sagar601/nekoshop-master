require 'test_helper'

require_relative '../test_support/factories/checkout_factory'

describe CheckoutRepository do

  let(:repo) { CheckoutRepository.new }

  describe '#of_customer' do

    before do
      checkout = CheckoutFactory.create!
      @customer = checkout.customer
    end

    it 'finds the checkout belonging to a customer' do
      c1 = repo.of_customer @customer
      c2 = repo.of_customer! @customer

      [c1, c2].each do |checkout|
        checkout.must_be_instance_of Checkout
        checkout.customer.id.must_equal @customer.id
      end
    end

    it 'returns nil if not found' do
      repo.of_customer(Customer.new id: nil).must_equal nil
    end

    it 'raises RecordNotFound if not found for the bang version' do
      proc{ repo.of_customer! Customer.new(id: nil) }.must_raise ActiveRecord::RecordNotFound
    end

  end

end