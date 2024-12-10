require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"
require "algorithms"

class Day9 < Base
  DAY = 9

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines[0].chars.map(&:to_i)
    @blocks, @free_spaces = split
    @heaps = Array.new(10) { Containers::MinHeap.new }
    @free_spaces.each do |f_count, f_idx|
      @heaps[f_count].push(f_idx)
    end
  end

  def one
    sum = 0
    @blocks.reverse.each do |id, b_count, b_idx|
      while b_count > 0 do
        f_count, f_idx = @free_spaces[0]
        if f_idx > b_idx
          sum += calc_block(id, b_count, b_idx)
          break
        end
        sum += calc_block(id, [b_count, f_count].min, f_idx)

        if f_count > b_count
          @free_spaces[0] = [f_count - b_count, f_idx + b_count]
        else
          @free_spaces.shift
        end

        b_count -= f_count
      end
    end

    sum
  end

  def two
    @blocks.reverse.map do |id, b_count, b_idx|
      f_count = find_free(b_count, b_idx)

      if f_count
        f_idx = @heaps[f_count].pop
        @heaps[f_count-b_count].push(f_idx + b_count) if f_count > b_count
        calc_block(id, b_count, f_idx)
      else
        calc_block(id, b_count, b_idx)
      end
    end.sum
  end

  def find_free(b_count, b_idx)
    low_idx = nil
    low_count = nil
    (b_count..9).each do |i|
      next if @heaps[i].empty?
      if @heaps[i].next < b_idx && (!low_idx || @heaps[i].next < low_idx)
        low_idx = @heaps[i].next
        low_count = i
      end
    end
    low_count
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
