require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day6 < Base
  DAY = 6

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines)
    x, y = grid_find("^")
    @grid[x][y] = "."
    @v_count = 0
    @obstacles = {}
    explore(false, x, y, UP, {})
  end

  def one
    @v_count
  end

  def two
    @obstacles.keys.length
  end

  def explore(obstacle_added, x, y, dir, visited)
    loop do
      key = "#{x},#{y}"
      return true if ((visited[key] || 0) & 2.pow(dir)) > 0
      nx, ny = apply_dir(x, y, dir)
      elem = grid_get(nx, ny)
      if elem == "#"
        dir = turn_right(dir)
      else
        if !obstacle_added
          @v_count += 1 unless visited[key]
          return false if elem == OUT_OF_BOUNDS
          next_key = "#{nx},#{ny}"
          unless visited[next_key] && !obstacle_added
            @grid[nx][ny] = "#"
            @obstacles[next_key] = true if explore(true, x, y, dir, visited.dup)
            @grid[nx][ny] = "."
          end
        else
          return false if elem == OUT_OF_BOUNDS
        end
        visited[key] = (visited[key] || 0) | 2.pow(dir)
        x, y = [nx, ny]
      end
    end
  end
end