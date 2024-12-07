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
      if solvable?(result, values, values[0], 1, false)
        sum += result
        @solved[index] = true
      end
    end
    sum
  end

  def two
    sum = 0
    @input.each_with_index do |(result, values), index|
      sum += result if @solved[index] || solvable?(result, values, values[0], 1, true)
    end
    return sum
  end

  def solvable?(result, values, acc, idx, concat)
    return result == acc if idx == values.length
    return false if acc > result

    return true if solvable?(result, values, acc + values[idx], idx + 1, concat)
    return true if solvable?(result, values, acc * values[idx], idx + 1, concat)
    return true if concat && solvable?(result, values, concatenate(acc, values[idx]), idx + 1, concat) 
    false
  end

  def concatenate(a, b)
    a * 10.pow(b.to_s.length) + b
  end
end