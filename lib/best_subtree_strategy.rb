require 'final_question'
require 'subset_question'
require 'weighted_splitter'

module SpeciesGuesser

  class BestSubtreeStrategy

    NAME = "best_subtree"

    # +frequency_counter+:: The frequency counter that can be queried for the number of times taxons have occurred in the past.
    def initialize(frequency_counter)
      @frequency_counter = frequency_counter
    end

    def name
      NAME
    end

    class ValuedQuestion
      def initialize(question, value)
        @question = question
        @value = value
      end

      attr_reader :question, :value
    end

    def generate_question(state)
      generate_question_internal(state, state.root_taxon).question
    end

    def generate_question_internal(state, root_taxon)
      subtaxons = state.possible_subtaxons(root_taxon)
      chosen_subtaxons = WeightedSplitter::weighted_split(subtaxons) { |t| @frequency_counter.occurrences(t) }
      subset_question_value = weight(subtaxons) - weight(chosen_subtaxons)
      question_values = [
        ValuedQuestion.new(SubsetQuestion.new(root_taxon, chosen_subtaxons), subset_question_value)
      ]
      if state.possible_final_taxon?(root_taxon)
        # TODO The value of final questions is actually higher because you don't only get information,
        # you might win the game. So it should account for how many expected guesses it takes from here.
        final_question_value = @frequency_counter.direct_occurrences(root_taxon)
        question_values.push(ValuedQuestion.new(FinalQuestion.new(root_taxon), final_question_value))
      end
      # If a subtaxon has more frequency than the value of the current question, we might find a better question inside.
      # Note that there can be only one, otherwise there would be a better weighted split.
      candidate_subtaxon = subtaxons.find { |t| @frequency_counter.occurrences(t) > subset_question_value }
      if candidate_subtaxon
        question_values.push(generate_question_internal(state, candidate_subtaxon))
      end
      question_values.max_by { |q| q.value }
    end

    def weight(taxons)
      taxons.map { |t| @frequency_counter.occurrences(t) }.inject(0, :+)
    end

    private :weight

  end

end
