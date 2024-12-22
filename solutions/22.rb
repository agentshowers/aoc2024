require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day22 < Base
  DAY = 22

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @seqs = Array.new(160000) { 0 }
    @sum = lines.map do |x|
      solve(x.to_i)
    end.sum
  end

  def one
    @sum
  end

  def two
    @seqs.max
  end

  def solve(n)
    prev = n % 10
    seq = 0
    local_seqs = Array.new(160000)
    2000.times do |i|
      n = ((n * 64) ^ n) & 16777215
      n = ((n / 32) ^ n) & 16777215
      n = ((n * 2048) ^ n) & 16777215

      price = (n % 10)
      diff = price - prev
      prev = price
      seq = ((seq * 20) + diff + 10) % 160000
      if i > 3
        if !local_seqs[seq]
          @seqs[seq] ||= 0
          @seqs[seq] += price
          local_seqs[seq] = true
        end
      end
    end
    n
  end

end
