require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day20 < Base
  DAY = 20

  include Grid::Matrix

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    init_grid(lines, padding: false)
    find_path
  end

  def one
    count_cheats(2)
  end

  def two
    count_cheats(20)
  end

  def count_cheats(max_pico)
    cheats = []
    @path.each_with_index do |(x, y), i|
      (i..@path.length-1).each do |j|
        nx, ny = @path[j]
        dist = (x - nx).abs + (y - ny).abs
        if dist <= max_pico && i + dist < j
          cheats << (j - (i + dist))
        end
      end
    end
    cheats.select { |x| x >= 100 }.count
  end

  def find_path
    x, y = find("S")
    @path = [[x, y]]
    while @grid[x][y] != "E" do
      [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |nx, ny|
        next if @grid[nx][ny] == "#"
        next if @path[-2] == [nx, ny]
        @path << [nx, ny]
        break
      end
      x, y = @path.last
    end
  end
end
