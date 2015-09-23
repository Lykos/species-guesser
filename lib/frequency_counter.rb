module SpeciesGuesser

  # Class that keeps track of how many times each species occurs.
  class FrequencyCounter

    # Initializes the frequency counter with the given frequencies.
    # +frequencies+:: Map from taxon names to taxon links and frequencies.
    def initialize(frequencies = {})
      @frequencies = {}
      @frequencies.default = 0
      @frequencies.merge(frequencies)
    end

    attr_reader :frequencies

    # Notifies the frequency counter that a taxon has been encountered, i.e. it was the taxon the user chose or one of its ancestors.
    # +taxon+:: The taxon that was encountered.
    def count!(taxon)
      @frequencies[taxon.name] += 1
    end

    # Returns how many times a given taxon was encountered.
    # +taxon+:: The taxon whose number of occurrences should be returned.
    def occurrences(taxon)
      @frequencies[taxon.name]
    end

  end

end
