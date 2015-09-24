require 'mechanize'
require 'subtaxon_finder'

module SpeciesGuesser

  # Class that can query https://species.wikimedia.org for taxons and find their subtaxons.
  class Crawler

    LINK_PREFIX = 'https://species.wikimedia.org'

    def initialize
      @mechanize = Mechanize.new
      @subtaxon_finder = SubtaxonFinder.new
    end

    # Queries https://species.wikimedia.org for a taxon and returns a TaxonInfo containing detailed information about it.
    # +taxon_ref+:: A TaxonRef containing the link of a taxon.
    def get_taxon_info(taxon_ref)
      page = @mechanize.get(LINK_PREFIX + taxon_ref.link)
      @subtaxon_finder.find_subtaxons(page)
    end

    # Queries https://species.wikimedia.org for the toplevel taxons.
    def get_top_taxon_refs
      page = @mechanize.get(LINK_PREFIX)
      @subtaxon_finder.find_top_taxons(page)
    end

  end

end
