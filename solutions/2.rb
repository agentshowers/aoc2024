require "./lib/parser.rb"
require "./lib/base.rb"

class Day2 < Base
  DAY = 2

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @input = lines.map do |line|
      line.split(" ").map(&:to_i)
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
    (0..ns.length-2).each do |i|
      return false unless safe_pair(ns[i], ns[i+1], dir)
      dir = (ns[i+1] - ns[i]) <=> 0
    end
    true
  end

  def safe_pair(a, b, dir)
    return false if (a-b).abs > 3 || a == b
    return false if dir && ((b - a) <=> 0) != dir
    true
  end
end
