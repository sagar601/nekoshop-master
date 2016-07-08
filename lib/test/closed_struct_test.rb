require 'minitest/autorun'

require_relative '../closed_struct'

describe ClosedStruct do

  it 'has readers for each attribute provided' do
    struct = ClosedStruct.new aaa: 123, bbb: 456

    struct.must_respond_to :aaa
    struct.must_respond_to :bbb
  end

  it 'has writers for each attribute provided' do
    struct = ClosedStruct.new aaa: 123, bbb: 456

    struct.must_respond_to :aaa=
    struct.aaa = 789
    struct.aaa.must_equal 789

    struct.must_respond_to :bbb=
    struct.aaa = 900
    struct.aaa.must_equal 900
  end

  it 'initializes each attribute with the value provided' do
    struct = ClosedStruct.new aaa: 123, bbb: 456

    struct.aaa.must_equal 123
    struct.bbb.must_equal 456
  end

  it "throws an error for methods it doesn't know about" do
    struct = ClosedStruct.new aaa: 123

    proc { struct.bbb }.must_raise NoMethodError
    proc { struct.bbb = 456 }.must_raise NoMethodError
  end
end