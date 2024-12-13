require "./lib/parser.rb"
require "./lib/base.rb"

class Day1 < Base
  DAY = 1

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @list1 = []
    @list2 = []
    lines.each do |line|
      a, b = line.split("   ")
      @list1 << a.to_i
      @list2 << b.to_i
    end
    @list1.sort!
    @list2.sort!
  end

  def one
    @list1.zip(@list2).map do |a, b|
      (a - b).abs
    end.sum
  end

  def two
    j = 0
    @list1.map do |n|
      count = 0
      while j < @list2.length && @list2[j] <= n
        count += 1 if @list2[j] == n
        j += 1
      end
      count * n
    end.sum
  end
end
