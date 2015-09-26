require 'answered_question'
require 'cached_crawler'
require 'crawler'
require 'game_result'
require 'guesser'
require 'strategy_chooser'
require 'taxon'
require 'taxon_ref_constructor'

module SpeciesGuesser

  class Game

    # +frequency_counter+:: FrequencyCounter that is to be notified about solutions.
    # +fetcher+:: Object that can fetch wikipedia pages.
    # +start_taxon_name+:: Name of the start taxon.
    # +strategy+:: The strategy that will be used by the computer to play the game.
    # +asker+:: The oracle that will be used to answer the questions.
    # +verbose+:: If this is true, then some components will log their actions and state occasionally.
    def initialize(frequency_counter, fetcher, start_taxon_name, strategy, asker, verbose)
      strategy = StrategyChooser.new(frequency_counter.accessor).choose_strategy(strategy)
      @frequency_counter = frequency_counter
      crawler = CachedCrawler.new(Crawler.new(fetcher, verbose))
      start_taxon_ref = TaxonRefConstructor.construct_taxon_ref(start_taxon_name)
      start_taxon = Taxon.new(crawler, start_taxon_ref)
      @guesser = Guesser.new(start_taxon, strategy)
      @asker = asker
    end

    # Plays the game between the guesser and the asker until a solution taxon is found and
    # returns that solution taxon. It also increments the counts for the solution taxon.
    def play
      solution_taxon = nil
      number_of_questions = 0

      until solution_taxon
        question = @guesser.generate_question
        number_of_questions += 1
        answered_question = AnsweredQuestion.new(question, @asker.ask(question))
        @guesser.apply_answer!(answered_question)
        if question.is_final? and answered_question.answer
          solution_taxon = question.taxon
        end
      end
      @frequency_counter.increment_path!(solution_taxon)
      GameResult.new(solution_taxon, number_of_questions)
    end

  end

end
