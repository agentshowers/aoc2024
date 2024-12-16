require './lib/base.rb'

module Grid
  module Matrix
    UP = 0
    RIGHT = 1
    DOWN = 2
    LEFT = 3
    DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
    VERTICALS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze
    ALL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
    OUT_OF_BOUNDS = nil

    attr_accessor :max_x, :max_y, :width, :height

    def init_grid(lines, int: false, padding: true)
      out_of_bounds = int ? -1 : "-"
      @grid = []
      @grid << Array.new(lines[0].length + 2) { out_of_bounds } if padding
      @grid += lines.map do |line|
        elements = line.chars
        elements = elements.map(&:to_i) if int
        elements = [out_of_bounds] + elements + [out_of_bounds] if padding
        elements
      end
      @grid << Array.new(lines[0].length + 2) { out_of_bounds } if padding
      @padding = padding
      @width = @grid[0].length
      @height = @grid.length
      @max_x = (@padding ? height - 2 : height - 1)
      @max_y = (@padding ? width - 2 : width - 1)
    end

    def in_bounds?(x, y)
      x >= 0 && x <= max_x && y >= 0 && y <= max_y
    end

    def border?(x, y)
      x == 0 || y == 0 || x == max_x || y == max_y
    end

    def turn_left(dir)
      (dir - 1) % 4
    end

    def turn_right(dir)
      (dir + 1) % 4
    end

    def reverse(dir)
      (dir + 2) % 4
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
      dx, dy = VERTICALS[dir]
      [x + dx, y + dy]
    end

    def print
      puts @grid.map { |r| r.join }.join("\n")
    end
  end
end
