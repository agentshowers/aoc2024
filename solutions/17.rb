require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day17 < Base
  DAY = 17

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @original_a = lines[0].scan(/\d+/)[0].to_i
    @instructions = lines[4].scan(/\d+/).map(&:to_i)
  end

  def one
    simulate(@original_a).join(",")
  end

  def two
    idx = @instructions.length - 1
    valids = [0]
    while idx >= 0
      new_valids = []
      valids.each do |a|
        (0..7).each do |i|
          vs = simulate(a + i)
          new_valids << (a + i) * (idx == 0 ? 1 : 8) if vs[0] == @instructions[idx]
        end
      end
      valids = new_valids.uniq
      idx -= 1
    end
    valids.min
  end

  def simulate(a_value)
    @A = a_value
    @B = 0
    @C = 0
    i = 0
    values = []
    while i < @instructions.length
      jump, out = apply(@instructions[i], @instructions[i+1])
      values << out if out
      if jump
        i = jump
      else
        i += 2
      end
    end
    values
  end

  def apply(operation, operand)
    jump, output = nil
    case operation
    when 0
      @A = @A / 2.pow(combo(operand))
    when 1
      @B = @B ^ operand
    when 2
      @B = combo(operand) % 8
    when 3
      jump = operand if @A != 0
    when 4
      @B = @B ^ @C
    when 5
      output = combo(operand) % 8
    when 6
      @B = @A / 2.pow(combo(operand))
    when 7
      @C = @A / 2.pow(combo(operand))
    end
    [jump, output]
  end

  def combo(operand)
    case operand
    when 4
      @A
    when 5
      @B
    when 6
      @C
    else
      operand
    end
  end
end
