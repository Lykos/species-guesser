require 'guess_state'
require 'taxon'
require 'taxon_ref'

module SpeciesGuesser

  # The main class that plays the game, i.e. it generates the questions for the user and uses helper classes to find subtaxons of a given taxon.
  class Guesser

    def initialize(start_taxon, strategy, debug)
      @state = GuessState.new(start_taxon, debug)
      @strategy = strategy
    end

    # Generate a question that should be asked to the other player.
    def generate_question
      @strategy.generate_question(@state)
    end

    # Notifies the guesser of the answer of the other player to the last question.
    # +answered_question+:: The question that was asked and its answer.
    def apply_answer!(answered_question)
      @state.apply_answer!(answered_question)
    end

  end

end
