#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'crawler'
require 'taxon'

include SpeciesGuesser

crawler = Crawler.new
puts "Taxon?"
name = "Animalia"
link = "/wiki/" + name.gsub(/\s/, '_').gsub(/\W+/, '')
taxon = Taxon.new(name, link)
p crawler.get_subtaxons(taxon)
