module SpeciesGuesser

  # Contains detailed information about a taxon including the name of its level, the name of its subtaxons and its subtaxons.
  # This is the result that is returned after a https://species.wikimedia.org page has been fetched.
  class TaxonInfo

    NEUTRAL_TAXON_NAME = 'taxon'

    # +level_name+:: The name of the level of the taxon in singular, e.g. "Familia".
    # +taxon_name+:: The name of the taxon in plural, e.g. "Mammalia".
    # +taxon_group+:: The subtaxons including the plural name of the level.
    def initialize(level_name, taxon_name, taxon_group)
      @level_name = level_name || NEUTRAL_TAXON_NAME
      @taxon_name = taxon_name
      @taxon_group = taxon_group
    end

    attr_reader :level_name, :taxon_name, :taxon_group

    # Creates a new TaxonInfo by merging this object with another taxon info.
    # Raises an error in case of incompatible TaxonInfos, i.e. when the taxon groups, names or level names are incompatible.
    # +other+:: Another TaxonInfo.
    def merge(other)
      if @level_name != NEUTRAL_TAXON_NAME and other.level_name != NEUTRAL_TAXON_NAME and @level_name != other.level_name
        raise "Incompatible level names #{@level_name} and #{other.level_name}."
      end
      level_name = if @level_name == NEUTRAL_TAXON_NAME then other.level_name else @level_name end
      if @taxon_name != other.taxon_name
        raise "Incompatible taxon names #{@taxon_name} and #{other.taxon_name}."
      end
      TaxonInfo.new(level_name, @taxon_name, @taxon_group.merge(other.taxon_group))
    end

  end

end
