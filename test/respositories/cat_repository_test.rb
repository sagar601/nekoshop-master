require 'test_helper'

describe CatRepository do

  before do
    Cat.create name: 'Spotty', species: 'spottimus maximus'
    Cat.create name: 'Stripy', species: 'stripeouis fancis'
    Cat.create name: 'Listy', species: 'stripeouis fancis'
    Cat.create name: 'Nulius'

    @repo = CatRepository.new
  end

  describe '#search' do

    it 'searches cats by species using exact match' do
      results = @repo.search species: 'spottimus maximus'
      results.count.must_equal 1
      results.first.name.must_equal 'Spotty'

      results = @repo.search species: 'stripeouis fancis'
      results.all.map(&:name).must_equal ['Stripy', 'Listy']
    end

    it 'returns empty if nothing matches' do
      @repo.search(species: '').count.must_equal 0
    end

    it 'returns empty if there are no cats' do
      Cat.all.each &:destroy!
      @repo.search(species: 'spottimus maximus').count.must_equal 0
    end

    it 'returns something that responds to `includes`' do
      results = @repo.search species: 'spottimus maximus'
      results.respond_to? :includes
    end

    it 'returns something that responds to `page`' do
      results = @repo.search species: 'spottimus maximus'
      results.respond_to? :page
    end

    it 'returns something that responds to `total_count`' do
      results = @repo.search species: 'spottimus maximus'
      results.respond_to? :total_count
    end
  end

  describe '#find' do

    it 'finds cats by id' do
      a_cat = Cat.first

      result = @repo.find a_cat.id
      result.must_equal a_cat
    end

    it 'raises an error if not found' do
      proc{ @repo.find nil }.must_raise ActiveRecord::RecordNotFound
    end
  end

  describe '#all' do

    it 'returns all cats' do
      @repo.all.count.must_equal 4
    end

    it 'returns something that responds to `includes`' do
      @repo.all.respond_to? :includes
    end

    it 'returns something that responds to `page`' do
      @repo.all.respond_to? :page
    end

    it 'returns something that responds to `total_count`' do
      @repo.all.respond_to? :total_count
    end

  end

end