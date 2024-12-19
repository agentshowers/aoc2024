require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day19 < Base
  DAY = 19

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @patterns = lines[0].split(', ').map { |x| [x, true] }.to_h
    @max = @patterns.keys.map(&:length).max
    @min = @patterns.keys.map(&:length).min
    @memo = {}
    @result = lines[2..].map do |design|
      counts(design)
    end
  end

  def one
    @result.count { |x| x > 0 }
  end

  def two
    @result.sum
  end

  def counts(design)
    return @memo[design] if @memo[design]
    return 1 if design.length == 0
    count = 0
    (@min..[@max, design.length].min).each do |len|
      key = design[..(len-1)]
      count += counts(design[len..]) if @patterns[key]
    end
    @memo[design] = count
    count
  end
end
