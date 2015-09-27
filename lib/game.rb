require 'answered_question'
require 'crawler_chooser'
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
      strategy = StrategyChooser.choose_strategy(options.strategy)
      @strategy_name = strategy.name
      asker.opponent_name = @strategy_name
      crawler = CrawlerChooser::choose_crawler(options)
      start_taxon_ref = TaxonRefConstructor.construct_taxon_ref(options.start_taxon)
      start_taxon = Taxon.new(crawler, start_taxon_ref, stats.frequency_counter.accessor)
      @guesser = Guesser.new(start_taxon, strategy, options.debug)
      @asker = asker
    end

    # Plays the game between the guesser and the asker until a solution taxon is found and
    # returns that solution taxon. It also increments the counts for the solution taxon.
    def play
      game_stats = @stats.new_game_stats
      game_stats.strategy = @strategy_name
      solution_taxon = nil
      number_of_questions = 0

      until solution_taxon
        question = @guesser.generate_question
        game_stats.add_question(question)
        number_of_questions += 1
        answered_question = AnsweredQuestion.new(question, @asker.ask(question))
        @guesser.apply_answer!(answered_question)
        if question.is_final? and answered_question.answer
          solution_taxon = question.taxon
        end
      end
      
      @stats.frequency_counter.increment_path!(solution_taxon)
      game_stats.solution = solution_taxon
      GameResult.new(solution_taxon, number_of_questions)
    end

  end

end
