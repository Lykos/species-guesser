require 'frequency_accessor'

module SpeciesGuesser

  # Class that keeps track of how many times each species occurs. It can also increment the count.
  class FrequencyCounter < FrequencyAccessor

    # Notifies the frequency counter that a taxon has been encountered, i.e. it was the taxon the user chose or one of its supertaxons.
    # +taxon+:: The Taxon that was encountered.
    def increment!(taxon)
      @frequencies[taxon.taxon_name] += 1
    end

    # Notifies the frequency counter that a taxon was the taxon the user chose and increments all the supertaxons.
    # +taxon+:: The Taxon that was encountered.
    def increment_path!(taxon)
      while taxon
        increment!(taxon)
        taxon = taxon.super_taxon
      end
    end

    # Returns a FrequencyAccessor that can also access the counts, but not change them.
    def accessor
      @accessor ||= FrequencyAccessor.new(@frequencies)
    end

  end

end
