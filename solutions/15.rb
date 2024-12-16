require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day15 < Base
  include Grid::Matrix

  DAY = 15
  DIRECTIONS = { "^" => [-1, 0], "<" => [0, -1], ">" => [0, 1], "v" => [1, 0] }

  def initialize(type = "example")
    @map, moves = Parser.read(DAY, type).split("\n\n")
    @moves = moves.split("\n").map(&:chars).flatten
  end

  def one
    init_grid(@map.split("\n"), padding: false)
    x, y = find("@")
    @moves.each do |move|
      x, y = apply_move(x, y, *DIRECTIONS[move])
    end
    find_multiple("O").map {|x, y| x*100 + y }.sum
  end

  def apply_move(x, y, dx, dy)
    found_box = false
    cur_x, cur_y = x, y
    loop do
      cur_x += dx
      cur_y += dy
      return [x, y] if @grid[cur_x][cur_y] == "#"
      break if @grid[cur_x][cur_y] == "."
      found_box = true
    end
    
    @grid[x][y] = "."
    @grid[x+dx][y+dy] = "@"
    @grid[cur_x][cur_y] = "O" if found_box
    [x+dx, y+dy]
  end

  def two
    @map.gsub!("#","##").gsub!("O","[]").gsub!(".", "..").gsub!("@", "@.")
    init_grid(@map.split("\n"), padding: false)
    x, y = find("@")
    @moves.each do |move|
      if ["<", ">"].include?(move)
        x, y = horizontal_move(x, y, DIRECTIONS[move][1])
      else
        x, y = vertical_move(x, y, DIRECTIONS[move][0])
      end
    end
    find_multiple("[").map {|x, y| x*100 + y }.sum
  end

  def horizontal_move(x, y, dy)
    cur_y = y + dy
    while @grid[x][cur_y] == "[" || @grid[x][cur_y] == "]"
      cur_y = cur_y + dy
    end
    return [x, y] if @grid[x][cur_y] == "#"
    @grid[x].delete_at(cur_y)
    @grid[x].insert(y, ".")
    [x, y+dy]
  end

  def vertical_move(x, y, dx)
    cur_x = x
    cur_ys = [y]
    changes = []
    loop do
      cur_x += dx
      new_ys = []
      cur_ys.each do |ny|
        return [x, y] if @grid[cur_x][ny] == "#"
        changes << [cur_x, ny]
        new_ys = [ny, ny+1] + new_ys if @grid[cur_x][ny] == "["
        new_ys = [ny, ny-1] + new_ys if @grid[cur_x][ny] == "]"
      end
      break if new_ys.empty?
      cur_ys = new_ys.uniq
    end
    changes.reverse.each do |nx, ny|
      @grid[nx][ny] = @grid[nx-dx][ny]
      @grid[nx-dx][ny] = "."
    end
    [x + dx, y]
  end
end
