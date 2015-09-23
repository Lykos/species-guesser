#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'asker'
require 'guesser'
require 'frequency_persistence'

include SpeciesGuesser

persistence = FrequencyPersistence.new
frequency_counter = persistence.load
guesser = Guesser.new(frequency_counter)
asker = Asker.new

found = false

until found
  question = guesser.generate_question
  answer = asker.ask(question)
  guesser.answer_last_question(answer)
  found = (question.is_final? and answer)
end

puts "The SpeciesGuesser found the species!"
persistence.save(frequency_counter)
