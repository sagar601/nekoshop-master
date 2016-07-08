require 'test_helper'

require_relative '../test_support/factories/cat_factory'

describe Cat do

  it 'has a name' do
    cat = Cat.new
    cat.name = 'Whiskers'
    cat.name.must_equal 'Whiskers'
  end

  it 'has a species' do
    cat = Cat.new
    cat.species = 'felinius'
    cat.species.must_equal 'felinius'
  end

  it 'has a summary' do
    cat = Cat.new
    cat.summary = 'lorem ipsum'
    cat.summary.must_equal 'lorem ipsum'
  end

  it 'has a description' do
    cat = Cat.new
    cat.description = 'lorem ipsum'
    cat.description.must_equal 'lorem ipsum'
  end

  it 'has a price' do
    price = Money.new 999
    cat = Cat.new

    cat.price = price
    cat.price.must_equal price
  end

  it 'has photos' do
    cat = Cat.new
    photo1 = CatPhoto.new
    photo2 = CatPhoto.new

    cat.photos = []
    cat.photos << photo1 << photo2
    cat.photos.must_equal [photo1, photo2]
  end

  it 'has virtual_cats' do
    cat = Cat.new
    vc1 = VirtualCat.new
    vc2 = VirtualCat.new

    cat.virtual_cats = []
    cat.virtual_cats << vc1 << vc2
    cat.virtual_cats.must_equal [vc1, vc2]
  end

  describe '#headshot' do

    it 'returns the first photo marked as headshot' do
      cat = Cat.create name: 'dummy'
      photo1 = CatPhoto.new
      photo2 = CatPhoto.new headshot: true
      photo3 = CatPhoto.new

      cat.photos = [photo1, photo2, photo3]

      cat.headshot.must_equal photo2

      Cat.all.each &:destroy!
    end

    it 'returns a fallback photo if the cat has no photos' do
      cat = Cat.new
      cat.headshot.fallback?.must_equal true
    end
  end

  it 'is available if any of its virtual cats are available' do
    available_vc = Monkey.imitate VirtualCat.new, available?: true
    unavailable_vc = Monkey.imitate VirtualCat.new, available?: false

    cat = Cat.new virtual_cats: [available_vc]
    cat.available?.must_equal true

    cat = Cat.new virtual_cats: [unavailable_vc, available_vc]
    cat.available?.must_equal true

    cat = Cat.new virtual_cats: [unavailable_vc, unavailable_vc]
    cat.available?.must_equal false

    cat = Cat.new virtual_cats: []
    cat.available?.must_equal false
  end

  it 'has options' do
    options = [ Option.new, Option.new ]
    cat = Cat.new

    cat.options = options
    cat.options.must_equal options
  end

  it 'knows all variations of its options' do
    cat = CatFactory.create! options: 3
    variations = cat.options.flat_map &:variations

    cat.variations.count.must_equal variations.count
    cat.variations.to_a.must_contain variations
  end

  describe '#sync_virtual_cats!' do

    it 'ensures the cat has one virtual cat for each variation combination' do
      cat = CatFactory.create! options: 2
      cat.sync_virtual_cats!

      ids = cat.options.map &:variation_ids
      combos = ids.first.product *ids[1..-1]

      cat.virtual_cats.count.must_equal combos.count
      cat.virtual_cats.map(&:vcid).map(&:to_a).must_contain combos
    end

    it 'ensures the cat has 1 singular virtual cat if there are no variations' do
      cat = CatFactory.create! options: 0
      cat.virtual_cats.count.must_equal 1
      cat.virtual_cats.first.singular?.must_equal true
    end

  end

  it 'knows its total stock' do
    Cat.new.stock.must_equal 0

    vc1 = Monkey.imitate VirtualCat.new, stock: 10
    vc2 = Monkey.imitate VirtualCat.new, stock: 20
    cat = Cat.new virtual_cats: [vc1, vc2]

    cat.stock.must_equal 30
  end

end