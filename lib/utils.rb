module Utils
  ### Grid utils

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  VERTICALS = [[1,0], [0, 1], [-1, 0], [0, -1]].freeze
  ALL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  UP = 0
  DOWN = 1
  LEFT = 2
  RIGHT = 3
  OUT_OF_BOUNDS = nil

  def init_grid(lines, int = false)
    if int
      @grid = lines.map { |line| line.chars.map(&:to_i) }
    else
      @grid = lines.map { |line| line.chars }
    end
  end

  def grid_get(x, y)
    return OUT_OF_BOUNDS unless in_bounds?(x, y)
    @grid[x][y]
  end

  def grid_find(elem)
    (0..max_x).each do |x|
      (0..max_y).each do |y|
        return [x, y] if @grid[x][y] == elem
      end
    end
  end

  def width
    @width ||= @grid[0].length
  end

  def height
    @height ||= @grid.length
  end

  def max_x
    @max_x ||= width - 1
  end

  def max_y
    @max_y ||= height - 1
  end

  def in_bounds?(x, y)
    x >= 0 && x <= max_x && y >= 0 && y <= max_y
  end

  def border?(x, y)
    x == 0 || y == 0 || x == max_x || y == max_y
  end

  def turn_right(dir)
    return RIGHT if dir == UP
    return DOWN if dir == RIGHT
    return LEFT if dir == DOWN
    return UP if dir == LEFT
  end

  def apply_dir(x, y, dir)
    case dir
    when UP
      x -= 1
    when DOWN
      x += 1
    when LEFT
      y -= 1
    when RIGHT
      y += 1
    end
    [x, y]
  end
end
