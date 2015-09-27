module SpeciesGuesser

  # Faced class that is used to query the taxon tree from https://species.wikimedia.org pages.
  # Internally, it lazily queries pages as soon as they are needed.
  class Taxon

    # +crawler+:: The crawler that will be query https://species.wikimedia.org pages.
    # +taxon_ref+:: The TaxonRef whose information this taxon should fetch and represent.
    # +frequency_accessor+:: The frequency counter that can be queried for the number of times taxons have occurred in the past.
    # +super_taxon+:: The Taxon which is the supertaxon of this taxon.
    def initialize(crawler, taxon_ref, frequency_accessor, super_taxon=nil)
      @crawler = crawler
      @taxon_ref = taxon_ref
      @frequency_accessor = frequency_accessor 
      @super_taxon = super_taxon
      crawler.prepare_taxon_info(taxon_ref)
    end

    attr_reader :super_taxon

    # The name of the level of the taxon in singular, e.g. "Familia".
    def level_name
      @level_name ||= taxon_info.level_name
    end

    # The name of the taxon in plural, e.g. "Mammalia".
    def taxon_name
      @taxon_name ||= taxon_info.taxon_name
    end

    # The level name of the subtaxons in plural, e.g. "Familiae".
    def sublevel_name
      @sublevel_name ||= taxon_info.sublevel_name
    end

    def subtaxons
      @subtaxons ||= taxon_info.subtaxons.collect { |taxon_ref| Taxon.new(@crawler, taxon_ref, @frequency_accessor, self) }
    end

    def taxon_info
      @taxon_info ||= @crawler.get_taxon_info(@taxon_ref)
    end

    def inspect
      @inspect ||= taxon_info.inspect
    end

    def frequency
      @frequency ||= begin
                       @frequency_accessor.frequency(self)
                     end
    end

    def direct_frequency
      @direct_frequency ||= @frequency_accessor.direct_frequency(self)
    end

    private :taxon_info

  end

end
