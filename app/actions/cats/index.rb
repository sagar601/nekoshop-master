class Cats::Index

  def initialize params: {}, cat_repo: CatRepository.new, species_repo: SpeciesRepository.new
    @search_params = params.slice 'species'
    @page = params['page'] || 1
    @cat_repo = cat_repo
    @species_repo = species_repo
  end

  def call
    ActionResult.new cats: cats, all_species: species
  end

  private

  def cats
    @cat_repo.search @search_params, includes: [ :headshot ], page: @page
  end

  def species
    @species_repo.all
  end
end