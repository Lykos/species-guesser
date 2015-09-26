#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'commandline_asker'
require 'frequency_persistence'
require 'game'
require 'mechanize'
require 'arg_parser'
require 'strategy_chooser'

include SpeciesGuesser

options = ArgParser.parse(ARGV)
persistence = FrequencyPersistence.new
frequency_counter = persistence.load
fetcher = Mechanize.new
strategy = StrategyChooser.new(frequency_counter.accessor).choose_strategy(options.strategy)
puts "Chose strategy #{strategy.name}."
asker = CommandlineAsker.new
game = Game.new(frequency_counter, fetcher, strategy, asker)
taxon = game.play
puts "The SpeciesGuesser found the #{taxon.level_name} #{taxon.taxon_name}!"
persistence.save(frequency_counter)
