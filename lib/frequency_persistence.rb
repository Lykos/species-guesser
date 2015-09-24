require 'frequency_counter'
require 'xdg_config'
require 'yaml'

module SpeciesGuesser

  # Class that is responsible for storing and loading frequencies from the file system.
  class FrequencyPersistence

    def initialize
      config = XdgConfig.new
      @frequency_file = config.data.home.to_path + "frequency.yml"
    end

    # Loads the frequencies that taxons occurred from a file and 
    def load
      frequencies = if @frequency_file.exist? then YAML::load(@frequency_file.read) else {} end
      FrequencyCounter.new(frequencies)
    end

    # Saves the given frequencies
    # +frequency_counter+:: A frequency counter, typically one that has been created by the load method earlier.
    def save(frequency_counter)
      frequency_dir = @frequency_file.dirname
      frequency_dir.mkpath unless frequency_dir.exist?
      @frequency_file.open('w') do |f|
        f.puts YAML::dump(frequency_counter.frequencies)
      end
    end

  end

end
