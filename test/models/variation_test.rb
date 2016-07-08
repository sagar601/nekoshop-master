require 'test_helper'

describe Variation do

  let(:variation) { Variation.new }

  it 'has a name' do
    variation.name = 'lorem ipsum'
    variation.name.must_equal 'lorem ipsum'
  end

  it 'has a cost' do
    variation.cost = Money.new(99)
    variation.cost.must_equal Money.new(99)
  end

  it 'references the parent option' do
    option = Option.new
    variation.option = option
    variation.option.must_equal option
  end

end