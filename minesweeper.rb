require_relative 'board'

class MineSweeper

    def initialize
        @board = Board.new

        # system("clear")
        @board.render
    end

    def run
        turn_counter = 0
        completed = @board.completed?
        exploded = @board.exploded?
        
        #runs until exploded or completed
        until exploded || completed

            pos = get_move
            make_move(pos)

            @board.render
            turn_counter += 1
            completed = @board.completed?
            exploded = @board.exploded?
        end

        #end game message options
        if @board.exploded?
            puts "\nYou are exploded!\n"
            @board.reveal
            puts "\nTry again.\n"
        elsif @board.completed?
            puts "\nYou win! Nice sweeping.\n"
            @board.reveal
            puts "\nNice sweeping.\n"
        end

    end

    #user is prompted to enter coordinates to sweep
    def get_move
        puts "\nenter coordinates (column, row) to sweep: "
        move = gets.chomp

        #exit if user input for coordinates is 'exit'
        exit if move == "exit"

        #reveal if user wants to give up
        if move == 'reveal'
            @board.reveal
            exit
        end

        #parse the move input into an array
        move = move.split(",").map{|num| num.to_i} 
    end

    def make_move(pos)
        x = pos[0]
        y = pos[1]

        #user inputs the explore 'e' or flag 'f' action
        puts "\nenter 'e' to explore or 'f' to add/remove flag: "
        action = gets.chomp

        current_tile = @board[y][x]

        #explore 'e' action tree as long as it is not flagged
        if action == 'e' && !current_tile.flag

            #explore selected tile
            current_tile.explored = true

            #explore adjacent tiles if the selected tile does not explode
            unless @board.exploded?
                explore(pos)
            end

        #flag action tree
        elsif action == 'f'

            #sets tile flag parameter to inverse of boolean value
            @board[y][x].flag = !@board[y][x].flag
        end
    end

    def explore(pos)
        # @board.reveal_adjacent(pos)
        tile_touples = @board.sweep_tile(pos)
        tile_touples.each do |tile_touple|
            tile = tile_touple[0]
            tile.explored = true
        end
    end

    def exit
        abort("\nlater quitter :/\n")
    end

    def valid_pos?
    end

    def valid_action?
    end

end


if __FILE__ == $PROGRAM_NAME

    game = MineSweeper.new
    game.run

end
