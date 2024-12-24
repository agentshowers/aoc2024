require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day24 < Base
  DAY = 24
  OPS = {
    "OR" => :|,
    "XOR" => :^,
    "AND" => :&
  }

  def initialize(type = "example")
    init, gates = Parser.read(DAY, type).split("\n\n")
    @vars = init.split("\n").map do |l|
      a,b = l.split(": ")
      [a, b.to_i]
    end.to_h
    @z_keys = []
    @gates = gates.split("\n").map.with_index do |gate, idx|
      a, b, c, d = gate.scan(/([\w\d]+) (OR|XOR|AND) ([\w\d]+) -> ([\w\d]+)/)[0]
      @z_keys << d if d.start_with?("z")
      [d, a, OPS[b], c]
    end
    @z_keys.sort!.reverse!
  end

  def one
    vars = solve(@gates.dup, @vars)
    @z_keys.map { vars[_1].to_s }.join.to_i(2)
  end

  def two
    x_keys = @vars.keys.select { _1.start_with?("x") }.sort.reverse
    y_keys = @vars.keys.select { _1.start_with?("y") }.sort.reverse
    2
  end

  def solve(gates, vars)
    while !gates.empty?
      dest, a, op, b = gates.shift
      if vars[a] && vars[b]
        vars[dest] = vars[a].send(op, vars[b])
      else
        gates << [dest, a, op, b]
      end
    end
    vars
  end
end
