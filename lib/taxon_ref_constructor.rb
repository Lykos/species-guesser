require 'taxon_ref'
require 'uri'

module SpeciesGuesser

  class TaxonRefConstructor

    def self.construct_taxon_ref(taxon_name)
      TaxonRef.new(taxon_name, "/wiki/" + URI::encode(taxon_name))
    end

  end

end
