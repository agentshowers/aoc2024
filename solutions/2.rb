require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day2 < Base
  DAY = 2

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines.map do |line|
      line.scan(/\d+/).map(&:to_i)
    end
  end

  def one
    @input.map do |ns|
      safe(ns)
    end.count { |x| x }
  end

  def two
    @input.map do |ns|
      any_safe(ns)
    end.count { |x| x }
  end

  def any_safe(ns)
    (0..ns.length-1).each do |i|
      arr = ns.dup
      arr.delete_at(i)
      return true if safe(arr)
    end
    false
  end

  def safe(ns)
    dir = nil
    ns.each_cons(2) do |a,b|
      return false unless safe_pair(a, b, dir)
      dir = (b - a) <=> 0
    end
    true
  end

  def safe_pair(a, b, dir)
    return false if (a-b).abs > 3 || a == b
    return false if a > b && dir == 1
    return false if a < b && dir == -1
    true
  end
end