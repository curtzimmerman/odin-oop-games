module Hangman
	require 'yaml'
	class Game
		attr_accessor :word_to_guess, :status, :remaining_turns, :incorrect_guesses, :save_game_name
		def initialize ( args = {} )
			@word_to_guess = args.fetch(:word_to_guess, get_word_to_guess)
			@status = args.fetch(:status, default_status)
			@remaining_turns = args.fetch(:remaining_turns, 10)
			@incorrect_guesses = args.fetch(:incorrect_guesses, [])
			@save_game_name = ""
			begin_game
		end

		def default_status
			Array.new(word_to_guess.length) { "_" }
		end

		def line_count( file )
			File.foreach(file).inject(0) { |count, line| count + 1 }
		end

		def random_line ( count )
			rand(count)
		end

		def get_phrase_from_file ( file, line_number )
			phrase = ""
			File.open(file).each_with_index do |line, index|
				if index == line_number
					phrase = line
				end
			end
			return phrase
		end

		def get_word_to_guess
			solution = ""
			while !solution.length.between?(5, 12)
				line_number = random_line(line_count("5desk.txt"))
				solution = get_phrase_from_file( "5desk.txt", line_number).strip.downcase
			end
			solution
		end

		def print_status
			print "\n"
			status.each do |letter|
				print "#{letter} "
			end
			puts "\n--- Remaining turns: #{remaining_turns} ---"

		end

		def matches?
			return true if word_to_guess.to_s == status.join
			return false
		end

		def out_of_turns?
			return true if remaining_turns == 0
			return false
		end

		def query_letter ( guess_letter )
			index = 0
			guess_status = false
			word_to_guess.each_char do |letter|
				if letter == guess_letter
					status[index] = guess_letter
					guess_status = true
				end
				index += 1
			end
			return guess_status
		end

		def parse_entry ( guess_letter )
			if guess_letter == "save"
				return :save
			elsif guess_letter == "load"
				return :load
			elsif incorrect_guesses.include?(guess_letter) || status.include?(guess_letter)
				puts "Already guessed that letter, dingus!"
				return :invalid
			elsif guess_letter.length != 1
				puts "One letter, dingus!"
				return :invalid
			end
			return 
		end

		def save_game
			self.save_game_name = "#{Time.now} --- #{status.join}"
			file_name = File.open("save_data.yaml", "a")
			YAML.dump(self, file_name)
			file_name.close
		end

		def load_game
			puts "Enter number for save game: "
			File.open("save_data.yaml", "r") do |yaml_file|
				count = 1
				YAML::load_documents(yaml_file) do |doc|
					puts "#{count}: #{doc.save_game_name}"
					count += 1
				end
			end

			loaded_game_num = gets.chomp
			yaml_doc = YAML::load_stream(File.open("save_data.yaml", "r+"))
			loaded_game = yaml_doc[loaded_game_num.to_i - 1]

			loaded_game_hash = {
				:word_to_guess => loaded_game.word_to_guess,
				:status => loaded_game.status,	
				:remaining_turns => loaded_game.remaining_turns,
				:incorrect_guesses => loaded_game.incorrect_guesses
			}

			yaml_doc[loaded_game_num.to_i - 1] = ""
			YAML::dump_stream(yaml_doc) 			#not working correctly
			Hangman::Game.new(loaded_game_hash)
		end

		def begin_game
			loop do
				if out_of_turns?
					puts word_to_guess
					puts "You Lose."
					break
				end
				self.print_status
				print "Try 'save' or 'load'. \nGuess a letter (incorrect guesses: #{incorrect_guesses.join(",")}): "
				entry = gets.chomp.downcase

				case parse_entry(entry)
				when :invalid
					next
				when :save
					self.save_game
					break
				when :load
					self.load_game
					break
				end

				guess_status = query_letter(entry)

				if guess_status == false
					self.remaining_turns = self.remaining_turns - 1
					incorrect_guesses << entry
				end

				if matches?
					puts word_to_guess
					puts "You Win!"
					break
				end
			end
		end


	end
end

g = Hangman::Game.new()