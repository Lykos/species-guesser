module SpeciesGuesser

  # +final_taxon_name+:: The name of the taxon that is the solution to the game.
  # +super_taxon_names+:: All the supertaxons of the final taxon.
  def initialize(final_taxon_name, super_taxon_names)
    @final_taxon_name = final_taxon_name
    @super_taxon_names = super_taxon_names
  end

  def ask(question)
    if question.is_final?
      question.taxon.name == @final_taxon_name
    else
      question_taxon_names = question.taxons.collect { |t| t.name }
      not (question_taxon_names & @super_taxon_names).empty?
    end
  end

end
