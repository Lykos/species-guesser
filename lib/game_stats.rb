module SpeciesGuesser

  # Class that is used to collect stats about the game.
  class GameStats

    def initialize
      @game = {:questions => []}
    end

    attr_reader :game

    # +strategy+:: String containing the name of the question strategy that was used in the game.
    def strategy=(strategy)
      @game[:strategy] = strategy
    end

    # +taxon+:: Taxon that was the solution to the game.
    def solution=(taxon)
      @game[:solution] = taxon.taxon_name
    end

    # Notifies the game stats that a question has been asked.
    # +question+:: The question that has been asked.
    def add_question(question)
      if question.is_final?
        @game[:questions].push({:type => :final, :taxon => question.taxon.taxon_name})
      else
        @game[:questions].push({:type => :subset, :taxons => question.taxons.map { |t| t.taxon_name }})
      end
    end

  end

end
