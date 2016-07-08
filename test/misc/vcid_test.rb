require 'test_helper'

describe Vcid do

  describe '#build_all_combinations' do

    it 'builds Vcids to represent all possible Variation combinations for a group of Options' do
      options = [
        Monkey.imitate(Option.new, variation_ids: [ 1, 2, 3 ]),
        Monkey.imitate(Option.new, variation_ids: [ 4, 5 ]),
        Monkey.imitate(Option.new, variation_ids: [ 6, 7 ]),
      ]

      vcids = Vcid.build_all_combinations options

      expected_vcids = ([1, 2, 3].product [4, 5], [6, 7]).map &Vcid.method(:new)

      vcids.count.must_equal expected_vcids.count
      vcids.must_contain expected_vcids
    end

    it 'returns a singular Vcid if the there are no variations' do
      Vcid.build_all_combinations([]).first.singular?.must_equal true

      options = [
        Monkey.imitate(Option.new, variation_ids: []),
        Monkey.imitate(Option.new, variation_ids: []),
      ]

      Vcid.build_all_combinations(options).first.singular?.must_equal true
    end

  end

  it 'knows if a variation or its id is represented by this vcid' do
    vcid = Vcid.new [ 1, 2 ]

    vcid.include?(1).must_equal true
    vcid.include?(2).must_equal true
    vcid.include?(3).must_equal false

    var1 = Variation.new id: 1
    var2 = Variation.new id: 2
    var3 = Variation.new id: 3

    vcid.include?(var1).must_equal true
    vcid.include?(var2).must_equal true
    vcid.include?(var3).must_equal false
  end

  it 'is initialized with an array of variation ids' do
    vcid = Vcid.new [ 1, 2 ]
    vcid.to_a.must_equal [ 1, 2 ]
  end

  it 'is convertible to an array with variation ids sorted ascendingly' do
    vcid = Vcid.new [ 2, 5, 1 ]
    vcid.to_a.must_equal [ 1, 2, 5 ]
  end

  it 'is equal to another vcid if they have the same combination' do
    vcid = Vcid.new [ 1, 2 ]
    other_vcid = Vcid.new [ 1, 2 ]
    different_vcid = Vcid.new [ 3, 2 ]

    assert vcid == other_vcid
    assert vcid.eql? other_vcid
    assert vcid.hash == other_vcid.hash

    refute vcid == different_vcid
    refute vcid.eql? different_vcid
    refute vcid.hash == different_vcid.hash
  end

  it 'is singular if it represents 0 variations' do
    Vcid.new.singular?.must_equal true
    Vcid.new([]).singular?.must_equal true
  end

end