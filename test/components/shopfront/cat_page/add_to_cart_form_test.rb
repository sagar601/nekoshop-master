require 'test_helper'

require_relative '../../../test_support/factories/cat_factory'

describe Components::Shopfront::CatPage::AddToCartForm do

  let(:cat) { CatFactory.create! options: 2 }
  let(:form) { ::Components::Shopfront::CatPage::AddToCartForm.new cat: cat }

  it 'has a cat' do
    form.cat.must_equal cat
  end

  it 'has a new cart item to use in the form' do
    form.new_item.must_be_kind_of CartItem
    form.new_item.new_record?.must_equal true
  end

  it 'has the data necessary for the Recombobulator React component' do
    cat_data = form.recombobulator_props[:cat]

    cat_data[:price].must_equal cat.price.format

    cat_data[:options].map{ |o| o[:id] }.must_contain cat.options.map(&:id)
    cat_data[:options].map{ |o| o[:name] }.must_contain cat.options.map(&:name)

    cat_data[:options].flat_map{ |o| o[:variations] }.map{ |v| v[:id] }.must_contain cat.variations.map(&:id)
    cat_data[:options].flat_map{ |o| o[:variations] }.map{ |v| v[:name] }.must_contain cat.variations.map(&:name)

    cat_data[:virtual_cats].map{ |o| o[:id] }.must_contain cat.virtual_cats.map(&:id)
    cat_data[:virtual_cats].map{ |o| o[:vcid] }.must_contain cat.virtual_cats.map(&:vcid).map(&:to_a)
    cat_data[:virtual_cats].map{ |o| o[:stock] }.must_contain cat.virtual_cats.map(&:stock)
    cat_data[:virtual_cats].map{ |o| o[:price] }.must_contain cat.virtual_cats.map(&:price).map(&:format)
  end

end