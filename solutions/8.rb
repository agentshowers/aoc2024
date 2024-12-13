require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day8 < Base
  DAY = 8

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines, padding: false)
    @map = {}
    @grid.each_with_index do |row, x|
      row.each_with_index do |c, y|
        if c != '.'
          @map[c] ||= []
          @map[c] << [x,y]
        end
      end
    end
    puts @map.to_s
  end

  def one
    count_antinodes do |x1, y1, x2, y2, dx, dy, antinodes|
      antinodes << [x2 + dx, y2 + dy] if in_bounds?(x2 + dx, y2 + dy)
      antinodes << [x1 - dx, y1 - dy] if in_bounds?(x1 - dx, y1 - dy)
    end
  end

  def two
    count_antinodes do |x1, y1, x2, y2, dx, dy, antinodes|
      gcd = dx.gcd(dy)
      dx, dy = [dx / gcd, dy / gcd]
      i = 0
      while in_bounds?(x1 + (i * dx), y1 + (i* dy))
        antinodes << [x1 + (i * dx), y1 + (i * dy)]
        i += 1
      end
      i = 1
      while in_bounds?(x1 - (i * dx), y1 - (i* dy))
        antinodes << [x1 - (i * dx), y1 - (i * dy)]
        i += 1
      end
    end
  end

  def count_antinodes
    antinodes = []
    @map.each do |_, v|
      v.combination(2).each do |(x1, y1), (x2, y2)|
        dx, dy = [x2 - x1, y2 - y1]
        yield(x1, y1, x2, y2, dx, dy, antinodes)
      end
    end
    antinodes.uniq.count
  end
end
