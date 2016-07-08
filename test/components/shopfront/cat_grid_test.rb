require 'test_helper'

describe Components::Shopfront::CatGrid do
  using Augmented::Objects

  def build_cats count = 10, total_count = 10
    Array.new(count, Object.new).tack(total_count: total_count)
  end

  it 'has cats' do
    cats = build_cats
    grid = Components::Shopfront::CatGrid.new cats: cats
    grid.cats.must_equal cats
  end

  it 'knows it needs pagination when there are more cats than supplied' do
    many_cats = build_cats 20, 100

    grid = Components::Shopfront::CatGrid.new cats: many_cats
    grid.paginate?.must_equal true

    few_cats = build_cats 20, 20

    grid = Components::Shopfront::CatGrid.new cats: few_cats
    grid.paginate?.must_equal false
  end
end