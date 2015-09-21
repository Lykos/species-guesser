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

    # Queries https://species.wikimedia.org for a taxon and finds its subtaxons.
    # +taxon+:: A taxon containing the link of a taxon.
    def get_subtaxons(taxon)
      page = @mechanize.get(LINK_PREFIX + taxon.link)
      @subtaxon_finder.find_subtaxons(page)
    end

    # Queries https://species.wikimedia.org for the toplevel taxons.
    def get_top_taxons
      page = @mechanize.get(LINK_PREFIX)
      @subtaxon_finder.find_top_taxons(page)
    end

  end

end
