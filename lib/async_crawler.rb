require 'concurrent'
require 'thread'

module SpeciesGuesser

  # Crawler that uses a thread pool to crawl pages.
  class AsyncCrawler

    def initialize(frequency_accessor, &create_crawler)
      @frequency_accessor = frequency_accessor
      @create_crawler = create_crawler
      @pool = Concurrent::CachedThreadPool.new
      @taxon_info_futures = {}
      @mutex = Mutex.new
    end

    # Runs a crawler in a thread pool to fetch the given TaxonRef.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def prepare_taxon_info(taxon_ref)
      @mutex.synchronize do
        @taxon_info_futures[taxon_ref] ||=
          Concurrent::Promise.execute(:executor => @pool) do
          # Create one crawler per thread in the thread pool.
          crawler = Thread.current[:crawler] ||= @create_crawler.call
          taxon_info = crawler.get_taxon_info(taxon_ref)
          prepare_important_subtaxons(taxon_info)
          taxon_info
        end
      end
    end

    # Waits until one of the underlying crawlers returns a TaxonInfo for the given TaxonRef and returns it.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      prepare_taxon_info(taxon_ref).value
    end

    private

    # For previously encountered taxons, fetch the children as well
    # because they are likely to be needed.
    def prepare_important_subtaxons(taxon_info)
      if @frequency_accessor.frequency(taxon_info) > 0
        taxon_info.subtaxons.each { |t| prepare_taxon_info(t) }
      end
    end

  end

end
