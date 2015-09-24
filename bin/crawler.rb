#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'crawler'
require 'taxon_ref'

include SpeciesGuesser

crawler = Crawler.new
for name in ARGV
  link = "/wiki/" + name.gsub(/\s/, '_').gsub(/\W+/, '')
  taxon = TaxonRef.new(name, link)
  p crawler.get_taxon_info(taxon)
end
