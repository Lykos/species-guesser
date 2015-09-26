require 'final_question'
require 'subset_question'
require 'weighted_splitter'

module SpeciesGuesser

  class WeightedTopDownStrategy

    NAME = "weighted_top_down"

    # +frequency_accessor+:: The frequency counter that can be queried for the number of times taxons have occurred in the past.
    def initialize(frequency_accessor)
      @frequency_accessor = frequency_accessor
    end

    def name
      NAME
    end

    def generate_question(state)
      root_taxon = state.root_taxon
      if state.possible_final_taxon?(root_taxon)
        FinalQuestion.new(root_taxon)
      else
        taxons = state.possible_subtaxons(root_taxon)
        taxon_subset = WeightedSplitter::weighted_split(taxons) { |t| @frequency_accessor.occurrences(t) }
        SubsetQuestion.new(root_taxon, taxon_subset)
      end
    end

  end

end
