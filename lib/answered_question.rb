module SpeciesGuesser

  # Class representing a question and its answer.
  class AnsweredQuestion

    # +question+:: The question that was asked.
    # +answer+:: A boolean indicating whether the answer was yes.
    def initialize(question, answer)
      @question = question
      @answer = answer
    end

    attr_reader :question, :answer

  end

end
