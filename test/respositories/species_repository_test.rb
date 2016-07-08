require 'test_helper'

describe SpeciesRepository do

  before do
    Cat.create name: 'Spotty', species: 'spottimus maximus'
    Cat.create name: 'Stripy', species: 'stripeouis fancis'
    Cat.create name: 'Listy', species: 'stripeouis fancis'
    Cat.create name: 'Nulius'

    @repo = SpeciesRepository.new
  end

  it 'lists all distinct species available' do
    @repo.all.must_equal ['spottimus maximus', 'stripeouis fancis']
  end

  it 'returns empty if there are no cats' do
    Cat.all.each &:destroy!
    @repo.all.count.must_equal 0
  end

end