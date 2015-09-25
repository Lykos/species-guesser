require 'final_question'
require 'subset_question'
require 'weighted_splitter'

module SpeciesGuesser

  class TopDownStrategy

    NAME = "top_down"
 
    def name
      NAME
    end

    def generate_question(state)
      root_taxon = state.root_taxon
      if state.possible_final_taxon?(root_taxon)
        FinalQuestion.new(root_taxon)
      else
        taxons = state.possible_subtaxons(root_taxon)
        taxon_subset = WeightedSplitter::split(taxons)
        SubsetQuestion.new(root_taxon, taxon_subset)
      end
    end

  end

end
