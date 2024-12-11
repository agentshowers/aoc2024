require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day11 < Base
  DAY = 11

  def initialize(type = "example")
    @stones = Parser.read(DAY, type).split(" ").map(&:to_i)
    @memo = {}
  end

  def one
    @stones.map { |stone| expand(stone, 25) }.sum
  end

  def two
    @stones.map { |stone| expand(stone, 75) }.sum
  end

  def expand(stone, missing)
    key = "#{stone},#{missing}"
    return @memo[key] if @memo[key]

    new_stones = transform(stone)
    if missing == 1
      total = new_stones.count
    else
      total = new_stones.map { |s| expand(s, missing-1) }.sum
    end

    @memo[key] = total
    @memo[key]
  end

  def transform(stone)
    return [1] if stone == 0
    base10 = Math.log10(stone).floor + 1
    if base10.even?
      [stone / 10.pow(base10/2), stone % 10.pow(base10/2)]
    else
      [stone * 2024]
    end
  end
end