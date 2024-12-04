module Utils
  ### Grid utils

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  VERTICALS = [[1,0], [0, 1], [-1, 0], [0, -1]].freeze
  ALL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]].freeze

  def init_grid(lines, int = false)
    if int
      @grid = lines.map { |line| line.chars.map(&:to_i) }
    else
      @grid = lines.map { |line| line.chars }
    end
  end

  def max_x
    @max_x ||= @grid.length - 1
  end

  def max_y
    @max_y ||= @grid[0].length - 1
  end

  def in_bounds?(x, y)
    x >= 0 && x <= max_x && y >= 0 && y <= max_y
  end

  def border?(x, y)
    x == 0 || y == 0 || x == max_x || y == max_y
  end
end
