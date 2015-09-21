module SpeciesGuesser

  class Taxon

    def initialize(name, link)
      @name = name
      @link = link
    end

    attr_reader :name, :link

    def <=>(other)
      @name <=> other.name
    end

    include Comparable

  end

end
