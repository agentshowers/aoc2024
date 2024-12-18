require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"
require "algorithms"

class Day18 < Base
  DAY = 18

  def initialize(type = "example")
    @bytes = Parser.lines(DAY, type).map.with_index { |x, i| [x, i] }.to_h
    @max = (type == "example") ? 6 : 70
    @p1_count = (type == "example") ? 12 : 1024
  end

  def one
    path(@p1_count)
  end

  def two
    lower = 0
    upper = @bytes.length
    loop do
      count = lower + ((upper-lower) / 2)
      if path(count)
        lower = count + 1
      else
        upper = count
      end
      break if lower == upper
    end
    @bytes.keys[lower-1]
  end

  def path(dropped)
    visited = {}
    queue = [[0, 0, 0]]
    while !queue.empty?
      x, y, dist = queue.shift
      key = "#{x},#{y}"
      next if visited[key]
      visited[key] = true
      [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |nx, ny|
        next if nx < 0 || ny < 0 || nx > @max || ny > @max
        n_key = "#{nx},#{ny}"
        next if @bytes[n_key] && @bytes[n_key] < dropped
        cost = dist + 1
        return cost if nx == @max && ny == @max
        queue.push([nx, ny, cost]) unless visited[n_key]
      end
    end
    false
  end
end
