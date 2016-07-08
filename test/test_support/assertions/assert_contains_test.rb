require 'minitest/autorun'

require_relative 'assert_contains'

describe '#assert_contains' do

  it 'is true when a container contains all expected elements' do
    [1,2,3,4,5].must_contain [1,2,3]
    proc{ [1,2,3,4,5].wont_contain [1,2,3] }.must_raise Minitest::Assertion
  end

  it 'is order independent' do
    [3,1,2,5,4].must_contain [1,2,3]
    proc{ [3,1,2,5,4].wont_contain [1,2,3] }.must_raise Minitest::Assertion
  end

  it 'is false if the container only has some expected elements' do
    proc{ [1,2,8,9].must_contain [1,2,3] }.must_raise Minitest::Assertion
    [1,2,8,9].wont_contain [1,2,3]
  end

  it 'is true if both sets contain exactly the same elements' do
    %w(aa xx zzz).must_contain %w(zzz xx aa)
    proc{ %w(aa xx zzz).wont_contain %w(zzz xx aa) }.must_raise Minitest::Assertion
  end

  it 'ignores repeated arguments' do
    %w(bb bb bb cc).must_contain %w(bb)
    %w(bb cc).must_contain %w(bb bb bb)

    proc{ %w(bb bb bb cc).wont_contain %w(bb) }.must_raise Minitest::Assertion
    proc{ %w(bb cc).wont_contain %w(bb bb bb) }.must_raise Minitest::Assertion
  end

  it 'respects object equality' do
    dummy = Class.new do
      attr_accessor :name

      def initialize name
        @name = name
      end

      def == other
        @name == other.name
      end

      alias_method :eql?, :==

      def hash
        @name.hash
      end
    end

    container = [dummy.new('Marianne'), dummy.new('Adam')]

    container.must_contain [dummy.new('Marianne')]
    proc{ container.wont_contain [dummy.new('Marianne')] }.must_raise Minitest::Assertion
  end

  it 'only accepts enumerables' do
    proc{ :abc.must_contain [1,2,3] }.must_raise ArgumentError
    proc{ [1,2,3].must_contain :abc }.must_raise ArgumentError
  end

  it 'requires you to specify at least one expected element' do
    proc{ [1,2,3].must_contain [] }.must_raise ArgumentError
  end

end