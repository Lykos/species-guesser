require 'frequency_counter'

module SpeciesGuesser

  # Class that manages all the statistics about the game.
  class Stats

    def initialize(stats)
      @stats = stats
    end

    def frequencies
      @frequencies ||= frequencies_internal
    end

    def frequencies_internal
      result = @stats[:frequencies] ||= {}
      result.default = 0
      result
    end

    def number_of_questions
      @number_of_questions ||= number_of_questions_internal
    end

    def number_of_questions_internal
      result = @stats[:number_of_questions] ||= {}
      result.default_proc = proc { |hash, key| hash[key] = [] }
      result
    end

    private :number_of_questions_internal, :frequencies_internal

    # Notifies the Stats that the game has been won by the given strategy in the given number of questions.
    # +strategy+:: The strategy that won the game.
    # +number+:: The number of questions it needed.
    def add_number_of_questions(strategy, number)
      number_of_questions[strategy].push(number)
    end

    def frequency_counter
      @frequency_counter ||= FrequencyCounter.new(frequencies)
    end

    attr_reader :stats

  end

end
