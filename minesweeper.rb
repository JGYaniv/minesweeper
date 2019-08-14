require_relative 'board'
require 'byebug'

class MineSweeper

    def initialize
        @board = Board.new
        system("clear")
        @board.render
    end

    def run
        until @board.exploded? || @board.completed?
            pos = get_move
            make_move(pos)
            system("clear")
            @board.render
        end

        if @board.exploded?
            puts "\nYou are exploded! Try again.\n"
        elsif @board.completed?
            puts "\nYou win! Nice sweeping.\n"
        end

    end

    def get_move
        puts "\nenter coordinate to sweep (x,y): "
        move = gets.chomp
        exit if move == "exit"
        move = move.split(",").map{|num| num.to_i}  
    end

    def make_move(arr)
        x = arr[0]
        y = arr[1]

        puts "\nenter 'e' to explore or 'f' to add/remove flag: "
        action = gets.chomp

        @board[y][x].explored = true if action == 'e'
        @board[y][x].flag = !@board[y][x].flag if action == 'f'
    end

    def exit
        abort("\nlater quitter :/\n")
    end

end


if __FILE__ == $PROGRAM_NAME

    game = MineSweeper.new
    game.run

end