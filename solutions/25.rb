require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day25 < Base
  DAY = 25

  def initialize(type = "example")
    grids = Parser.read(DAY, type).split("\n\n")
    @locks = []
    @keys = []

    grids.each do |grid|
      grid = grid.split("\n")
      is_lock = grid[0][0] == "#"
      init = is_lock ? 1 : 5
      delta = is_lock ? 1 : -1
      heights = (0..4).map do |y|
        x = init
        while grid[x][y] == "#"
          x += delta
        end
        is_lock ? x - 1 : 5 - x
      end
      if is_lock
        @locks << heights
      else
        @keys << heights
      end
    end
  end

  def one
    count = 0
    @keys.each do |key|
      @locks.each do |lock|
        overlap = false
        (0..4).each do |i|
          if key[i] + lock[i] >= 6
            overlap = true
            break
          end
        end
        count += 1 unless overlap
      end
    end
    count
  end

  def two
    "⭐️"
  end
end
