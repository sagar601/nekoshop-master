require 'test_helper'
require_relative 'concerns/imageable_test'

describe CatPhoto do
  subject { CatPhoto.new }
  include ImageableTest

  it 'references a cat' do
    cat = Cat.new
    photo = CatPhoto.new

    photo.cat = cat
    photo.cat.must_equal cat
  end
end
