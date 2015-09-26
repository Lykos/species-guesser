require 'fake_fetcher'
require 'mechanize'

module SpeciesGuesser

  class FetcherChooser

    def self.choose_fetcher(options)
      if options.fake_fetcher
        FakeFetcher.new
      else
        Mechanize.new
      end
    end

  end

end
