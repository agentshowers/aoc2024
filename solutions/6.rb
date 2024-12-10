require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day6 < Base
  DAY = 6

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
    @start_x, @start_y = grid_find("^")
    @grid[@start_x][@start_y] = "."
    @x_obstacles = Array.new(height) { [] }
    @y_obstacles = Array.new(width) { [] }
    @grid.each_with_index do |row, x|
      row.each_with_index do |elem, y|
        if elem == "#"
          @x_obstacles[x] << y
          @y_obstacles[y] << x
        end
      end
    end
  end

  def one
    @visited = []
    x, y = @start_x, @start_y
    dir = UP
    loop do
      @visited << [x, y]
      nx, ny = apply_dir(x, y, dir)
      elem = grid_get(nx, ny)
      if elem == "#"
        dir = turn_right(dir)
        x, y = apply_dir(x, y, dir)
      elsif elem == "."
        x, y = nx, ny
      else
        break
      end
    end
    @visited.uniq!
    @visited.count
  end

  def two
    loops = 0
    @visited[1..].each do |x, y|
      with_obstacle(x, y) do
        loops += 1 if is_loop?
      end
    end
    loops
  end

  def with_obstacle(x, y)
    @x_obstacles[x] << y
    @x_obstacles[x].sort!
    @y_obstacles[y] << x
    @y_obstacles[y].sort!
    yield
    @x_obstacles[x].delete(y)
    @y_obstacles[y].delete(x)
  end

  def is_loop?
    hits = {}
    x, y = @start_x, @start_y
    dir = UP
    loop do
      case dir
      when UP
        return false if x < @y_obstacles[y][0]
        idx = @y_obstacles[y].rindex { |n| n < x }
        obs_x = @y_obstacles[y][idx]
        obs_y = y
      when DOWN
        return false if x > @y_obstacles[y][-1]
        obs_x = @y_obstacles[y].find { |n| n > x }
        obs_y = y
      when LEFT
        return false if y < @x_obstacles[x][0]
        idx = @x_obstacles[x].rindex { |n| n < y }
        obs_x = x
        obs_y = @x_obstacles[x][idx]
      when RIGHT
        return false if y > @x_obstacles[x][-1]
        obs_x = x
        obs_y = @x_obstacles[x].find { |n| n > y }
      end

      key = "#{obs_x},#{obs_y}"
      hits[key] ||= 0
      return true if (hits[key] & 2.pow(dir)) > 0
      hits[key] |= 2.pow(dir)
      x, y = apply_dir(obs_x, obs_y, reverse(dir))
      dir = turn_right(dir)
    end
  end

end
