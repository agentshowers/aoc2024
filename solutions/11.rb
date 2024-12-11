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
    return 1 if missing == 0
    key = "#{stone},#{missing}"

    @memo[key] ||= begin
      if stone == 0
        expand(1, missing-1)
      else
        base10 = Math.log10(stone).floor + 1
        if base10.even?
          expand(stone / 10.pow(base10/2), missing-1) + expand(stone % 10.pow(base10/2), missing-1)
        else
          expand(stone*2024, missing-1)
        end
      end
    end
  end
end
