module Mastermind
	class Game
		attr_accessor :codebreaker, :codesetter, :board, :num_turn
		def initialize ( player_1, player_2 )
			puts "--Mastermind--"
			@codebreaker = player_1
			@codesetter = player_2
			@board = Board.new(self)
			@num_turn = 0
			begin_game
		end

		def begin_game
			loop do
				board.start_turn
				return if board.game_over?
				self.num_turn += 1
			end
		end		

	end

	class Board
		attr_accessor :grid, :code, :game
		def initialize ( game )
			@grid = Array.new(12) { Row.new }
			@code = set_code
			@game = game
		end

		def set_code
			puts valid_colors
			new_code = Row.new ({
				:peg1 => GuessPeg.new(),
				:peg2 => GuessPeg.new(),
				:peg3 => GuessPeg.new(),
				:peg4 => GuessPeg.new()
				})
			puts new_code.show
			return new_code
		end

		def start_turn
			puts "Turn #{turn+1}!"
			grid[turn] = Row.new({
				:peg1 => query_guess( 1 ),
				:peg2 => query_guess( 2 ),
				:peg3 => query_guess( 3 ),
				:peg4 => query_guess( 4 )
				})
			puts grid[turn].show
			self.show_clues
		end

		def query_guess ( peg_num )
			puts "Enter color for position #{peg_num}"
			color = gets.chomp
			GuessPeg.new(color: color)
		end

		def show_clues
			correct_color, correct_position = 0,0
			code.pegs.each_with_index do |code_peg, index|
				if code_peg.color == grid[turn].pegs[index].color
					grid[turn].pegs[index].correct_position = true
					correct_position += 1
					next
				elsif code.pegs_colors.include?(grid[turn].pegs[index].color)
					correct_color += 1 
				end
			end
			puts "You have #{correct_position} pegs with the correct color AND position."
			puts "You have #{correct_color} pegs with the correct color (but incorrect position)!"
		end

		def winner?
			code.equal?(grid[turn])
		end

		def out_of_turns?
			turn == 11 #for 12 turns
		end

		def game_over?
			if winner?
				puts "You broke the code!"
				return true
			end
			if out_of_turns?
				puts "You ran out of turns."
				return true
			end
			return false
		end

		def turn
			game.num_turn
		end


		def valid_colors
			"(valid colors: blue, red, yellow, green, purple, orange)"
		end
	end

	class Row
		attr_accessor :peg1, :peg2, :peg3, :peg4, :pegs
		def initialize( args = {} )
			@peg1 = args.fetch(:peg1, default_peg)
			@peg2 = args.fetch(:peg2, default_peg)
			@peg3 = args.fetch(:peg3, default_peg)
			@peg4 = args.fetch(:peg4, default_peg)
		end

		def pegs
			[peg1, peg2, peg3, peg4]
		end

		def pegs_colors
			[peg1.color, peg2.color, peg3.color, peg4.color]
		end

		def show
			"#{peg1.color} | #{peg2.color} | #{peg3.color} | #{peg4.color}"
		end

		def equal?(test_row)
			flag = true
			test_row.pegs.each_with_index do |test_peg, index|
				unless test_peg.color == self.pegs[index].color
					flag = false
				end
			end
			return flag
		end

		def default_peg
			GuessPeg.new(color: :blank)
		end

	end

	class Peg
	end

	class GuessPeg < Peg
		attr_accessor :color, :correct_position
		def initialize( args = {} )
			@color = args.fetch(:color, random_color)
			@correct_position = false
		end

		def color
			@color.to_s
		end

		def valid_colors
			["blue", "red", "yellow", "green", "purple", "orange"]
		end

		private

		def random_color
			@color = valid_colors[random_number]
		end

		def random_number
			Random.rand(0..5)
		end
	end

	class CluePeg < Peg

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