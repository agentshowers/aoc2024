require "./lib/parser.rb"
require "./lib/base.rb"

class Day3 < Base
  DAY = 3

  def initialize(type = "example")
    @line = Parser.read(DAY, type)
  end

  def one
    pairs = @line.scan(/mul\((\d+),(\d+)\)/)
    pairs.map do |a,b|
      a.to_i * b.to_i
    end.sum
  end

  def two
    pairs = @line.scan(/mul\((\d+),(\d+)\)|(do)\(\)|(don\'t)\(\)/)
    enabled = true
    sum = 0
    pairs.each do |a, b, on, off|
      if on
        enabled = true
      elsif off
        enabled = false
      elsif enabled
        sum += a.to_i * b.to_i
      end
    end
    sum
  end
end
