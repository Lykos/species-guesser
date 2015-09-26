#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'commandline_asker'
require 'fetcher_chooser'
require 'frequency_persistence'
require 'game'
require 'arg_parser'

include SpeciesGuesser

options = ArgParser.parse(ARGV)
persistence = FrequencyPersistence.new
frequency_counter = persistence.load
fetcher = FetcherChooser::choose_fetcher(options)
asker = CommandlineAsker.new
game = Game.new(frequency_counter, fetcher, options.start_taxon, options.strategy, asker, options.debug)
game_result = game.play
taxon = game_result.solution_taxon
number_of_questions = game_result.number_of_questions
puts "The SpeciesGuesser found the #{taxon.level_name} #{taxon.taxon_name} in #{number_of_questions} questions!"
persistence.save(frequency_counter)
