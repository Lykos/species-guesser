require 'xdg'

module SpeciesGuesser

  # Helper class to find the directories to store data related to SpeciesGuesser.
  class XdgConfig

    include XDG::BaseDir::Mixin

    def subdirectory
      'species_guesser'
    end

  end

end
