require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day12 < Base
  DAY = 12
  NEW = 0
  GLOBAL_Q = 1
  LOCAL_Q = 2
  VISITED = 3

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
    explore
  end

  def one
    @regions.map do |area, borders_x, borders_y|
      perimeter = calc_perimeter(borders_x) + calc_perimeter(borders_y)
      area * perimeter
    end.sum
  end

  def two
    @regions.map do |area, borders_x, borders_y|
      sides = calc_sides(borders_x) + calc_sides(borders_y)
      area * sides
    end.sum
  end

  def explore
    @status = Array.new(height) { Array.new(width) { NEW }}
    queue = [[0, 0]]
    @status[0][0] = GLOBAL_Q
    @regions = []
    while !queue.empty?
      x, y = queue.pop
      next if @status[x][y] == VISITED
      area, borders_x, borders_y, adjacents = explore_region(x, y)
      @regions << [area, borders_x, borders_y]
      queue += adjacents
    end
  end

  def explore_region(x, y)
    adjacents = []
    area = 0
    borders_x = {}
    borders_y = {}
    elem = grid_get(x, y)
    queue = [[x, y]]
    while !queue.empty?
      x, y = queue.shift
      next if @status[x][y] == VISITED
      @status[x][y] = VISITED
      area += 1
      unsafe_neighbors(x, y).each do |nx, ny|
        if grid_get(nx, ny) == elem
          if @status[nx][ny] == NEW || @status[nx][ny] == GLOBAL_Q
            queue << [nx, ny]
            @status[nx][ny] = LOCAL_Q
          end
        else
          if in_bounds?(nx, ny) && @status[nx][ny] == NEW
            adjacents << [nx, ny]
            @status[nx][ny] = GLOBAL_Q
          end
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
    [area, borders_x, borders_y, adjacents]
  end

  def calc_perimeter(borders)
    borders.map { |_, v| v[0].count + v[1].count }.sum
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
