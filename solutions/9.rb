require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day9 < Base
  DAY = 9

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines[0].chars.map(&:to_i)
    @blocks, @free_spaces = split
  end

  def one
    free_spaces = @free_spaces.map(&:dup)

    sum = 0
    @blocks.reverse.each do |id, b_count, b_idx|
      while b_count > 0 do
        f_count, f_idx = free_spaces[0]
        if f_idx > b_idx
          sum += calc_block(id, b_count, b_idx)
          break
        end
        sum += calc_block(id, [b_count, f_count].min, f_idx)

        if f_count > b_count
          free_spaces[0] = [f_count - b_count, f_idx + b_count]
        else
          free_spaces.shift
        end

        b_count -= f_count
      end
    end

    sum
  end

  def two
    free_spaces = @free_spaces.map(&:dup)

    @blocks.reverse.map do |id, b_count, b_idx|
      pos = find_free(free_spaces, b_count, b_idx)
      if pos
        f_count, f_idx = free_spaces[pos]
        if b_count == f_count
          free_spaces.delete_at(pos)
        else
          free_spaces[pos] = [f_count - b_count, f_idx + b_count]
        end
        calc_block(id, b_count, f_idx)
      else
        calc_block(id, b_count, b_idx)
      end
    end.sum
  end

  def find_free(free_spaces, b_count, b_idx)
    free_spaces.each_with_index do |(f_count, f_idx), i|
      return if f_idx > b_idx
      return i if b_count <= f_count
    end
    nil
  end

  def split
    blocks = []
    free_spaces = []
    idx = 0
    @input.each_slice(2).with_index do |(files, free), id|
      blocks << [id, files, idx]
      idx += files
      if free && free > 0
        free_spaces << [free, idx]
        idx += free
      end
    end
    [blocks, free_spaces]
  end

  def calc_block(id, count, b_idx)
    (b_idx..b_idx+count-1).sum * id
  end
end
