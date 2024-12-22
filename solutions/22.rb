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
    seq = []
    local_seqs = {}
    2000.times do |i|
      x = n*64
      n = n ^ x
      n = n % 16777216
      x = n / 32
      n = n ^ x
      n = n % 16777216
      x = n * 2048
      n = n ^ x
      n = n % 16777216

      price = (n % 10)
      diff = price - prev
      prev = price
      seq << diff
      if seq.length > 4
        seq.shift
        key = seq.join(",")
        if !local_seqs[key]
          @seqs[key] ||= 0
          @seqs[key] += price
        end
        local_seqs[key] = true
      end
    end
    n
  end

end
