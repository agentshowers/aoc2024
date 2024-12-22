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
      x = key / 1000
      y = key % 1000
      ((x-max_pico)..(x+max_pico)).each do |nx|
        next if nx <= 0 || nx >= max_x
        y_idx = @points[nx].bsearch_index { |v| v >= y }
        y_idx ||= @points[nx].length - 1
        dx = (x - nx).abs

        ny = @points[nx][y_idx]
        dy = (y - ny).abs
        if dx + dy <= max_pico
          n_key = 1000 * nx + ny
          count += 1 if @distances[n_key] >= (dist + dx + dy + 100)
        end

        [1, -1].each do |delta|
          i = y_idx + delta
          while i >= 0 && i < @points[nx].length
            ny = @points[nx][i]
            dy = (y - ny).abs
            break if dx + dy > max_pico
            n_key = 1000 * nx + ny
            count += 1 if @distances[n_key] >= (dist + dx + dy + 100)
            i += delta
          end
        end
      end
    end
    count
  end

  def find_path
    x, y = find("S")
    path = [[x, y]]
    @points = Array.new(height) { [] }
    while @grid[x][y] != "E" do
      [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |nx, ny|
        next if @grid[nx][ny] == "#"
        next if path[-2] == [nx, ny]
        path << [nx, ny]
        break
      end
      x, y = path.last
      @points[x] << y
    end
    @points.each { |row| row.sort! }
    @distances = path.each_with_index.map { |(x, y), i| [1000 * x + y, i] }.to_h
  end

end
