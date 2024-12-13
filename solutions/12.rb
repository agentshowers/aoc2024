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
    (0..max_x).each do |x|
      (0..max_y).each do |y|
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
      up = [x-1, y, @grid[x-1][y]]
      down = [x+1, y, @grid[x+1][y]]
      left = [x, y-1, @grid[x][y-1]]
      right = [x, y+1, @grid[x][y+1]]
      up_l = @grid[x-1][y-1]
      up_r = @grid[x-1][y+1]
      down_l = @grid[x+1][y-1]
      down_r = @grid[x+1][y+1]
      [up, down, left, right].each do |nx, ny, value|
        if value == elem
          queue << [nx, ny] unless @visited[nx][ny]
        else
          perimeter += 1
        end
      end
      corners += 1 if up[2] != elem && left[2] != elem
      corners += 1 if up[2] != elem && right[2] != elem
      corners += 1 if down[2] != elem && left[2] != elem
      corners += 1 if down[2] != elem && right[2] != elem
      corners += 1 if up[2] == elem && left[2] == elem && up_l != elem
      corners += 1 if up[2] == elem && right[2] == elem && up_r != elem
      corners += 1 if down[2] == elem && left[2] == elem && down_l != elem
      corners += 1 if down[2] == elem && right[2] == elem && down_r != elem
    end
    [area, perimeter, corners]
  end
end
