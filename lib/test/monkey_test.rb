require 'minitest/autorun'

require_relative '../monkey'

describe Monkey do

  dummy_class = Class.new do
    def aaa; end
    def bbb; end
  end

  it 'implements the provided methods' do
    monkey = Monkey.new dummy_class, aaa: 123, bbb: 456

    monkey.must_respond_to :aaa
    monkey.must_respond_to :bbb
  end

  it 'returns the provided values for each method' do
    monkey = Monkey.new dummy_class, aaa: 123, bbb: 456

    monkey.aaa.must_equal 123
    monkey.bbb.must_equal 456
  end

  it 'raises an error on initialization if the provided class does not implement a provided method' do
    proc { Monkey.new(dummy_class, aaa: 123, ccc: 789) }.must_raise Monkey::CannotImitateError
  end

  describe '##imitate' do

    it 'stubs a method directly on an object' do
      dummy = dummy_class.new
      Monkey.imitate dummy, aaa: 123

      dummy.aaa.must_equal 123
    end

    it 'returns the stubbed object' do
      dummy = dummy_class.new
      Monkey.imitate(dummy, aaa: nil).must_equal dummy
    end

    it 'raises an error if the object does not implement the provided method' do
      dummy = dummy_class.new
      proc { Monkey.imitate(dummy, ccc: nil) }.must_raise Monkey::CannotImitateError
    end
  end
end