#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'commandline_asker'
require 'stats_persistence'
require 'game'
require 'arg_parser'

include SpeciesGuesser

options = ArgParser.parse(ARGV)
persistence = StatsPersistence.new(options.debug)
stats = persistence.load
asker = CommandlineAsker.new
game = Game.new(stats, asker, options)
game_result = game.play
taxon = game_result.solution_taxon
number_of_questions = game_result.number_of_questions
puts "The SpeciesGuesser found the #{taxon.level_name} #{taxon.taxon_name} in #{number_of_questions} questions!"
persistence.save(stats)
