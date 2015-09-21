module SpeciesGuesser

  # Represents a final question on whether the taxon to look for is a given taxon.
  class FinalQuestion

    def initialize(taxon)
      @taxon = taxon
    end

    # Is this a final question, i.e. will an answer of "yes" end the game? Returns true.
    def is_final?
      true
    end

    # Returns a human readable representation of the question.
    def to_s
      "Is #{@taxon.name} the wanted taxon?"
    end

  end

end
