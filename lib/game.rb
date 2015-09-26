require 'answered_question'
require 'cached_crawler'
require 'crawler'
require 'fetcher_chooser'
require 'game_result'
require 'guesser'
require 'strategy_chooser'
require 'taxon'
require 'taxon_ref_constructor'

module SpeciesGuesser

  class Game

    # +stats+:: Stats that have to be updated with game statistics.
    # +asker+:: The oracle that will be used to answer the questions.
    # +options+:: A hash containing the configuration for the game. It should contain at
    #             least the following keys:
    #             +"strategy"+:: String containing the name of the strategy that will be used by the
    #                            computer to play the game.
    #             +"fake_fetcher"+:: Boolean indicating whether or not a fake fetcher should be used to
    #                                fetch local pages instead of real wikipedia pages.
    #             +"start_taxon"+:: String containing the name of the start taxon.
    #             +"debug"+:: Boolean indicating whether or not debug information should be displayed.
    def initialize(stats, asker, options)
      @stats = stats
      @strategy_name = options.strategy
      strategy_chooser = StrategyChooser.new(stats.frequency_counter.accessor)
      strategy = strategy_chooser.choose_strategy(@strategy_name)
      asker.opponent_name = @strategy_name
      fetcher = FetcherChooser::choose_fetcher(options)
      crawler = CachedCrawler.new(Crawler.new(fetcher, options.debug))
      start_taxon_ref = TaxonRefConstructor.construct_taxon_ref(options.start_taxon)
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
      @stats.frequency_counter.increment_path!(solution_taxon)
      @stats.add_number_of_questions(@strategy_name, number_of_questions)
      GameResult.new(solution_taxon, number_of_questions)
    end

  end

end
