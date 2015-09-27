require 'final_question'
require 'subset_question'
require 'weighted_splitter'

module SpeciesGuesser

  class BestSubtreeStrategy

    NAME = "best_subtree"

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
      question_value = generate_question_internal(state, state.root_taxon)
      if not question_value
        raise "Unable to generate a question."
      end
      question_value.question
    end

    def generate_question_internal(state, root_taxon)
      question_values = []
      subtaxons = state.possible_subtaxons(root_taxon)
      if subtaxons.length > 1
        chosen_subtaxons = WeightedSplitter::weighted_split(subtaxons) { |t| t.frequency }
        subset_question_value = weight(subtaxons) - weight(chosen_subtaxons)
        question_values.push(ValuedQuestion.new(SubsetQuestion.new(root_taxon, chosen_subtaxons), subset_question_value))
        # If a subtaxon has more frequency than the value of the current question, we might find a better question inside.
        # Note that there can be only one, otherwise there would be a better weighted split.
        candidate_subtaxon = subtaxons.find { |t| t.frequency > subset_question_value }
        if candidate_subtaxon
          question_values.push(generate_question_internal(state, candidate_subtaxon))
        end
      elsif subtaxons.length == 1
        question_values.push(generate_question_internal(state, subtaxons.first))
      end
      if state.possible_final_taxon?(root_taxon)
        # TODO The value of final questions is actually higher because you don't only get information,
        # you might win the game. So it should account for how many expected guesses it takes from here.
        final_question_value = root_taxon.direct_frequency
        question_values.push(ValuedQuestion.new(FinalQuestion.new(root_taxon), final_question_value))
      end
      question_values.compact.max_by { |q| q.value }
    end

    def weight(taxons)
      taxons.map { |t| t.frequency }.inject(0, :+)
    end

    private :weight

  end

end
