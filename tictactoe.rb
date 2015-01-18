class TicTacToe
	def initialize
		print "Player 1 name: "
		@player1 = Player.new(gets.chomp, "X")
		print "Player 2 name: "
		@player2 = Player.new(gets.chomp, "O")
		@board = Board.new
		@win_con = false
		@chosen = []
		go
	end

	def go
		while @win_con == false
			@board.print_board
			turn(@player1)
			if @win_con == true
				@board.print_board
				puts "#{@player1.name} wins!"
				break
			end
			if board_full?
				@board.print_board
				puts "Tie game."
				break
			end
			@board.print_board
			turn(@player2)
			if @win_con == true
				@board.print_board
				puts "#{@player2.name} wins!"
				break
			end
			if board_full?
				@board.print_board
				puts "Tie game."
				break
			end
		end
	end

	def board_full?
		flag = true
		@board.layout.each_with_index do |row, index|
			row.each_with_index do |spot, row_position|
				if @board.layout[index][row_position].open == true
					flag = false
				end
			end
		end
		return flag
	end
	def turn(player)
		input = ""
		while (input_valid?(input) == false) && (@chosen.include?(input) == false)
			puts "#{player.name}'s (#{player.symbol}'s) turn, input selection: "
			input = gets.chomp
		end
		@chosen << input
		@board.find_in_board(input, player.symbol)
		test_for_win_con
	end

	def input_valid?(input)
		if input.to_i > 0 && input.to_i < 10
			return true
		else 
			return false
		end
	end

	def test_for_win_con
		if (@board.layout[0][0].value == @board.layout[0][1].value) && (@board.layout[0][0].value == @board.layout[0][2].value)
			@win_con = true
		elsif (@board.layout[1][0].value == @board.layout[1][1].value) && (@board.layout[1][0].value == @board.layout[1][2].value)
			@win_con = true
		elsif (@board.layout[2][0].value == @board.layout[2][1].value) && (@board.layout[2][0].value == @board.layout[2][2].value)
			@win_con = true
		elsif (@board.layout[0][0].value == @board.layout[1][0].value) && (@board.layout[0][0].value == @board.layout[2][0].value)
			@win_con = true
		elsif (@board.layout[0][1].value == @board.layout[1][1].value) && (@board.layout[0][1].value == @board.layout[2][1].value)
			@win_con = true
		elsif (@board.layout[0][2].value == @board.layout[1][2].value) && (@board.layout[0][2].value == @board.layout[2][2].value)
			@win_con = true
		elsif (@board.layout[0][0].value == @board.layout[1][1].value) && (@board.layout[0][0].value == @board.layout[2][2].value)
			@win_con = true
		elsif (@board.layout[0][2].value == @board.layout[1][1].value) && (@board.layout[0][2].value == @board.layout[2][0].value)
			@win_con = true
		end
	end

	class Player
		def initialize(name)
			@name = name
		end
	end

	class Board
		attr_reader :layout
		def initialize
			@layout = Array.new(3) { Array.new(3) }
			count = 1
			@layout.each_with_index do |row, index|
				row.each_with_index do |spot, row_position|
					@layout[index][row_position] = Cell.new(count.to_s)
					count += 1
				end
			end
		end

		def find_in_board(value, entry)
			@layout.each_with_index do |row, index|
				row.each_with_index do |spot, row_position|
					if @layout[index][row_position].value == value
						@layout[index][row_position].value = entry
						@layout[index][row_position].open = false
						break
					end
				end
			end
		end

		def print_board
			@layout.each_with_index do |row, index|
				print "|  "
				row.each_with_index do |spot, row_position|
					print @layout[index][row_position].value
					print "  |  "
				end
				print "\n"
			end
		end
	end

	class Cell
		attr_accessor :open
		def initialize(value = "")
			@value = value
			@open = true
		end

		def value
			return @value.to_s
		end

		def value=(value)
			@value = value
		end
	end

	class Player
		attr_accessor :name, :symbol
		def initialize(name = "default", symbol)
			@name = name
			@symbol = symbol
		end
	end

end

TicTacToe.new