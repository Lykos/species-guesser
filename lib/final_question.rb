module SpeciesGuesser

  # Represents a final question on whether the taxon to look for is a given taxon.
  class FinalQuestion

    # +taxon+:: The taxon for which the question should be asked.
    def initialize(taxon)
      @taxon = taxon
    end

    attr_reader :taxon

    # Is this a final question, i.e. will an answer of "yes" end the game? Returns true.
    def is_final?
      true
    end

    # Returns a human readable representation of the question.
    def to_s
      "Is the #{@taxon.level_name} #{@taxon.taxon_name} the wanted taxon?"
    end

  end

end
