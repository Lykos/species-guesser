# -*- coding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'best_subtree_strategy'
require 'fake_fetcher'
require 'fixed_asker'
require 'frequency_counter'
require 'game'
require 'ostruct'
require 'taxon_ref_constructor'
require 'top_down_strategy'
require 'weighted_top_down_strategy'

include SpeciesGuesser

FREQUENCIES = {"Wölfe" => 1, "Füchse" => 2, "Hunde" => 4, "Hundeartige" => 4, "Raubtiere" => 4}
FREQUENCIES.default = 0
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

  GUESS_RESULTS.each do |input|

    final_taxon_name, super_taxon_names = input

    it "should guess #{final_taxon_name} correctly" do
      frequency_counter = FrequencyCounter.new(FREQUENCIES.dup)
      asker = FixedAsker.new(final_taxon_name, super_taxon_names)
      options = OpenStruct.new
      options.fake_fetcher = true
      options.start_taxon = START_TAXON
      options.debug = false
      options.strategy = strategy
      game = Game.new(frequency_counter, asker, options)
      game_result = game.play
      expect(game_result.solution_taxon.taxon_name).to be == final_taxon_name
      expect(frequency_counter.frequencies[final_taxon_name]).to be == (FREQUENCIES[final_taxon_name] + 1)
      super_taxon_names.each do |super_taxon_name|
        expect(frequency_counter.frequencies[super_taxon_name]).to be == (FREQUENCIES[super_taxon_name] + 1)
      end
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
