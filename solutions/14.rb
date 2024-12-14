require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day14 < Base
  DAY = 14

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines.map do |line|
      line.scan(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)[0].map(&:to_i)
    end
    @width = (type == "example" ? 11 : 101)
    @height = (type == "example" ? 7 : 103)
  end

  def one
    u_l, u_r, b_l, b_r = 0, 0, 0, 0
    @input.each do |x, y, dx, dy|
      x = (x + 100*dx) % @width
      y = (y + 100*dy) % @height
      u_l += 1 if x < @width / 2 && y < @height / 2
      u_r += 1 if x > @width / 2 && y < @height / 2
      b_l += 1 if x < @width / 2 && y > @height / 2
      b_r += 1 if x > @width / 2 && y > @height / 2
    end
    u_l * u_r * b_l * b_r
  end

  def two
    x_base = nil
    y_base = nil
    i = 1
    while !x_base || !y_base
      x_max, y_max = maximums(i)
      x_base = i if x_max > 30
      y_base = i if y_max > 30
      i += 1
    end
    while (x_base - y_base) % @height != 0
      x_base += @width
    end
    x_base
  end

  def maximums(count)
    x_count = Array.new(@width) { 0 }
    y_count = Array.new(@height) { 0 }
    @input.each do |x, y, dx, dy|
      x = (x + count*dx) % @width
      y = (y + count*dy) % @height
      x_count[x] += 1
      y_count[y] += 1
    end
    [x_count.max, y_count.max]
  end
end
