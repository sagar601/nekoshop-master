require 'test_helper'

describe Cats::Index do

  cats = Array.new.tap do |array|
    def array.includes *; self; end
    def array.page *; self; end
  end
  species = Array.new

  cat_repo = Monkey.new CatRepository, search: cats
  species_repo = Monkey.new SpeciesRepository, all: species

  it 'returns a list of cats from the cat repository' do
    result = Cats::Index.new(cat_repo: cat_repo, species_repo: species_repo).call

    result.cats.must_equal cats
  end

  it 'returns the list of all cat species from the species repository' do
    result = Cats::Index.new(cat_repo: cat_repo, species_repo: species_repo).call

    result.all_species.must_equal species
  end

end