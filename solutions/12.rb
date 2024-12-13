require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day12 < Base
  DAY = 12

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
    explore
  end

  def one
    @regions.map do |area, perimeter, _,|
      area * perimeter
    end.sum
  end

  def two
    @regions.map do |area, _, corners|
      area * corners
    end.sum
  end

  def explore
    @visited = Array.new(height) { Array.new(width) { false } }
    @regions = []
    (1..max_x).each do |x|
      (1..max_y).each do |y|
        next if @visited[x][y]
        @regions << explore_region(x, y)
      end
    end
  end

  def explore_region(x, y)
    area = 0
    perimeter = 0
    corners = 0
    elem = @grid[x][y]
    queue = [[x, y]]
    while !queue.empty?
      x, y = queue.shift
      next if @visited[x][y]
      @visited[x][y] = true
      area += 1
      [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].each do |nx, ny, value|
        if @grid[nx][ny] == elem
          queue << [nx, ny] unless @visited[nx][ny]
        else
          perimeter += 1
        end
      end
      corners += count_corners(x, y, elem)
    end
    [area, perimeter, corners]
  end

  def count_corners(x, y, elem)
    up = @grid[x-1][y]
    down = @grid[x+1][y]
    left = @grid[x][y-1]
    right = @grid[x][y+1]
    corners = 0
    corners += 1 if up != elem && left != elem
    corners += 1 if up != elem && right != elem
    corners += 1 if down != elem && left != elem
    corners += 1 if down != elem && right != elem
    corners += 1 if up == elem && left == elem && @grid[x-1][y-1] != elem
    corners += 1 if up == elem && right == elem && @grid[x-1][y+1] != elem
    corners += 1 if down == elem && left == elem && @grid[x+1][y-1] != elem
    corners += 1 if down == elem && right == elem && @grid[x+1][y+1] != elem
    corners
  end
end
