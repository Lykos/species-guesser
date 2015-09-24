module SpeciesGuesser

  # Basic information about a taxon that suffices to fetch its https://species.wikimedia.org page.
  # This is generated from links to the taxon by supertaxons.
  class TaxonRef

    def initialize(name, link)
      @name = name
      @link = link
    end

    attr_reader :name, :link

    def <=>(other)
      to_a <=> other.to_a
    end

    def to_a
      [@name, @link]
    end

    include Comparable

  end

end
