require_relative 'tile.rb'

class Board

    def initialize
        empty_board
        place_bombs
        bomb_counter
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

    #iterates through tiles and randomly places bombs
    def place_bombs
        @grid.each do |row|
            row.each do |tile|

                #1/10 chance of tile containing a bomb
                if (0...10).to_a.sample == 0 
                    tile.bomb = true
                end
            end
        end
    end

    #iterates through tiles, counts adjacent bombs,
    def bomb_counter

        @grid.each_with_index do |row, y|
            row.each_with_index do |tile, x|
                pos = [x, y]
                tiles = adjacent_tiles(pos)
                tiles = tiles.map {|tl| tl[0]}  #selects the tile objects from [tile, pos]
                tile.bomb_count = tiles.count {|adj_tiles| adj_tiles.bomb}
            end
        end


    end

    #displays current grid w/coordinates
    def render

        #prints column headers
        puts "\n\n\n"
        puts "  0  1  2  3  4  5  6  7  8  "

        @grid.each_with_index do |row, idx|

            #prints row tiles & row values using tile#display
            print idx
            row.each {|tile| tile.display}

            puts "\n"
        end
    end

    #reveals all tiles for end game / debugging
    def reveal
        sleep(1.5)
        puts "\n\n\n"
        #system("clear")
        @grid.each do |row|
            row.each do |tile|
                tile.explored = true
            end
        end
        render
    end

    #checks if any mines have been explored, an end game condition
    def exploded?
        exploded = false
        @grid.each do |row|
            row.each do |tile|
                exploded = true if tile.bomb && tile.explored
            end
        end
        exploded
    end

    #checks if all tiles w/out bombs have been explored, an end game condition
    def completed?
        completed = true
        @grid.each do |row|
            row.each do |tile|
                completed = false if !tile.bomb && !tile.explored
            end
        end

        completed
    end

    #returns (directly) adjacent tiles in an array & their coordinate [tile, [pos]]
    def adjacent_tiles(pos)
        x, y = pos.flatten
        debugger unless x && y

        tiles = 
            [
                pos_to_tile([x, y+1]),
                pos_to_tile([x+1, y+1]),
                pos_to_tile([x-1, y-1]),
                pos_to_tile([x+1, y-1]),
                pos_to_tile([x-1, y+1]),
                pos_to_tile([x, y-1]),
                pos_to_tile([x+1, y]),
                pos_to_tile([x-1, y])
            ]
        
        #selects truthy tiles, removing nils
        tiles = tiles.select {|tile_touple| tile_touple.count == 2}
        
    end

    #return [tile, pos] if valid pos, else []
    def pos_to_tile(pos)
        x, y = pos

        #returns empty array if pos is invalid
        return [] unless x && y
        return [] if x >= @grid.length || x < 0
        return [] if y >= @grid.length || y < 0

        [@grid[y][x], [pos]]
    end

    #reveals/explores adjacent tiles as long as they do not have bombs
    def reveal_adjacent(pos)

        tiles = adjacent_tiles(pos)
        tiles.each do |tile, pos|
            tile.explored = true unless tile.bomb
        end
    end

    def sweep_tile(pos)

        x, y = pos.flatten
        debugger unless x && y

        #an attempt to stop the sweeping when a tile has bomb count of more than 0
        current_tile_touple = pos_to_tile(pos)

        tiles = 
            [
                pos_to_tile([x, y+1]),
                pos_to_tile([x+1, y+1]),
                pos_to_tile([x-1, y-1]),
                pos_to_tile([x+1, y-1]),
                pos_to_tile([x-1, y+1]),
                pos_to_tile([x, y-1]),
                pos_to_tile([x+1, y]),
                pos_to_tile([x-1, y])
            ]
        
        #selects tiles that are valid pos & unswept
        tiles = tiles.select {|tile_touple| tile_touple.count == 2}
        tiles = tiles.select {|tile_touple| tile_touple[0].swept == false}

        return tiles if tiles.count == 0

        tiles.each do |tile_touple|
            tile_touple[0].swept = true
        end
        
        tiles = tiles.select {|tile_touple| tile_touple[0].bomb == false}

        more_tiles = []
        tiles.each {|tile_touple| more_tiles += sweep_tile(tile_touple[1]) if tile_touple[0].bomb_count == 0}
        tiles + more_tiles

    end


end
