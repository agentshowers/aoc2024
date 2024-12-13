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
    @regions.map do |area, perimeter, _, _|
      area * perimeter
    end.sum
  end

  def two
    @regions.map do |area, _, borders_x, borders_y|
      sides = calc_sides(borders_x) + calc_sides(borders_y)
      area * sides
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
    borders_x = {}
    borders_y = {}
    elem = get(x, y)
    queue = [[x, y]]
    while !queue.empty?
      x, y = queue.shift
      next if @visited[x][y]
      @visited[x][y] = true
      area += 1
      up = [x-1, y, get(x-1, y)]
      down = [x+1, y, get(x+1, y)]
      left = [x, y-1, get(x, y-1)]
      right = [x, y+1, get(x, y+1)]
      [up, down, left, right].each do |nx, ny, value|
        if value == elem
          queue << [nx, ny] unless @visited[nx][ny]
        else
          perimeter += 1
          if x > nx
            borders_x[x] ||= [[],[]]
            borders_x[x][0] << y
          elsif x < nx
            borders_x[x] ||= [[],[]]
            borders_x[x][1] << y
          elsif y > ny
            borders_y[y] ||= [[],[]]
            borders_y[y][0] << x
          else
            borders_y[y] ||= [[],[]]
            borders_y[y][1] << x
          end
        end
      end
    end
    [area, perimeter, borders_x, borders_y]
  end

  def calc_sides(borders)
    borders.values.map do |border|
      border.map do |x|
        if x.empty?
          0
        else
          sides = 1
          x.sort.each_cons(2) do |a, b|
            sides += 1 if b > a + 1
          end
          sides
        end
      end.sum
    end.sum
  end
end
