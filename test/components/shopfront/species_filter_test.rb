require 'test_helper'

describe Components::Shopfront::SpeciesFilter do

  let (:dummy_species) { ['lorem', 'ipsum', 'amet'] }
  let (:all_species_text) { Components::Shopfront::SpeciesFilter::ALL_SPECIES_TEXT }

  let (:context) { NullObject.new }

  let (:filter) { Components::Shopfront::SpeciesFilter.new context: context, species: dummy_species }
  let (:empty_filter) { Components::Shopfront::SpeciesFilter.new context: context, species: [] }

  describe '#species (collection)' do

    specify 'first element represents all species' do
      filter.species.first.name.must_equal all_species_text
      empty_filter.species.first.name.must_equal all_species_text
    end

    it 'has all the species provided to the component' do
      assert_contains filter.species.map(&:name), dummy_species

      filter.species.map(&:name).must_contain dummy_species
    end

    describe 'a species (element of the collection)' do

      let(:species) { filter.species.last }

      it ('has a name') { species.must_respond_to :name }
      it ('has an href') { species.must_respond_to :href }
      it ('has classes') { species.must_respond_to :classes }
    end
  end

  describe 'highlighted nav button' do

    it 'is the "All Species" button by default' do
      filter.species.detect{ |s| s.name == all_species_text }.classes.include?('active').must_equal true
    end

    it 'is the species button provided to the component' do
      filter = Components::Shopfront::SpeciesFilter.new context: context, species: dummy_species, current: 'ipsum'

      filter.species.detect{ |s| s.name == 'ipsum' }.classes.include?('active').must_equal true
    end

    specify 'only one species is active at any time' do
      filter.species.select{ |s| s.classes.include?('active') }.count.must_equal 1
    end
  end
end