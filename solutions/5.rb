require "./lib/parser.rb"
require "./lib/base.rb"

class Day5 < Base
  DAY = 5

  def initialize(type = "example")
    a, b = Parser.read(DAY, type).split("\n\n")
    predecessors = {}
    a.split("\n").each do |line|
      l, r = line.split("|").map(&:to_i)
      predecessors[r] ||= []
      predecessors[r] << l
    end
    numbers = b.split("\n").map { |n| n.split(",").map(&:to_i) }

    @result = calculate(predecessors, numbers)
  end

  def calculate(predecessors, numbers)
    numbers.map do |ns|
      valid = true
      middle = nil
      ns.each_with_index do |n, i|
        p_count = predecessors[n].intersection(ns).length
        valid = false if p_count > i
        middle = n if p_count == ns.length/2
      end
      [valid, middle]
    end
  end

  def one
    @result.map do |valid, middle|
      valid ? middle : 0
    end.sum
  end

  def two
    @result.map do |valid, middle|
      valid ? 0 : middle
    end.sum
  end
end
