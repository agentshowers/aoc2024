require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day10 < Base
  DAY = 10

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines, true)
    @memo = {}
    @zeroes = find_multiple(0)
    @zeroes.each do |x, y|
      find_trails(x, y, @memo)
    end
  end

  def find_trails(x, y, memo)
    key = "#{x},#{y}"
    return memo[key] if memo[key]
    elem = get(x, y)
    return [[x, y]] if elem == 9

    trails = []
    neighbors(x, y).each do |nx, ny|
      if get(nx, ny) == elem + 1
        trails += find_trails(nx, ny, memo)
      end
    end
    memo[key] = trails
    memo[key]
  end

  def one
    @zeroes.map do |x, y|
      @memo["#{x},#{y}"].uniq.count
    end.sum
  end

  def two
    @zeroes.map do |x, y|
      @memo["#{x},#{y}"].count
    end.sum
  end
end
