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
    blocks = []
    @input.each_slice(2).with_index do |(a, b), id|
      blocks << [id, a]
      blocks << [nil, b] if b
    end
    i = blocks.length - 1
    while i > 0
      if !blocks[i][0]
        i -= 1
        next
      end
      j = 0
      offset = 0
      while j < i
        if !blocks[j][0] && (blocks[j][1] >= blocks[i][1])
          offset += insert(blocks, j, *blocks[i])
          blocks[i+offset][0] = nil
          break
        end
        j += 1
      end
      i = i - 1 + offset
    end
    calc(blocks)
  end

  def insert(blocks, idx, id, count)
    inserted = 0
    free_space = blocks[idx][1]
    blocks[idx] = [id, count]
    if free_space > count
      blocks.insert(idx + 1, [nil, free_space - count])
      inserted = 1
    end
    inserted
  end

  def calc(blocks)
    acc = 0
    idx = 0
    blocks.each do |id, count|
      acc += (idx..idx+count-1).sum * id if id
      idx += count
    end
    acc
  end

  def pb(blocks)
    s = ""
    blocks.each do |n, c|
      s += ((n ? n.to_s : ".") * c)
    end
    s
  end
end
