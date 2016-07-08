require 'test_helper'

require_relative 'cat_factory'

describe CatFactory do

  it 'creates cats with name, species, non-zero price, summary and description' do
    cat = CatFactory.create!

    cat.name.to_s.wont_be_empty
    cat.species.to_s.wont_be_empty
    cat.summary.to_s.wont_be_empty
    cat.description.to_s.wont_be_empty

    cat.price.zero?.must_equal false
  end

  describe 'options' do

    it 'starts with none by default' do
      cat = CatFactory.create!
      cat.options.count.must_equal 0
    end

    it 'can be told how many to fabricate' do
      cat = CatFactory.create! options: 3
      cat.options.count.must_equal 3
    end

    describe 'variations' do

      it 'fabricates 3 variations for each option' do
        cat = CatFactory.create! options: 3
        cat.options.map{ |option| option.variations.count }.must_equal [ 3, 3, 3 ]
      end

      it 'ensures the cat has all the corresponding virtual cats for all the variation combinations' do
        cat = CatFactory.create! options: 3
        cat.virtual_cats.count.must_equal 27
      end

    end

  end

  it 'does cleanup' do
    Cat.count.must_equal 0
    CatFactory.create!
    CatFactory.create!
    Cat.count.must_equal 2
    CatFactory.cleanup!
    Cat.count.must_equal 0
  end

end