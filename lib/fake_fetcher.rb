require 'nokogiri'

module SpeciesGuesser

  # Fake fetcher that fetches local data instead of wikipedia pages.
  class FakeFetcher

    # +base_directory+:: The directory where all the fake pages are in.
    def initialize(base_directory)
      @base_directory = base_directory
    end

    def get(link)
      f = File.read(File.join(@base_directory, link.split("/").last))
      Nokogiri::HTML(f)
    end

  end

end
