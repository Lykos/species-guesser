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
    
    def initialize(frequency_counter)
      @crawler = Crawler.new
      @taxons = TaxonGroup.new(START_LEVEL_NAME, [START_TAXON])
      @frequency_counter = frequency_counter
    end

    # Generate a question that should be asked to the other player.
    def generate_question
      @last_question = generate_question_internal
    end

    def generate_question_internal
      final_asked = @last_question and @last_question.is_final?
      if @taxons.empty?
        raise 'No possible species left.'
      elsif @taxons.unique?
        taxon_info = @crawler.get_subtaxons(@taxons.only)
        @taxons = taxon_info.taxon_group
        FinalQuestion.new(taxon_info)
      else
        # Split into two halves and ask a question to figure out which half it is.
        @unchosen_taxons, @chosen_taxons = @taxons.random_split
        SubsetQuestion.new(@chosen_taxons)
      end
    end

    # Notifies the guesser of the answer of the other player to the last question.
    # +answer+:: A boolean indicating whether the answer to the previously asked question was yes.
    def answer_last_question(answer)
      if @last_question.is_final?
        # We don't get any additional information here except if it ends the game. So nothing happens.
      else
        @taxons = if answer then @chosen_taxons else @unchosen_taxons end
        if @taxons.unique?
          @frequency_counter.count!(@taxons.only)
        end
      end
    end

    private :generate_question_internal

  end

end
