module SpeciesGuesser

  # Represents a group of sibling taxons.
  class TaxonGroup

    # Neutral element for the name of taxons. This can be used as a fallback if the name cannot
    # be determined and is compatible for joining with all other names.
    NEUTRAL_NAME = 'TAXONS'

    # +level_name+:: The plural of the name of this level of taxons (e.g. "familiae").
    def initialize(level_name, taxons)
      # Replace nil with the neutral name.
      @level_name = level_name || NEUTRAL_NAME
      @taxons = taxons
    end

    # The neutral element for joining taxon groups.
    NEUTRAL_TAXON_GROUP = TaxonGroup.new(NEUTRAL_NAME, [])

    attr_reader :level_name, :taxons

    # Returns true if the taxon group is empty.
    def empty?
      @taxons.empty?
    end

    # Returns true if the taxon group contains one unique taxon.
    def unique?
      length == 1
    end

    # Returns the only taxon of this taxon group. Can only becalled if unique? returns true.
    def only
      raise "The taxon group doesn't contain exactly one element: #{self.inspect}" unless unique?
      @taxons.first
    end

    # Returns the number of taxons.
    def length
      @taxons.length
    end

    # Splits the taxon group into two disjoint taxon groups and returns those two.
    # In case of an uneven length, the second taxon group will be bigger.
    def random_split
      raise 'Cannot split taxon group of length smaller than 2.' if length < 2
      first_group = @taxons.sample(@taxons.length / 2)
      second_group = @taxons - first_group
      [TaxonGroup.new(@level_name, first_group),
       TaxonGroup.new(@level_name, second_group)]
    end

  end

end
