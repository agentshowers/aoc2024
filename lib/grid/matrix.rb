require './lib/base.rb'

module Grid
  module Matrix
    UP = 0
    DOWN = 1
    LEFT = 2
    RIGHT = 3
    DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
    VERTICALS = [[1,0], [0, 1], [-1, 0], [0, -1]].freeze
    ALL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
    OUT_OF_BOUNDS = nil

    def init_grid(lines, int: false, padding: true)
      out_of_bounds = int ? -1 : "@"
      @grid = []
      @grid << Array.new(lines[0].length + 2) { out_of_bounds } if padding
      @grid += lines.map do |line|
        elements = line.chars
        elements = elements.map(&:to_i) if int
        elements = [out_of_bounds] + elements + [out_of_bounds] if padding
        elements
      end
      @grid << Array.new(lines[0].length + 2) { out_of_bounds } if padding
    end

    def width
      @width ||= @grid[0].length
    end

    def height
      @height ||= @grid.length
    end

    def max_x
      @max_x ||= width - 1
    end

    def max_y
      @max_y ||= height - 1
    end

    def in_bounds?(x, y)
      x >= 0 && x <= max_x && y >= 0 && y <= max_y
    end

    def border?(x, y)
      x == 0 || y == 0 || x == max_x || y == max_y
    end

    def turn_right(dir)
      return RIGHT if dir == UP
      return DOWN if dir == RIGHT
      return LEFT if dir == DOWN
      return UP if dir == LEFT
    end

    def reverse(dir)
      return DOWN if dir == UP
      return LEFT if dir == RIGHT
      return UP if dir == DOWN
      return RIGHT if dir == LEFT
    end

    def travel
      (0..max_x).each do |x|
        (0..max_y).each do |y|
          yield(x, y, @grid[x][y])
        end
      end
    end

    def find(elem)
      (0..max_x).each do |x|
        (0..max_y).each do |y|
          return [x, y] if @grid[x][y] == elem
        end
      end
    end

    def find_multiple(elem)
      points = []
      (0..max_x).each do |x|
        (0..max_y).each do |y|
          points << [x, y] if @grid[x][y] == elem
        end
      end
      points
    end

    def neighbors(x, y)
      VERTICALS.map do |dx, dy|
        nx, ny = [x + dx, y + dy]
        [nx, ny] if in_bounds?(nx, ny)
      end.compact
    end

    def apply_dir(x, y, dir)
      case dir
      when UP
        x -= 1
      when DOWN
        x += 1
      when LEFT
        y -= 1
      when RIGHT
        y += 1
      end
      [x, y]
    end
  end
end
