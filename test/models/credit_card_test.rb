require 'test_helper'

describe CreditCard do

  let(:cc) { CreditCard.new }

  it 'has a token' do
    cc.token = 'tok_123'
    cc.token.must_equal 'tok_123'
  end

  it 'has a brand' do
    cc.brand = 'visa'
    cc.brand.must_equal 'visa'
  end

  it 'has the last 4 digits' do
    cc.last4 = '1234'
    cc.last4.must_equal '1234'
  end

  it 'has an expiration date month' do
    cc.exp_month = 6
    cc.exp_month.must_equal 6
  end

  it 'has an expiration date year' do
    cc.exp_year = 2016
    cc.exp_year.must_equal 2016
  end

end