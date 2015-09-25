module SpeciesGuesser

  # Class that keeps track of how many times each species occurs.
  class FrequencyCounter

    # Initializes the frequency counter with the given frequencies.
    # +frequencies+:: Map from taxon names to frequencies.
    def initialize(frequencies = {})
      @frequencies = Hash.new(0).merge(frequencies)
    end

    attr_reader :frequencies

    # Notifies the frequency counter that a taxon has been encountered, i.e. it was the taxon the user chose or one of its ancestors.
    # +taxon+:: The Taxon that was encountered.
    def increment!(taxon)
      @frequencies[taxon.taxon_name] += 1
    end

    # Returns how many times a given taxon was encountered.
    # +taxon+:: The Taxon whose number of occurrences should be returned.
    def occurrences(taxon)
      @frequencies[taxon.taxon_name]
    end

    # Returns how many times a given taxon was encountered directly
    # without counting occurrences of its subtaxons.
    # I.e. how many times was this the final solution to the game.
    # +taxon+:: The Taxon whose number of direct occurrences should be returned.
    def direct_occurrences(taxon)
      occurrences(taxon) - taxon.subtaxons.map { |t| occurrences(t) }.inject(0, :+)
    end

  end

end
