require 'answered_question'
require 'cached_crawler'
require 'crawler'
require 'guesser'
require 'taxon'

module SpeciesGuesser

  class Game

    # +frequency_counter+:: FrequencyCounter that is to be notified about solutions.
    # +fetcher+:: Object that can fetch wikipedia pages.
    # +start_taxon_ref+:: TaxonRef that is used as the start taxon.
    # +strategy+:: The strategy that will be used by the computer to play the game.
    # +asker+:: The oracle that will be used to answer the questions.
    # +verbose+:: If this is true, then some components will log their actions and state occasionally.
    def initialize(frequency_counter, fetcher, start_taxon_ref, strategy, asker, verbose)
      @frequency_counter = frequency_counter
      crawler = CachedCrawler.new(Crawler.new(fetcher, verbose))
      start_taxon = Taxon.new(crawler, start_taxon_ref)
      @guesser = Guesser.new(start_taxon, strategy)
      @asker = asker
    end

    # Plays the game between the guesser and the asker until a solution taxon is found and
    # returns that solution taxon. It also increments the counts for the solution taxon.
    def play
      solution_taxon = nil

      until solution_taxon
        question = @guesser.generate_question
        answered_question = AnsweredQuestion.new(question, @asker.ask(question))
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
