require 'test_helper'

describe ComponentsHelper do

  describe '#render_component' do

    dummy_context = Struct.new(:partial, :locals) do
      include ComponentsHelper

      def render partial:, locals:
        self.partial = partial
        self.locals = locals
      end
    end

    dummy_component = Class.new do
      def self.name
        'DummyNamespace::DummyComponent'
      end
    end

    it 'calls the `render` method with a partial and an instance of the component as a local' do
      context = dummy_context.new
      context.render_component dummy_component.new

      context.partial.to_s.wont_be_empty
      context.locals[:component].must_be_instance_of dummy_component
    end

    describe 'the partial path' do

      it 'is `component.to_partial_path` if implemented' do
        component = OpenStruct.new to_partial_path: 'dummy/test/path'
        context = dummy_context.new
        context.render_component component

        context.partial.must_equal 'dummy/test/path'
      end

      it 'is based on the full component class name if `to_partial_path` is not available' do
        context = dummy_context.new
        context.render_component dummy_component.new

        context.partial.must_equal 'dummy_namespace/dummy_component'
      end

    end
  end
end