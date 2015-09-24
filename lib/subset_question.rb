module SpeciesGuesser

  # Represents a question on whether the taxon to look for is a subtaxon of a given subset of taxons.
  class SubsetQuestion

    # +super_taxon+:: The super taxon of the set of taxons for which the question should be asked.
    # +taxons+:: Taxons representing the set of taxons for which the question should be asked.
    def initialize(super_taxon, taxons)
      @super_taxon = super_taxon
      @taxons = taxons.sort_by { |t| t.taxon_name }
    end

    attr_reader :super_taxon, :taxons

    # Is this a final question, i.e. will an answer of "yes" end the game? Returns false.
    def is_final?
      false
    end

    # Returns a human readable representation of the question.
    def to_s
      "Is the wanted taxon among the following #{@super_taxon.sublevel_name} or their subtaxons?\n" +
        @taxons.map { |taxon| "- #{taxon.taxon_name}\n" }.join
    end

  end

end
