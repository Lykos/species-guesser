require 'optparse'
require 'ostruct'
require 'strategy_chooser'

module SpeciesGuesser

  class ArgParser

    def self.parse(args)
      options = OpenStruct.new
      options.strategy = StrategyChooser::RANDOM
      options.debug = false
      options.start_taxon = "Animalia"
      options.fake_fetcher = false
      options.concurrent = false

      option_parser = OptionParser.new do |opts|
        strategies = StrategyChooser::STRATEGY_NAMES_WITH_RANDOM
        strategies_list = strategies.join(", ")
        opts.on("-s", "--strategy [STRATEGY]", strategies, "Choose strategy (#{strategies_list})") do |s|
          unless s
            puts "Strategy can only be one of #{strategies_list}."
            exit
          end
          options.strategy = s.downcase
        end

        opts.on("-c", "--[no-]concurrent", "Fetch Wikispecies pages using multiple threads") do |c|
          options.concurrent = c
        end

        opts.on("-d", "--[no-]debug", "Run in debug mode") do |d|
          options.debug = d
        end

        opts.on("-t", "--start_taxon TAXON", "Choose TAXON as the start taxon for the guessing game") do |t|
          options.start_taxon = t
        end

        opts.on("-f", "--[no-]fake_fetcher", "Use a fake fetcher to fetch pages from the pages/ directory instead of real Wikispecies pages.") do |f|
          options.fake_fetcher = f
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
      option_parser.parse!(args)
      options
    end

  end

end
