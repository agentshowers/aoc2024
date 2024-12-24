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
    @source = {}
    gates.split("\n").each_with_index do |gate, idx|
      a, b, c, d = gate.scan(/([\w\d]+) (OR|XOR|AND) ([\w\d]+) -> ([\w\d]+)/)[0]
      @source[d] = [a, b, c]
    end
  end

  def one
    (0..45).map do |i|
      2.pow(i) * value("z#{i.to_s.rjust(2,"0")}")
    end.sum
  end

  def value(gate)
    @vars[gate] ||= begin
      a, b, c = @source[gate]
      value(a).send(OPS[b], value(c))
    end
  end

  def two
    ["swt", "pqc", "wsv", "bgs", "rjm", "z07", "z13", "z31"].sort.join(",")
  end

  def test
    # swap("swt", "z07")
    # swap("pqc", "z13")
    # swap("wsv", "rjm")
    # swap("bgs", "z31")
    text = @z_keys.map do |z|
      "#{z} = #{ppp(z)}"
    end
    File.write("out", text.join("\n"))
  end

  def swap(a, b)
    tmp = @source[a]
    @source[a] = @source[b]
    @source[b] = tmp
  end

  def ppp(var)
    return var if var.start_with?("x") || var.start_with?("y")
    a, op, b = @source[var]
    if (a.start_with?("x") || a.start_with?("y")) && (b.start_with?("x") || b.start_with?("y"))
      name = op == "XOR" ? "X" : "A"
      "#{name}#{a.delete("xy")}"
    else
      a = ppp(a)
      b = ppp(b)
      if a.start_with?("X") || b.start_with?("(")
        "(#{a} #{op} #{b})"
      else
        "(#{b} #{op} #{a})"
      end
    end
  end

  def solve(gates, vars)
    while !gates.empty?
      dest, a, op, b = gates.shift
      if vars[a] && vars[b]
        vars[dest] = vars[a].send(OPS[op], vars[b])
      else
        gates << [dest, a, op, b]
      end
    end
    @z_keys.map { vars[_1].to_s }.join.to_i(2)
  end
end
