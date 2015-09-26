#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'arg_parser'
require 'crawler'
require 'fetcher_chooser'
require 'taxon_ref_constructor'

include SpeciesGuesser

options = ArgParser.parse(ARGV)
fetcher = FetcherChooser::choose_fetcher(options)
crawler = Crawler.new(fetcher, options.debug)
for taxon_name in ARGV
  taxon = TaxonRefConstructor.construct_taxon_ref(taxon_name)
  p crawler.get_taxon_info(taxon)
end
