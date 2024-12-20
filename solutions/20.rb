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
    count = 0
    @distances.each do |key, dist|
      x, y = key.split(",").map(&:to_i)
      (-max_pico..max_pico).each do |dx|
        max_dy = max_pico - dx.abs
        (-max_dy..max_dy).each do |dy|
          nx = x + dx
          ny = y + dy
          n_dist = dx.abs + dy.abs
          n_key =  "#{nx},#{ny}"
          count += 1 if @distances[n_key] && @distances[n_key] >= (dist + n_dist + 100)
        end
      end
    end
    count
  end

  def find_path
    x, y = find("S")
    path = [[x, y]]
    while @grid[x][y] != "E" do
      [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |nx, ny|
        next if @grid[nx][ny] == "#"
        next if path[-2] == [nx, ny]
        path << [nx, ny]
        break
      end
      x, y = path.last
    end
    @distances = path.each_with_index.map { |(x, y), i| ["#{x},#{y}", i] }.to_h
  end

end
