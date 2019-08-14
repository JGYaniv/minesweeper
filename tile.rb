class Tile

    attr_accessor :bomb, :flag, :explored

    def initialize(bomb = false, flag = false, explored = false)
        @bomb = bomb
        @flag = flag
        @explored = explored
    end

    def display
        if @explored == false && @flag == false
            print " * "
        elsif @explored == false && @flag
            print " ^ "
        elsif @explored && @bomb == true
            print " ! "
        elsif @explored
            print " _ "
        end
    end

end