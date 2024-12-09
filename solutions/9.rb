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

    sum = 0
    blocks.reverse.each do |id, b_count, b_idx|
      j = 0
      moved = false
      while !moved && j < free_spaces.length do
        f_count, f_idx = free_spaces[j]
        if f_idx > b_idx
          sum += calc_block(id, b_count, b_idx)
          moved = true
        elsif b_count <= f_count
          sum += calc_block(id, b_count, f_idx)
          if b_count == f_count
            free_spaces.delete_at(j)
          else
            free_spaces[j] = [f_count - b_count, f_idx + b_count]
          end
          moved = true
        end
        j += 1
      end
      sum += calc_block(id, b_count, b_idx) if !moved
    end
    sum
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