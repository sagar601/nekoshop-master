require 'test_helper'

describe CapValidator do

  it 'rejects models when a collection exceeds the size limit' do
    dummy_record = Class.new do
      include ActiveModel::Validations
      attr_accessor :things

      validates :things, cap: 10

      def model_name; VoidObject.new; end
      def self.human_attribute_name(*_); VoidObject.new; end
    end

    dummy = dummy_record.new
    dummy.things = []
    dummy.valid?.must_equal true

    dummy.things = [Object.new]
    dummy.valid?.must_equal true

    dummy.things = Array.new 10
    dummy.valid?.must_equal true

    dummy.things = Array.new 11
    dummy.valid?.must_equal false
  end

end