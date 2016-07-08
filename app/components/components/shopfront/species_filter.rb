class Components::Shopfront::SpeciesFilter
  using Augmented::Symbols

  ALL_SPECIES_TEXT = I18n.t 'components.shopfront.species_filter.all_species'

  def initialize context:, species:, current: ALL_SPECIES_TEXT
    @species = SpeciesCollection.new(species, context).tap &:highlight.with(current || ALL_SPECIES_TEXT)
  end

  attr_reader :species


  class SpeciesCollection < Array
    def initialize names, context
      super names.map{ |name| Species.new name, context }.unshift(AllSpecies.new context)
    end

    def highlight name
      detect{ |s| s.name == name }.highlight
    end
  end


  class Species
    def initialize species, context
      @name = species
      @href = context.cats_path species: @name
      @classes = Set.new
    end

    attr_reader :name, :href

    def classes
      @classes.to_a.join(' ')
    end

    def highlight
      @classes << 'active'
    end
  end


  class AllSpecies < Species
    def initialize context
      super ALL_SPECIES_TEXT, context
      @href = context.cats_path
    end
  end
end
