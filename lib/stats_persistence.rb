require 'stats'
require 'xdg_config'
require 'yaml'

module SpeciesGuesser

  # Class that is responsible for storing and loading frequencies from the file system.
  class StatsPersistence

    def initialize(debug)
      @debug = debug
      config = XdgConfig.new
      # Note that this is not a string plus but a path plus.
      @stats_file = config.data.home.to_path + "stats.yml"
    end

    # Loads the frequencies that taxons occurred from a file and 
    def load
      stats = if @stats_file.exist? then YAML::load(@stats_file.read) else {} end
      if @debug
        puts "Loaded stats #{stats}."
      end
      Stats.new(stats)
    end

    # Saves the given frequencies
    # +stats_counter+:: A stats counter, typically one that has been created by the load method earlier.
    def save(stats)
      stats_dir = @stats_file.dirname
      stats_dir.mkpath unless stats_dir.exist?
      saved_stats = YAML::dump(stats.stats)
      if @debug
        puts "Saving stats #{saved_stats}."
      end
      @stats_file.open('w') do |f|
        f.puts saved_stats
      end
    end

  end

end
