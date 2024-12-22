require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"
require "algorithms"

class Day16 < Base
  DAY = 16

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines, padding: false)
    @start = find("S")
    @parents = {}
    @distances = {}
    explore
  end

  def one
    @distances[@final_key]
  end

  def two
    spots = []
    queue = [@final_key]
    while !queue.empty?
      key = queue.pop
      y = key % 1000
      x = (key % 1000000) / 1000
      spots << [x,y]
      @parents[key].each { |k| queue << k }
    end
    spots.uniq.count
  end
  
  def explore
    @distances[RIGHT * 1000000 + @start[0] * 1000 + @start[1]] = 0
    @parents[RIGHT * 1000000 + @start[0] * 1000 + @start[1]] = []
    queue = Containers::PriorityQueue.new
    queue.push(@start + [RIGHT], 0)
    visited = {}
    while !queue.empty?
      x, y, dir = queue.pop
      key = dir * 1000000 + x * 1000 + y
      next if visited[key]
      visited[key] = true
      [[dir, false], [turn_left(dir), true], [turn_right(dir), true]].each do |n_dir, turn|
        nx, ny = apply_dir(x, y, n_dir)
        next if @grid[nx][ny] == "#"
        n_key = n_dir * 1000000 + nx * 1000 + ny
        next if visited[n_key]
        cost = @distances[key] + 1 + (turn ? 1000 : 0)
        if !@distances[n_key] || @distances[n_key] > cost
          @distances[n_key] = cost
          @parents[n_key] = [key]
          queue.push([nx, ny, n_dir], -cost)
        elsif @distances[n_key] == cost
          @parents[n_key] << key
        end
        if @grid[nx][ny] == "E"
          @final_key = n_key
          return
        end
      end
    end
  end
end
