#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'asker'
require 'cached_crawler'
require 'crawler'
require 'frequency_persistence'
require 'guesser'
require 'taxon'
require 'top_down_strategy'

include SpeciesGuesser

START_TAXON = TaxonRef.new('Animalia', '/wiki/Animalia')
    
persistence = FrequencyPersistence.new
frequency_counter = persistence.load
crawler = CachedCrawler.new(Crawler.new)
start_taxon = Taxon.new(crawler, START_TAXON)
strategy = TopDownStrategy.new(frequency_counter)
guesser = Guesser.new(start_taxon, strategy)
asker = Asker.new
taxon = nil

until taxon
  question = guesser.generate_question
  answered_question = asker.ask(question)
  guesser.apply_answer!(answered_question)
  if question.is_final? and answered_question.answer
    taxon = question.taxon
  end
end

puts "The SpeciesGuesser found the #{taxon.level_name} #{taxon.taxon_name}!"

while taxon
  frequency_counter.increment!(taxon)
  taxon = taxon.super_taxon
end

persistence.save(frequency_counter)
