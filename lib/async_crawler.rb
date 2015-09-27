require 'concurrent'

module SpeciesGuesser

  # Crawler that uses a thread pool to crawl pages.
  class AsyncCrawler

    def initialize(&create_crawler)
      @create_crawler = create_crawler
      @taxon_info_futures = {}
    end

    # Runs a crawler in a thread pool to fetch the given TaxonRef.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def prepare_taxon_info(taxon_ref)
      @taxon_info_futures[taxon_ref] ||= Concurrent::Promise.execute do
        # Create one crawler per thread in the thread pool.
        crawler = Thread.current[:crawler] ||= @create_crawler.call
        crawler.get_taxon_info(taxon_ref)
      end
    end

    # Waits until one of the underlying crawlers returns a TaxonInfo for the given TaxonRef and returns it.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      prepare_taxon_info(taxon_ref).value
    end

  end

end
