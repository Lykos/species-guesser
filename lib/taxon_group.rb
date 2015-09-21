module SpeciesGuesser

  # Represents a group of sibling taxons.
  class TaxonGroup

    # +level_name+:: The plural of the name of this level of taxons (e.g. "familiae").
    def initialize(level_name, taxons)
      @level_name = level_name
      @taxons = taxons
    end

    attr_reader :level_name, :taxons

  end

end
