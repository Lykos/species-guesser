require 'top_down_strategy'
require 'weighted_top_down_strategy'
require 'best_subtree_strategy'

module SpeciesGuesser

  class StrategyChooser

    STRATEGY_NAMES = [TopDownStrategy::NAME, WeightedTopDownStrategy::NAME, BestSubtreeStrategy::NAME]
    RANDOM = "random"
    STRATEGY_NAMES_WITH_RANDOM = STRATEGY_NAMES + [RANDOM]

    # Chooses a strategy with the given name.
    # +name+:: Name of the strategy to be chosen.
    def self.choose_strategy(name)
      case name.downcase
      when TopDownStrategy::NAME then TopDownStrategy.new
      when WeightedTopDownStrategy::NAME then WeightedTopDownStrategy.new
      when BestSubtreeStrategy::NAME then BestSubtreeStrategy.new
      when RANDOM then random
      else
        raise "Unknown strategy #{name}"
      end
    end

    # Chooses a random strategy.
    def self.random
      choose_strategy(STRATEGY_NAMES.sample)
    end

  end

end
