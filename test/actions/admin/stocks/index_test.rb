require 'test_helper'

require_relative '../admin_action_test'

describe Admin::Stocks::Index do

  let(:cats) { [ Monkey.new(Cat, stock: 11) ] }
  let(:repo) { Monkey.new CatRepository, all: cats }

  def build_action user:
    Admin::Stocks::Index.new user: user, params: {}, cat_repo: repo
  end

  include AdminActionTest

  it 'returns the quantity in stock for each cat fetched from the repo' do
    result = build_action(user: User::Admin.new).call
    result.stocks.first.quantity.must_equal 11
  end

  it 'returns the cats fetched from the repo' do
    result = build_action(user: User::Admin.new).call
    result.cats.must_equal cats
  end

end