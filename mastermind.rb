module Mastermind
	class Game
		attr_accessor :codebreaker, :codesetter, :board, :num_turn
		def initialize ( player_1, player_2 )
			@codebreaker = player_1
			@codesetter = player_2
			@board = Board.new
			@num_turn = 0
			@gametype = 0
			begin_game
		end

		def begin_game
			puts "--Mastermind--"
			board.set_code(codesetter)
			puts board.show_code
			until board.code.inspect == board.grid[num_turn-1].inspect || num_turn >= 12
				board.enter_guess(codebreaker, num_turn)
				self.num_turn += 1
			end
		end		

	end

	class Board
		attr_accessor :grid, :code
		def initialize
			@grid = Array.new(12) { Row.new() }
			@code = Row.new()
		end

		def set_code ( player )
			puts "Code to be broken:"
			puts valid_colors
			new_code = []
			code.pegs.each_with_index do |peg, index|
				print "Enter color choice for spot #{index+1}: "
				code.pegs[index] = gets.chomp
			end
		end

		def show_code
			code.show
		end

		def enter_guess ( player, num_turn )
			puts "Turn #{num_turn+1}: \n" + valid_colors
			grid[num_turn].pegs.each_with_index do |peg, index|
				print "Enter color choice for spot #{index+1}: "
				grid[num_turn].pegs[index] = gets.chomp
			end
		end

		def valid_colors
			"(valid colors: blue, red, yellow, green, purple, orange)"
		end
	end

	class Row
		attr_accessor :pegs
		def initialize( args = {} )
			@pegs = [args.fetch(:peg1, " "), args.fetch(:peg2, " "), args.fetch(:peg3, " "), args.fetch(:peg4, " ")]
		end

		def show
			[pegs[0], pegs[1], pegs[2], pegs[3]].inspect
		end

		def equal?

		end
	end


	class Player

	end

	class HumanPlayer < Player
		def initialize

		end
	end

	class ComputerPlayer < Player

	end

end

Mastermind::Game.new( Mastermind::HumanPlayer.new, Mastermind::HumanPlayer.new)