require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day7 < Base
  DAY = 7

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines.map do |line|
      res, ns = line.split(": ")
      [res.to_i, ns.split(" ").map(&:to_i)]
    end
  end

  def one
    count_solvable(false)
  end

  def two
    count_solvable(true)
  end

  def count_solvable(concat)
    sum = 0
    @input.each_with_index do |(result, values), index|
      sum += result if solvable?(result, values, values.length - 1, concat)
    end
    return sum
  end

  def solvable?(current, values, idx, concat)
    value = values[idx]
    return current == value if idx == 0
    return true if solvable?(current - value, values, idx - 1, concat)
    return true if (current % value == 0) && solvable?(current / value, values, idx - 1, concat)
    if concat
      v_len = value.to_s.length
      return true if (current % 10.pow(v_len) == value) && solvable?(current / 10.pow(v_len), values, idx - 1, concat)
    end
    false
  end
end
