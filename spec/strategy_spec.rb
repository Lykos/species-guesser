# -*- coding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'best_subtree_strategy'
require 'fake_fetcher'
require 'fixed_asker'
require 'frequency_counter'
require 'game'
require 'taxon_ref_constructor'
require 'top_down_strategy'
require 'weighted_top_down_strategy'

include SpeciesGuesser

FREQUENCIES = {"Wölfe" => 1, "Füchse" => 2, "Hunde" => 4, "Hundeartige" => 4, "Raubtiere" => 4}
START_TAXON = "Raubtiere"
GUESS_RESULTS = [ 
                 ["Raubtiere", %w()],
                 ["Katzenartige", %w(Raubtiere)],
                 ["Hyänen", %w(Katzenartige Raubtiere)],
                 ["Katzen", %w(Katzenartige Raubtiere)],
                 ["Panther", %w(Katzen Katzenartige Raubtiere)],
                 ["Luchse", %w(Katzen Katzenartige Raubtiere)],
                 ["Hundeartige", %w(Raubtiere)],
                 ["Hunde", %w(Hundeartige Raubtiere)],
                 ["Füchse", %w(Hunde Hundeartige Raubtiere)],
                 ["Wölfe", %w(Hunde Hundeartige Raubtiere)],
                ]

shared_examples "a strategy" do

  def play_game(strategy, asker)
    frequency_counter = FrequencyCounter.new(FREQUENCIES)
    fetcher = FakeFetcher.new
    game = Game.new(frequency_counter, fetcher, START_TAXON, strategy, asker, false)
    game.play
  end

  GUESS_RESULTS.each do |input|

    it "should guess #{input[0]} correctly" do
      asker = FixedAsker.new(input[0], input[1])
      expect(play_game(strategy, asker).taxon_name).to be == input[0]
    end

  end

end

describe TopDownStrategy do

  it_behaves_like "a strategy" do
    let(:strategy) { TopDownStrategy::NAME }
  end

end

describe WeightedTopDownStrategy do

  it_behaves_like "a strategy" do
    let(:strategy) { WeightedTopDownStrategy::NAME }
  end

end

describe BestSubtreeStrategy do

  it_behaves_like "a strategy" do
    let(:strategy) { BestSubtreeStrategy::NAME }
  end

end
