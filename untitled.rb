class TicTacToe
	class Board
		def initialize
			@board = Array.new(3) { Array.new(3) }
			print "Player 1 name: "
			@player1 = Player.new(gets.chomp, "X")
			print "Player 2 name: "
			@player2 = Player.new(gets.chomp, "O")
			puts "Let's Begin."
			go
		end

		def board_setup
			count = 1
			@board.each_with_index do |row, index|
				row.each_with_index do |spot, row_position|
					@board[index][row_position] = count.to_s
					count += 1
				end
			end
		end	

		def print_board
			@board.each_with_index do |row, index|
				print "|  "
				row.each_with_index do |spot, row_position|
					print @board[index][row_position].to_s
					print "  |  "
				end
				print "\n"
			end
		end

		def go
			board_setup
			unless winner?
				print_board
				turn(@player1)
				print_board
				turn(@player2)
			end
		end
	end
	
	def turn(player)
		selection = 0
		while selection < 1 || selection > 9
			print "#{player.name}'s turn. Please choose a space: "
			selection = gets.chomp.to_i
		end
		case selection
		when 1..3
			@board[0][selection-1] = player.symbol
		when 4..6
			@board[1][selection-4] = player.symbol
		when 6..9
			@board[2][selection-7] = player.symbol			
		end
	end

	def winner?
		#returns true if in_a_row? returns true
	end

	def in_a_row?
		#returns true if 3 rows match on board
	end

	class Player
		attr_accessor :name, :symbol
		def initialize(name, symbol)
			@name = name
			@symbol = symbol
		end
	end 

	class Cell
		def initialize(value = "")
			@value = value
		end
	end
end

game = TicTacToe.new