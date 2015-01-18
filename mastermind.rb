module Mastermind
	class Game
		def initialize(player_1_class, player_2_class)
			@board = Array.new(12) { Row.new }
			@solution = Row.new
		end
	end

	class Player
		def initialize(name)
			@name = name
		end
	end

	class HumanPlayer < Player
		def initialize
			print "Player name: "
			@name = gets.chomp
		end
	end

	class ComputerPlayer < Player

	end

	class Row
		def initialize
		end

		def ==(row)

		end
	end

	class Peg
		
	end

	class CodePeg < Peg
		def initialize(color, row_location)
			@color = color
			@row_location = row_location
		end
	end

	class KeyPeg < Peg
		def initialize(color)
			@color = color
	end
end

Mastermind::Game.new(Mastermind::HumanPlayer.new)