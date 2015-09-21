#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'asker'
require 'guesser'

include SpeciesGuesser

guesser = Guesser.new
asker = Asker.new

found = false

until found
  question = guesser.generate_question
  answer = asker.ask(question)
  guesser.answer_last_question(answer)
  found = (question.is_final? and answer)
end

puts "The SpeciesGuesser found the species!"
