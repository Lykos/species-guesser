#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'commandline_asker'
require 'fetcher_chooser'
require 'frequency_persistence'
require 'game'
require 'arg_parser'
require 'strategy_chooser'
require 'taxon_ref_constructor'

include SpeciesGuesser

options = ArgParser.parse(ARGV)
persistence = FrequencyPersistence.new
frequency_counter = persistence.load
fetcher = FetcherChooser::choose_fetcher(options)
strategy = StrategyChooser.new(frequency_counter.accessor).choose_strategy(options.strategy)
puts "Chose strategy #{strategy.name}."
asker = CommandlineAsker.new
start_taxon = TaxonRefConstructor.construct_taxon_ref(options.start_taxon)
game = Game.new(frequency_counter, fetcher, start_taxon, strategy, asker, options.debug)
taxon = game.play
puts "The SpeciesGuesser found the #{taxon.level_name} #{taxon.taxon_name}!"
persistence.save(frequency_counter)
