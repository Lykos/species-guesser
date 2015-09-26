require 'optparse'
require 'ostruct'
require 'strategy_chooser'

module SpeciesGuesser

  class ArgParser

    def self.parse(args)
      options = OpenStruct.new
      options.strategy = StrategyChooser::RANDOM
      options.debug = false

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

        opts.on("-d", "--[no-]debug", "Run in debug mode") do |d|
          options.debug = d
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
