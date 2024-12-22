require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day10 < Base
  DAY = 10

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines, int: true)
    @cache = {}
    @zeroes = find_multiple(0)
    @zeroes.each do |x, y|
      find_trails(x, y)
    end
  end

  def find_trails(x, y)
    @cache["#{x},#{y}"] ||= begin
      elem = @grid[x][y]
      if elem == 9
        [[x, y]]
      else
        trails = []
        neighbors(x, y).each do |nx, ny|
          if @grid[nx][ny] == elem + 1
            trails += find_trails(nx, ny)
          end
        end
        trails
      end
    end
  end

  def one
    @zeroes.map do |x, y|
      @cache["#{x},#{y}"].uniq.count
    end.sum
  end

  def two
    @zeroes.map do |x, y|
      @cache["#{x},#{y}"].count
    end.sum
  end
end
