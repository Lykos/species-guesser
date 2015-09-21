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
      @taxons = TaxonGroup.new(START_LEVEL_NAME, [START_TAXON])
    end

    # Generate a question that should be asked to the other player.
    def generate_question
      @last_question = generate_question_internal
    end

    def generate_question_internal
      final_asked = @last_question and @last_question.is_final?
      if @taxons.empty?
        raise 'No possible species left.'
      elsif @taxons.unique? and not final_asked
        FinalQuestion.new(@taxons.only)
      elsif @taxons.unique?
        # We know it is not this taxon itself, but one of its subtaxons, so we have
        # to go one level deeper.
        @taxons = @crawler.get_subtaxons(@taxons.only)
        # Recurse. This terminates because the taxonomy tree is finite.
        generate_question_internal
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
      end
    end

    private :generate_question_internal

  end

end
