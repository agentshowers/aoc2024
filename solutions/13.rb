require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"
require "z3"

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
    x_total += factor
    y_total += factor
    a = (1.0*(x_total*y2) - (x2*y_total))/((x1*y2) - (x2*y1))
    b = (1.0*(y_total*x1) - (y1*x_total))/((x1*y2) - (x2*y1))
    if a % 1 == 0 && b % 1 == 0
      3*a.to_i + b.to_i
    else
      0
    end
  end

  def solvez3(x1, y1, x2, y2, x_total, y_total, factor = 0)
    solver = Z3::Solver.new
    a = Z3.Int('a')
    b = Z3.Int('b')
    solver.assert x1*a + x2*b == x_total + factor
    solver.assert y1*a + y2*b == y_total + factor
    if solver.satisfiable?
      3*solver.model[a].to_i + solver.model[b].to_i
    else
      0
    end
  end
end
