require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day9 < Base
  DAY = 9

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines[0].chars.map(&:to_i)
  end

  def one
    blocks = []
    free_spaces = []
    @input.each_slice(2).with_index do |(a, b), id|
      blocks << [id, a]
      free_spaces << b if b
    end

    acc = 0
    csum_order = 0
    i = 0
    j = blocks.length - 1
    loop do
      n, count = blocks[i]
      acc += (csum_order..(csum_order+count-1)).sum * n
      csum_order += count

      count = free_spaces[i]
      i += 1
      break if i > j
      while count > 0
        nj, countj = blocks[j]
        move = [count, countj].min
        acc += (csum_order..(csum_order+move-1)).sum * nj
        csum_order += move
        count -= countj
        if move == countj
          j -= 1
        else
          blocks[j] = [nj, countj - move]
        end
      end

    end
    acc
  end

  def two
    blocks, free_spaces = split

    blocks.reverse.map do |id, b_count, b_idx|
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
