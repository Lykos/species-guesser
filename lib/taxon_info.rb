module SpeciesGuesser

  # Contains detailed information about a taxon including the name of its level, the name of its subtaxons and its subtaxons.
  # This is the result that is returned after a https://species.wikimedia.org page has been fetched.
  class TaxonInfo

    NEUTRAL_TAXON_NAME_SINGULAR = 'taxon'
    NEUTRAL_TAXON_NAME_PLURAL = 'taxons'

    # +level_name+:: The name of the level of the taxon in singular, e.g. "Familia".
    # +taxon_name+:: The name of the taxon in plural, e.g. "Mammalia".
    # +sublevel_name+:: The name of the level of the subtaxons in plural, e.g. "Familiae".
    # +subtaxons+:: The TaxonRefs representing the subtaxons.
    def initialize(level_name, taxon_name, sublevel_name, subtaxons)
      @level_name = level_name || NEUTRAL_TAXON_NAME_SINGULAR
      @taxon_name = taxon_name
      @sublevel_name = sublevel_name || NEUTRAL_TAXON_NAME_PLURAL
      @subtaxons = subtaxons
    end

    attr_reader :level_name, :taxon_name, :sublevel_name, :subtaxons

    # Creates a new TaxonInfo by merging this object with another taxon info.
    # Raises an error in case of incompatible TaxonInfos, i.e. when the taxon groups, names or level names are incompatible.
    # +other+:: Another TaxonInfo.
    def merge(other)
      level_name = merge_names("level names", NEUTRAL_TAXON_NAME_SINGULAR, @level_name, other.level_name)
      if @taxon_name != other.taxon_name
        raise "Incompatible taxon names #{@taxon_name} and #{other.taxon_name}."
      end
      sublevel_name = merge_names("sublevel names", NEUTRAL_TAXON_NAME_PLURAL, @sublevel_name, other.sublevel_name)
      TaxonInfo.new(level_name, @taxon_name, sublevel_name, @subtaxons + other.subtaxons)
    end

    def merge_names(name_type, neutral_name, *names)
      unique_names = names.select { |n| n != neutral_name }.uniq
      if unique_names.empty?
        neutral_name
      elsif unique_names.size == 1
        unique_names[0]
      else
        raise ArgumentError, "Incompatible #{name_type} '#{unique_names[0]}' and '#{unique_names[1]}'."
      end
    end

  end

end
