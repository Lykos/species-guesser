module SpeciesGuesser

  # Wrapper around a crawler that caches results.
  class CachedCrawler

    # +crawler+:: The crawler that will be used to fetch actual https://species.wikimedia.org pages when nothing is in the cache.
    def initialize(crawler)
      @crawler = crawler
      @cache = {}
    end

    # Notifies the crawler that the given TaxonRef should be fetched soon.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def prepare_taxon_info(taxon_ref)
      @crawler.prepare_taxon_info(taxon_ref)
    end

    # Queries the underlying crawler for a TaxonInfo.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      @cache[taxon_ref.link] ||= @crawler.get_taxon_info(taxon_ref)
    end

  end

end
