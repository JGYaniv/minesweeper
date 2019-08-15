class Tile

    attr_accessor :bomb, :flag, :explored, :bomb_count

    def initialize(bomb = false, flag = false, explored = false)
        @bomb = bomb
        @flag = flag
        @explored = explored
        @bomb_count = 0
        @pos = nil
    end

    def display
        if @explored == false && @flag == false
            print " * "
        elsif @explored == false && @flag
            print " ^ "
        elsif @explored && @bomb == true
            print " ! "
        elsif @explored && @bomb_count > 0
            print " #{bomb_count} "
        elsif @explored
            print " - "
        end
    end

end