require 'nokogiri'

module SpeciesGuesser

  # Fake fetcher that fetches local data instead of wikipedia pages.
  class FakeFetcher

    def initialize
      @base_directory = File.join(File.dirname(__FILE__), "pages")
    end

    def get(link)
      f = File.read(File.join(@base_directory, link.split("/").last))
      Nokogiri::HTML(f)
    end

  end

end
