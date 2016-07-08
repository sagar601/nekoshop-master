require 'test_helper'

describe VirtualCat do

  it 'references a cat, the one its based on' do
    cat = Cat.new
    vc = VirtualCat.new

    vc.cat = cat
    vc.cat.must_equal cat
  end

  it 'takes its name from the original cat' do
    cat = Cat.new name: 'Spotty'

    VirtualCat.new(cat: cat).name.must_equal cat.name
  end

  it 'takes its base price from the original cat' do
    cat = Cat.new price: Money.new(199)

    VirtualCat.new(cat: cat).base_price.must_equal cat.price
  end

  it 'knows its price' do
    cat = Cat.new price: Money.new(199)
    vc = VirtualCat.new cat: cat

    vc.price.must_equal cat.price

    Monkey.imitate vc, options_cost: Money.new(2)
    vc.price.must_equal Money.new(201)
  end

  it 'knows if it is available' do
    vc = VirtualCat.new stock: 0
    vc.available?.must_equal false

    vc = VirtualCat.new stock: 1
    vc.available?.must_equal true
  end

  it 'knows how much the options alone cost' do
    vc = VirtualCat.new

    Monkey.imitate vc, variations: []

    vc.options_cost.must_equal Money.new(0)

    Monkey.imitate vc, variations: [
      Monkey.imitate(Variation.new, cost: Money.new(99)),
      Monkey.imitate(Variation.new, cost: Money.new(2)),
    ]

    vc.options_cost.must_equal Money.new(101)
  end

  describe 'variations' do

    it 'has the Vcid of the variation combination that is unique to it' do
      vc = VirtualCat.new
      vcid = Vcid.new [1,2,3]

      vc.vcid = vcid
      vc.vcid.must_equal vcid
    end

    it 'can get the variations from the parent cat' do
      variations = [ Variation.new(id: 2), Variation.new(id: 3), Variation.new(id: 4) ]
      cat = Monkey.imitate Cat.new, variations: variations
      vc = VirtualCat.new cat: cat, vcid: Vcid.new([2, 4])

      vc.variations.map(&:id).must_equal [2,4]
    end

  end

  it 'is singular if it represents the only version of the parent cat' do
    vc = VirtualCat.new
    vc.vcid = Vcid.new
    vc.singular?.must_equal true

    vc.vcid = Vcid.new [1,2]
    vc.singular?.must_equal false
  end

end