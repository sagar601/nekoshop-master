require 'test_helper'

describe Option do

  let(:option) { Option.new }

  it 'has a name' do
    option.name = 'lorem ipsum'
    option.name.must_equal 'lorem ipsum'
  end

  it 'has a description' do
    option.description = 'lorem ipsum'
    option.description.must_equal 'lorem ipsum'
  end

  it 'has a cat' do
    cat = Cat.new
    option.cat = cat
    option.cat.must_equal cat
  end

end