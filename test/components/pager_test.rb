require 'test_helper'

describe Components::Pager do

  it 'has a collection' do
    collection = Array.new
    component = Components::Pager.new collection: collection

    component.collection.must_equal collection
  end

end