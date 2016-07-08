require 'test_helper'

require_relative '../user_action_test'

describe Orders::Index do

  let(:orders) { Array.new }
  let(:repo) { Monkey.new OrderRepository, most_recent_of_customer: orders }

  def build_action user:
    Orders::Index.new user: user, params: {}, order_repo: repo
  end

  include UserActionTest

  it 'gets the most recent customer orders from the repository' do
    result = build_action(user: User.new).call

    result.orders.must_equal orders
  end

end