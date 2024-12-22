require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day22 < Base
  DAY = 22

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @seqs = {}
    @sum = lines.map do |x|
      solve(x.to_i)
    end.sum
  end

  def one
    @sum
  end

  def two
    @seqs.values.max
  end

  def solve(n)
    prev = n % 10
    seq = 0
    signs = 0
    local_seqs = {}
    2000.times do |i|
      n = ((n * 64) ^ n) & 16777215
      n = ((n / 32) ^ n) & 16777215
      n = ((n * 2048) ^ n) & 16777215

      price = n % 10
      diff = price - prev
      prev = price
      seq = ((seq * 10) + diff.abs) % 10000
      signs = ((signs << 1) & 15) + (diff < 0 ? 1 : 0)
      if i > 3
        key = signs * 10000 + seq
        if !local_seqs[key]
          @seqs[key] ||= 0
          @seqs[key] += price
          local_seqs[key] = true
        end
      end
    end
    n
  end

end
