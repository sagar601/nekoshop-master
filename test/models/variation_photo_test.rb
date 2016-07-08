require 'test_helper'

require_relative 'concerns/imageable_test'

describe VariationPhoto do
  subject { VariationPhoto.new }

  include ImageableTest

  it 'references the owning variation' do
    variation = Variation.new
    subject.variation = variation
    subject.variation.must_equal variation
  end

end