require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day5 < Base
  DAY = 5

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @rules = {}
    @numbers = []
    lines.each do |line|
      if line.include?("|")
        l, r = line.split("|").map(&:to_i)
        @rules[r] ||= []
        @rules[r] << l
      elsif line != ""
        @numbers << line.split(",").map(&:to_i)
      end
    end
  end

  def one
    sum = 0
    @numbers.each do |ns|
      sum += ns[ns.length / 2] if valid?(ns)
    end
    sum
  end

  def valid?(ns)
    forbidden = {}
    ns.each do |n|
      return false if forbidden[n]
      (@rules[n] || []).each { |x| forbidden[x] = true }
    end
    true
  end

  def two
    sum = 0
    @numbers.each do |ns|
      if !valid?(ns)
        sort(ns)
        sum += ns[ns.length / 2]
      end
    end
    sum
  end

  def sort(ns)
    (0..ns.length-2).each do |i|
      changes = false
      loop do
        (i+1..ns.length-1).each do |j|
          if @rules[ns[i]] && @rules[ns[i]].include?(ns[j])
            a = ns[i]
            ns[i] = ns[j]
            ns[j] = a
            changes = true
          else
            changes = false
          end
        end
        break unless changes
      end
    end
  end
end