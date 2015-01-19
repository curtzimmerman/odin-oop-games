module TicTacToe
	class Game
		attr_accessor :player1, :player2, :board
		def initialize(board, player_1_object, player_2_object)
			@player1 = player_1_object
			@player2 = player_2_object
			@board = board
			begin_game
		end

		private

		def begin_game
			puts "#{player1.name}(#{player1.value}'s) vs #{player2.name}(#{player2.value}'s)!"
			while board.game_over == false do
				turn(player1)
				break if board.game_over == :winner
				break if board.game_over == :draw
				turn(player2)
			end
			board.print_board
		end

		def check_game_state( player )
			if board.game_over == :winner
				puts "#{player.name} wins!"
				return
			elsif board.game_over == :draw
				puts "Tie Game."
				return
			end
		end

		def turn(player)
			board.print_board
			position = ""
			puts "#{player.name}'s turn (#{player.value}'s) - Enter a position: "
			position = gets.chomp
			board.entry(player.value, position)
			check_game_state(player)
		end

	end

	class Board
		attr_accessor :grid
		def initialize( ) 
			@grid = Array.new(3) { Array.new(3) { Cell.new } }
			grid_setup(grid)
		end

		def print_board
			grid.each_with_index do |row, row_index|
				print "| "
				row.each_with_index do |col, col_index|
					print grid[row_index][col_index].value
					print " | "
				end
				print "\n"
			end
		end

		def entry(value, position)
			grid.each_with_index do |row, row_index|
				row.each_with_index do |col, col_index|
					if grid[row_index][col_index].value.to_s == position.to_s
						grid[row_index][col_index].value = value
						grid[row_index][col_index].filled = true
					end
				end
			end
		end

		def game_over
			return :winner if winner?
			return :draw if draw?
			false
		end

		private

		def grid_setup(grid)
			count = 1
			grid.each_with_index do |row, row_index|
				row.each_with_index do |col, col_index|
					grid[row_index][col_index].value = count
					count += 1
				end
			end
		end

		def winner?
			if (grid[0][0].value == grid[0][1].value) && (grid[0][0].value == grid[0][2].value)
				return true
			elsif (grid[1][0].value == grid[1][1].value) && (grid[1][0].value == grid[1][2].value)
				return true
			elsif (grid[2][0].value == grid[2][1].value) && (grid[2][0].value == grid[2][2].value)
				return true
			elsif (grid[0][0].value == grid[1][0].value) && (grid[0][0].value == grid[2][0].value)
				return true
			elsif (grid[0][1].value == grid[1][1].value) && (grid[0][1].value == grid[2][1].value)
				return true
			elsif (grid[0][2].value == grid[1][2].value) && (grid[0][2].value == grid[2][2].value)
				return true
			elsif (grid[0][0].value == grid[1][1].value) && (grid[0][0].value == grid[2][2].value)
				return true
			elsif (grid[0][2].value == grid[1][1].value) && (grid[0][2].value == grid[2][0].value)
				return true
			end
		end

		def draw?
			flag = true
			grid.each_with_index do |row, row_index|
				row.each_with_index do |col, col_index|
					flag = false if col.filled == false
				end
			end
			return flag
		end
	end

	class Cell
		attr_accessor :value, :filled
		def initialize( value = "")
			@value = value
			@filled = false
		end
	end

	class Player
		attr_accessor :name, :value
		def initialize( name = "unnamed", value )
			@name = name
			@value = value
		end
	end

end

TicTacToe::Game.new(TicTacToe::Board.new, TicTacToe::Player.new("Curt", "X"), TicTacToe::Player.new("Test", "O"))