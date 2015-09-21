module SpeciesGuesser

  # Represents a question on whether the taxon to look for is a subtaxon of a given subset of taxons.
  class SubsetQuestion

    # +taxon_group+:: A TaxonGroup representing the subset of taxons.
    def initialize(taxon_group)
      @taxon_group = taxon_group
    end

    # Is this a final question, i.e. will an answer of "yes" end the game? Returns false.
    def is_final?
      false
    end

    # Returns a human readable representation of the question.
    def to_s
      "Is the wanted taxon among of the following #{@taxon_group.level_name} or their subtaxons?\n" + @taxon_group.taxons.map { |taxon| "- #{taxon.name}\n" }.join
    end

  end

end
