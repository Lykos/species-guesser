require 'set'

module SpeciesGuesser

  # A class that keeps track of what information we extracted already by asking questions.
  class GuessState

    # +root_taxon+:: The Taxon at which we start.
    def initialize(root_taxon)
      @root_taxon = root_taxon
      @excluded = {}
      @excluded.default_proc = proc { |hash, key| hash[key] = Set.new }
      @final_excluded = Set.new
    end

    attr_reader :root_taxon

    # Returns the possible subtaxons of the given taxon excluding the ones that have been excluded by previous questions.
    # Note that the result of this cannot be cached since future answers may change the result.
    # +taxon+:: The Taxon for which the possible subtaxons should be determined.
    def possible_subtaxons(taxon)
      excluded_subtaxons = @excluded[taxon.taxon_name]
      taxon.subtaxons.select { |t| not excluded_subtaxons.include?(t.taxon_name) }
    end

    # Determines if the given taxon can still be the final answer to a question.
    # Note that the result of this cannot be cached since future answers may change the result.
    # +taxon+:: The Taxon for which it should be determined.
    def possible_final_taxon?(taxon)
      not @final_excluded.include?(taxon.taxon_name)
    end

    # Modifies the state to accomodate for the new information we get from the answer to a question.
    # +question+:: The question that was asked and its answer.
    def apply_answer!(answered_question)
      question = answered_question.question
      answer = answered_question.answer
      if question.is_final?
        taxon = question.taxon
        if not answer
          @final_excluded.add(taxon.taxon_name)
        end
      else
        super_taxon = question.super_taxon
        children = name_set(super_taxon.subtaxons)
        question_taxons = name_set(question.taxons)
        newly_excluded = if answer then children - question_taxons else question_taxons end
        @excluded[super_taxon.taxon_name].merge(newly_excluded)
        # If the user said that it is in a subset of the subtaxons, all the supertaxons are excluded.
        while super_taxon
          @final_excluded.add(super_taxon.taxon_name)
          super_taxon = super_taxon.super_taxon
        end
      end
      # Adjust the root, if we have enough information to do so.
      while (not possible_final_taxon?(@root_taxon)) and
          (root_subtaxons = possible_subtaxons(@root_taxon)).length == 1
        @root_taxon = root_subtaxons[0]
      end
    end

    def name_set(taxons)
      taxons.map { |t| t.taxon_name }.to_set
    end

    def inspect
      "root_taxon=#{@root_taxon.taxon_name} excluded=#{@excluded} final_excluded=#{@final_excluded.inspect}"
    end

    private :name_set

  end

end
