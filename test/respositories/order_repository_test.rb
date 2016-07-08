require 'test_helper'

require_relative '../test_support/factories/user_factory'

describe OrderRepository do

  let(:repo) { OrderRepository.new }

  describe '#most_recent_of_customer' do

    before do
      @customer = Customer.create! user: UserFactory.create!

      @order3 = Order.create! customer: @customer, updated_at: (Time.current - 2.days)
      @order2 = Order.create! customer: @customer, updated_at: (Time.current - 1.day)
      @order1 = Order.create! customer: @customer, updated_at: (Time.current)
    end

    it 'finds all orders beloging to a customer' do
      orders = repo.most_recent_of_customer @customer, limit: 2

      orders.length.must_equal 2
      orders.first.must_equal @order1
      orders.second.must_equal @order2
    end

  end

end