require 'top_down_strategy'
require 'weighted_top_down_strategy'
require 'best_subtree_strategy'

module SpeciesGuesser

  class StrategyChooser

    # +frequency_counter+:: The frequency counter that can be queried for the number of times taxons have occurred in the past.
    def initialize(frequency_counter)
      @frequency_counter = frequency_counter
    end

    STRATEGY_NAMES = [TopDownStrategy::NAME, WeightedTopDownStrategy::NAME, BestSubtreeStrategy::NAME]

    # Chooses a strategy with the given name.
    # +name+:: Name of the strategy to be chosen.
    def choose_strategy(name)
      case name.downcase
      when TopDownStrategy::NAME then TopDownStrategy.new
      when WeightedTopDownStrategy::NAME then WeightedTopDownStrategy.new(@frequency_counter)
      when BestSubtreeStrategy::NAME then BestSubtreeStrategy.new(@frequency_counter)
      when "random" then random
      else
        raise "Unkonwn strategy #{name}"
      end
    end

    # Chooses a random strategy.
    def random
      choose_strategy(STRATEGY_NAMES.sample)
    end

  end

end
