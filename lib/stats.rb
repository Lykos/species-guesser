require 'frequency_counter'
require 'game_stats'

module SpeciesGuesser

  # Class that manages all the statistics about the game.
  class Stats

    def initialize(stats)
      @stats = stats
    end

    def frequencies
      @frequencies ||= begin
                         result = @stats[:frequencies] ||= {}
                         result.default = 0
                         result
                       end
    end

    def games
      @games ||= @stats[:games] ||= []
    end

    def frequency_counter
      @frequency_counter ||= FrequencyCounter.new(frequencies)
    end

    def new_game_stats
      result = GameStats.new
      games.push(result.game)
      result
    end

    attr_reader :stats

  end

end
