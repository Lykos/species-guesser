require 'cached_crawler'
require 'crawler'
require 'guesser'
require 'taxon'

module SpeciesGuesser

  class Game

    START_TAXON = TaxonRef.new('Animalia', '/wiki/Animalia')

    # +frequency_counter+:: FrequencyCounter that is to be notified about solutions.
    # +fetcher+:: Object that can fetch wikipedia pages.
    # +strategy+:: The strategy that will be used by the computer to play the game.
    # +asker+:: The oracle that will be used to answer the questions.
    def initialize(frequency_counter, fetcher, strategy, asker)
      @frequency_counter = frequency_counter
      crawler = CachedCrawler.new(Crawler.new(fetcher))
      start_taxon = Taxon.new(crawler, START_TAXON)
      @guesser = Guesser.new(start_taxon, strategy)
      @asker = asker
    end

    # Plays the game between the guesser and the asker until a solution taxon is found and
    # returns that solution taxon. It also increments the counts for the solution taxon.
    def play
      solution_taxon = nil

      until solution_taxon
        question = @guesser.generate_question
        answered_question = @asker.ask(question)
        @guesser.apply_answer!(answered_question)
        if question.is_final? and answered_question.answer
          solution_taxon = question.taxon
        end
      end
      @frequency_counter.increment_path!(solution_taxon)
      solution_taxon
    end

  end

end
