require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day4 < Base
  DAY = 4

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
  end

  def one
    (0..@grid.length-1).map do |x|
      (0..@grid.length-1).map do |y|
        @grid[x][y] == "X" ? count_xmas(x,y) : 0
      end.sum
    end.sum
  end

  def count_xmas(x, y)
    count = 0
    queue = ["M", "A", "S"]
    ALL_DIRS.each do |dx, dy|
      count += 1 if xmas?(x + dx, y + dy, dx, dy, queue)
    end
    count
  end

  def xmas?(x, y, dx, dy, queue)
    return true if queue.empty?
    return false unless in_bounds?(x, y)
    return false if @grid[x][y] != queue[0]
    xmas?(x + dx, y + dy, dx, dy, queue[1..-1])
  end

  def two
    count = 0
    (0..@grid.length-1).each do |x|
      (0..@grid.length-1).each do |y|
        count += 1 if @grid[x][y] == "A" && is_cross(x,y)
      end
    end
    count
  end

  def is_cross(x, y)
    return false if border?(x, y)
    left_cross = [@grid[x-1][y-1], @grid[x+1][y+1]].sort == ["M", "S"]
    right_cross = [@grid[x-1][y+1], @grid[x+1][y-1]].sort == ["M", "S"]
    left_cross && right_cross
  end

end
