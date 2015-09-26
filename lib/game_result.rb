module SpeciesGuesser

  class GameResult

    def initialize(solution_taxon, number_of_questions)
      @solution_taxon = solution_taxon
      @number_of_questions = number_of_questions
    end

    attr_reader :solution_taxon, :number_of_questions

  end

end
