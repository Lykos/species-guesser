require 'async_crawler'
require 'cached_crawler'
require 'crawler'
require 'fetcher_chooser'

module SpeciesGuesser

  class CrawlerChooser

    def self.choose_crawler(options)
      crawler = if options.concurrent
                  AsyncCrawler.new { create_simple_crawler(options) }
                else
                  create_simple_crawler(options)
                end
      CachedCrawler.new(crawler)
    end

    private

    def self.create_simple_crawler(options)
      fetcher = FetcherChooser::choose_fetcher(options)
      Crawler.new(fetcher, options.debug)      
    end

  end

end
