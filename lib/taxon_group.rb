module SpeciesGuesser

  # Represents a group of sibling taxons.
  class TaxonGroup

    # Neutral element for the name of taxons. This can be used as a fallback if the name cannot
    # be determined and is compatible for joining with all other names.
    NEUTRAL_TAXON_NAME = 'taxons'

    # +level_name+:: The plural of the name of this level of taxons, e.g. "Familiae".
    def initialize(level_name, taxons)
      # Replace nil with the neutral name.
      @level_name = level_name || NEUTRAL_TAXON_NAME
      @taxons = taxons
    end

    # The neutral element for joining taxon groups.
    NEUTRAL_TAXON_GROUP = TaxonGroup.new(NEUTRAL_TAXON_NAME, [])

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

    # Creates a new TaxonGroup by merging this object with another taxon group.
    # Raises an error in case of incompatible TaxonGroups, i.e. when the level names are incompatible.
    # +other+:: Another TaxonGroup.
    def merge(other)
      if @level_name != NEUTRAL_TAXON_NAME and other.level_name != NEUTRAL_TAXON_NAME and @level_name != other.level_name
        raise "Incompatible level names #{@level_name} and #{other.level_name}."
      end
      level_name = if @level_name == NEUTRAL_TAXON_NAME then other.level_name else @level_name end
      TaxonGroup.new(level_name, @taxons + other.taxons)
    end

  end

end
