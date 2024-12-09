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
    @solved = Array.new(@input.length) { false }
  end

  def one
    sum = 0
    @input.each_with_index do |(result, values), index|
      if solvable?(result, values, values.length - 1, false)
        sum += result
        @solved[index] = true
      end
    end
    sum
  end

  def two
    sum = 0
    @input.each_with_index do |(result, values), index|
      sum += result if @solved[index] || solvable?(result, values, values.length - 1, true)
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
