require 'final_question'
require 'subset_question'
require 'weighted_splitter'

module SpeciesGuesser

  class TopDownStrategy

    # +frequency_counter+:: The frequency counter that can be queried for the number of times taxons have occurred in the past.
    def initialize(frequency_counter)
      @frequency_counter = frequency_counter
    end

    def generate_question(state)
      root_taxon = state.root_taxon
      if state.possible_final_taxon?(root_taxon)
        FinalQuestion.new(root_taxon)
      else
        taxons = state.possible_subtaxons(root_taxon)
        taxon_subset = WeightedSplitter::weighted_split(taxons) { |t| @frequency_counter.occurrences(t) }
        SubsetQuestion.new(root_taxon, taxon_subset)
      end
    end

  end

end