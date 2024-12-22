require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day6 < Base
  DAY = 6

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
    @x_obstacles = Array.new(height) { [] }
    @y_obstacles = Array.new(width) { [] }
    @grid.each_with_index do |row, x|
      row.each_with_index do |elem, y|
        if elem == "#"
          @x_obstacles[x] << y
          @y_obstacles[y] << x
        elsif elem == "^"
          @start_x = x
          @start_y = y
          @grid[x][y] = "."
        end
      end
    end
  end

  def one
    explore
    @visited.keys.count
  end

  def two
    @loops
  end

  def explore
    @visited = {}
    @loops = 0
    hits = {}
    x, y = @start_x, @start_y
    dir = UP
    loop do
      @visited[1000*x + y] = true
      nx, ny = apply_dir(x, y, dir)
      elem = @grid[nx][ny]
      key = 1000*nx + ny
      if elem == "#"
        hits[key] ||= 0
        hits[key] |= 2.pow(dir)
        dir = turn_right(dir)
      elsif elem == "."
        if !@visited[1000*nx + ny]
          with_obstacle(nx, ny) do
            @loops += 1 if is_loop?(x, y, dir, hits.dup)
          end
        end
        x, y = nx, ny
      else
        break
      end
    end
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

  def is_loop?(x, y, dir, hits)
    loop do
      case dir
      when UP
        return false if @y_obstacles[y].empty? || x < @y_obstacles[y][0]
        idx = @y_obstacles[y].rindex { |n| n < x }
        obs_x = @y_obstacles[y][idx]
        obs_y = y
      when DOWN
        return false if @y_obstacles[y].empty? || x > @y_obstacles[y][-1]
        obs_x = @y_obstacles[y].find { |n| n > x }
        obs_y = y
      when LEFT
        return false if @x_obstacles[x].empty? || y < @x_obstacles[x][0]
        idx = @x_obstacles[x].rindex { |n| n < y }
        obs_x = x
        obs_y = @x_obstacles[x][idx]
      when RIGHT
        return false if @x_obstacles[x].empty? || y > @x_obstacles[x][-1]
        obs_x = x
        obs_y = @x_obstacles[x].find { |n| n > y }
      end

      key = 1000*obs_x + obs_y
      hits[key] ||= 0
      return true if (hits[key] & 2.pow(dir)) > 0
      hits[key] |= 2.pow(dir)
      x, y = apply_dir(obs_x, obs_y, reverse(dir))
      dir = turn_right(dir)
    end
  end

end
