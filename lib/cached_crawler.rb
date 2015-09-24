module SpeciesGuesser

  # Wrapper around a crawler that caches results.
  class CachedCrawler

    # +crawler+:: The crawler that will be used to fetch actual https://species.wikimedia.org pages when nothing is in the cache.
    def initialize(crawler)
      @crawler = crawler
      @cache = {}
    end    

    # Queries https://species.wikimedia.org for a taxon and returns a TaxonInfo containing detailed information about it.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      @cache[taxon_ref.link] ||= @crawler.get_taxon_info(taxon_ref)
    end

  end

end
