require_relative 'tile.rb'

class Board

    def initialize
        empty_board
        place_bombs
    end

    def [](pos)
        @grid[pos]
    end

    def []=(pos, val)
        @grid[pos] = val
    end

    #creates an empty board full of empty tiles
    def empty_board
        @grid = Array.new(9) {Array.new(9) {Tile.new}}
    end

    #displays current grid w/coordinates
    def render
        puts "  0  1  2  3  4  5  6  7  8  "
        @grid.each_with_index do |row, idx|
            print idx
            row.each {|tile| tile.display}
            puts "\n"
        end
    end

    #iterates through tiles and randomly places bombs
    def place_bombs
        @grid.each do |row|
            row.each do |tile|

                #1/3 chance of tile containinb bomb
                if (0...10).to_a.sample <= 2 
                    tile.bomb = true
                end
            end
        end
    end

    def reveal_all
        @grid.each do |row|
            row.each do |tile|
                tile.explored = true
            end
        end
        render
    end

    def exploded?
        exploded = false
        @grid.each do |row|
            row.each do |tile|
                exploded = true if tile.bomb && tile.explored
            end
        end
        exploded
    end

    def completed?
        @grid.all? do |row|
            row.all? {|tile| !tile.bomb && tile.explored}
        end
    end


end