module SpeciesGuesser

  # Represents a final question on whether the taxon to look for is a given taxon.
  class FinalQuestion

    # +taxon_info+:: A TaxonInfo with detailed information about the taxon.
    def initialize(taxon_info)
      @taxon_info = taxon_info
    end

    # Is this a final question, i.e. will an answer of "yes" end the game? Returns true.
    def is_final?
      true
    end

    # Returns a human readable representation of the question.
    def to_s
      "Is the #{@taxon_info.level_name} #{@taxon_info.taxon_name} the wanted taxon?"
    end

  end

end
