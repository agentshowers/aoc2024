require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day4 < Base
  DAY = 4
  DIRS = [[1,0], [0, 1], [1, 1], [1, -1]]

  def initialize(type = "example")
    @lines = Parser.lines(DAY, type).map(&:chars)
  end

  def one
    (0..@lines.length-1).map do |x|
      (0..@lines.length-1).map do |y|
        count_xmas(x,y)
      end.sum
    end.sum
  end

  def count_xmas(x, y)
    letter = @lines[x][y]
    return 0 unless ["X", "S"].include?(letter)

    count = 0
    queue = letter == "X" ? ["M", "A", "S"] : ["A", "M", "X"]
    DIRS.each do |dx, dy|
      count += 1 if xmas?(x, y, dx, dy, queue)
    end
    count
  end

  def xmas?(x, y, dx, dy, queue)
    return true if queue.empty?
    x += dx
    y += dy
    return false if y < 0 || x == @lines.length || y == @lines.length
    new_queue = queue.dup
    return false if @lines[x][y] != new_queue.shift
    xmas?(x, y, dx, dy, new_queue)
  end

  def two
    count = 0
    (0..@lines.length-1).each do |x|
      (0..@lines.length-1).each do |y|
        count += 1 if @lines[x][y] == "A" && is_cross(x,y)
      end
    end
    count
  end

  def is_cross(x, y)
    return false if (x == 0 || y == 0 || x == @lines.length - 1 || y == @lines.length - 1)
    left_cross = [@lines[x-1][y-1], @lines[x+1][y+1]].sort == ["M", "S"]
    right_cross = [@lines[x-1][y+1], @lines[x+1][y-1]].sort == ["M", "S"]
    left_cross && right_cross
  end

end