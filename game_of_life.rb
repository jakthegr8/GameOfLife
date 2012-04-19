#I am considering a cell with neighbours like below.
#
#XXX
#X0X
#XXX
#
#For example lets take the center '0' cell.
#The possible neighbours are be 3 + 2 + 3 = 8 cells
#
#No we will consider the rules.
#
#Any live cell with fewer than two live neighbours dies, as if by loneliness.
#Any live cell with more than three live neighbours dies, as if by overcrowding.
#
#  So the case will be like "0, 1, 4, 5, 6, 7, 8"
#
#Any live cell with two or three live neighbours lives, unchanged, to the next generation.
#
#  So the case will be like "2, 3"
#
#Any dead cell with exactly three live neighbours comes to life.
#
# So the case will be like "3"


class LifeCycleOfCell

    GO_TO_HELL  = [0, 1, 4, 5, 6, 7, 8]
    LIVE        = [2, 3]
    BORN        = [3]

    # Intializing the constant for process
    LIVING_CELL = 1
    DEAD_CELL   = 0

    def self.next_generation(current_life_state, alive_neighbours)
        case current_life_state
        when DEAD_CELL
             (BORN.include? alive_neighbours) ? LIVING_CELL : DEAD_CELL
        when LIVING_CELL
             (GO_TO_HELL.include? alive_neighbours) ? DEAD_CELL : LIVING_CELL
        else
            DEAD_CELL
        end
    end

end

class GameofLife

    def initialize(rows=10, columns=10)
        @rows    = rows
        @columns = columns
        # Initially all were dead cells
        @grid    = Array.new(rows) {Array.new(columns, LifeCycleOfCell::DEAD_CELL)}
    end

    # State is an array of arrays containing points to make alive
    def set_initial_state(state)
        state.each {|x,y| @grid[x][y] = LifeCycleOfCell::LIVING_CELL}
    end

    # Checking the states of generation.
    def next_generation
        new_grid = []
        @grid.each_with_index do |row, x|
            new_row = []
            row.each_with_index do |column, y|
                new_row << LifeCycleOfCell.next_generation(@grid[x][y], alive_neighbours(x,y))
            end
            new_grid << new_row
        end
        @grid = new_grid
    end

    def valid_cell?(row_index, col_index)
      row_index >= 0 && row_index < @rows && col_index >= 0 && col_index < @columns
    end

    def is_not_zero?(x, y)
       !(x.zero? && y.zero?)
    end

    #Checking possible neighbours (3+2+3 = 8 cells)
    def alive_neighbours(row, column)
      # Algorithm for finding neighbours
      # x - 1, y + 1
      # x, y + 1
      # x + 1, y + 1
      #
      # x - 1, y
      # x, y          =>  is_not_zero?(x,y) #=> false
      # x + 1, y
      #
      # x - 1, y - 1
      # x, y - 1
      # x + 1, y - 1

      neighbours = 0
      [-1,0,1].each do |x|
       [-1,0,1].each do |y|
        ri, ci = row + x, column + y
          neighbours += 1 if is_not_zero?(x,y) && valid_cell?(ri, ci) && @grid[ri][ci] == 1 # Living cell
       end
      end
      neighbours
    end

    def to_s
        grid_string = "";
        @grid.each do |row|
                      row.each do |col|
                                  grid_string << col.to_s << " "
                                end
                      grid_string << "\n"
                    end
        customize_cells grid_string
    end

    def customize_cells grid_string
     grid_string.gsub(/1/,"X").gsub(/0/,"-")
    end

end



# You can costumise the grid by changing the input here.
rows = 20
cols = 20
game = GameofLife.new rows,cols



#First Input:
game.set_initial_state([[2,3],[2,4],[3,3],[3,4]])

#Second Input:
game.set_initial_state([[8,8],[8,9],[8,7]])


#Output
puts game.to_s
puts "@ " * cols
loop do # You can also use 'Some condition or Ranges' to limit the loop
    game.next_generation
    puts game.to_s	
    puts "@ " * cols
    sleep(0.5)
end


