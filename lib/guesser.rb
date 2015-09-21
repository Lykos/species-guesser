require 'crawler'
require 'final_question'
require 'subset_question'
require 'taxon'
require 'taxon_group'

module SpeciesGuesser

  # The main class that plays the game, i.e. it generates the questions for the user and uses helper classes to find subtaxons of a given taxon.
  class Guesser

    START_LEVEL_NAME = "Regna"
    START_TAXON = Taxon.new('Animalia', '/wiki/Animalia')
    
    def initialize
      @crawler = Crawler.new
      @taxon_group = TaxonGroup.new(START_LEVEL_NAME, [START_TAXON])
      @final_asked = false
    end

    # Generate a question that should be asked to the other player.
    def generate_question
      taxons = @taxon_group.taxons
      if taxons.empty?
        raise 'No possible species left.'
      elsif taxons.length == 1 and not @final_asked
        @final_asked = true
        FinalQuestion.new(taxons[0])
      else 
        @final_asked = false
        if taxons.length == 1
          @taxon_group = @crawler.get_subtaxons(taxons[0])
          generate_question
        else
          split_index = taxons.length / 2
          @chosen_taxons = taxons.shuffle[split_index..-1].sort
          SubsetQuestion.new(TaxonGroup.new(@taxon_group.level_name, @chosen_taxons))
        end
      end
    end

    # Notifies the guesser of the answer of the other player to the last question.
    # +answer+:: A boolean indicating whether the answer to the previously asked question was yes.
    def answer_last_question(answer)
      if @final_asked
      elsif answer
        @taxon_group = TaxonGroup.new(@taxon_group.level_name, @chosen_taxons)
      else
        @taxon_group = TaxonGroup.new(@taxon_group.level_name, @taxon_group.taxons - @chosen_taxons)
      end
    end

  end

end
