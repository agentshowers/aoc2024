require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day11 < Base
  DAY = 11

  def initialize(type = "example")
    @stones = Parser.read(DAY, type).split(" ").map{ |s| [s.to_i, 1] }.to_h
    @memo = {}
  end

  def one
    25.times { blink }
    @stones.values.sum
  end

  def two
    50.times { blink }
    @stones.values.sum
  end

  def blink
    new_stones = Hash.new(0)

    if @stones[0]
      new_stones[1] += @stones[0]
      @stones.delete(0)
    end

    @stones.each do |stone, count|
      if @memo[stone]
        new_stones[@memo[stone][0]] += count
        new_stones[@memo[stone][1]] += count
      else
        base10 = Math.log10(stone).floor + 1
        if base10.even?
          left, right = stone / 10.pow(base10/2), stone % 10.pow(base10/2)
          new_stones[left] += count
          new_stones[right] += count
          @memo[stone] = [left, right]
        else
          new_stones[stone*2024] += count
        end
      end
    end

    @stones = new_stones
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
