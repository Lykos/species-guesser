module SpeciesGuesser

  # Class that is responsible for asking a question to the user and getting an answer.
  class CommandlineAsker

    YES = ["j", "ja", "y", "yes"]
    NO = ["n", "nein", "n", "no"]

    def ask(question)
      loop do 
        puts question
        answer = gets.chomp.downcase.gsub(/\W/, '')
        if YES.include?(answer)
          return true
        elsif NO.include?(answer)
          return false
        else
          puts 'I did not understand that answer. Please answer with "yes" or "no".'
        end
      end
    end

    def opponent_name=(name)
      puts "You are playing against #{name}."
    end

  end

end
