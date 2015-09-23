module SpeciesGuesser

  # Basic information about a taxon. This is generated from linkts to the taxon by supertaxons.
  # It can be used to extract detailed information from the taxon's page itself.
  class Taxon

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
