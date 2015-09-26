require 'subtaxon_finder'

module SpeciesGuesser

  # Class that can query https://species.wikimedia.org for information on taxons and find their subtaxons.
  class Crawler

    LINK_PREFIX = 'https://species.wikimedia.org'

    # +fetcher+:: The object that will be used to actually fetch the links.
    def initialize(fetcher)
      @fetcher = fetcher
      @subtaxon_finder = SubtaxonFinder.new
    end

    # Queries https://species.wikimedia.org for a taxon and returns a TaxonInfo containing detailed information about it.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      if taxon_ref.link
        page = @fetcher.get(LINK_PREFIX + taxon_ref.link)
        @subtaxon_finder.find_subtaxons(taxon_ref, page)
      else
        # The taxon doesn't have a wikipedia page yet.
        TaxonInfo.new(nil, taxon_ref.name, nil, [])
      end
    end

  end

end
