require "./lib/parser.rb"
require "./lib/base.rb"

class Day13 < Base
  DAY = 13

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines.each_slice(4).map do |slice|
      x1, y1 = slice[0].scan(/\d+/).map(&:to_i)
      x2, y2 = slice[1].scan(/\d+/).map(&:to_i)
      x_total, y_total = slice[2].scan(/\d+/).map(&:to_i)
      [x1, y1, x2, y2, x_total, y_total]
    end
  end

  def one
    @input.map do |(x1, y1, x2, y2, x_total, y_total)|
      solve(x1, y1, x2, y2, x_total, y_total)
    end.sum
  end

  def two
    @input.map do |(x1, y1, x2, y2, x_total, y_total)|
      solve(x1, y1, x2, y2, x_total, y_total, 10000000000000)
    end.sum
  end

  def solve(x1, y1, x2, y2, x_total, y_total, factor = 0)
    a, b = cramer_rule(x1, x2, x_total + factor, y1, y2, y_total + factor)
    if a % 1 == 0 && b % 1 == 0
      3*a.to_i + b.to_i
    else
      0
    end
  end
end
