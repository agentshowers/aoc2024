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
      a, b = l.split(": ")
      [a, b.to_i]
    end.to_h
    @source = gates.split("\n").map do |gate|
      a, b, c, d = gate.scan(/([\w\d]+) (OR|XOR|AND) ([\w\d]+) -> ([\w\d]+)/)[0]
      [d, [a, b, c]]
    end.to_h
  end

  def one
    (0..45).map do |i|
      2.pow(i) * value(str("z", i))
    end.sum
  end

  def value(gate)
    @vars[gate] ||= begin
      a, b, c = @source[gate]
      value(a).send(OPS[b], value(c))
    end
  end

  def two
    # test
    # return 2
    swaps = []
    find_intermediates
    c_tmp1 = find(1, "AND", "C_out", 0, "S", 1)
    @source[c_tmp1] = "C_tmp01"
    c_out1 = find(1, "OR", "C_init", 1, "C_tmp", 1)
    @source[c_out1] = "C_out01"

    (2..30).each do |i|
      s_out = find(i, "XOR", "C_out", i-1, "S", i)
      z_str = str("z", i)
      if s_out == z_str
        puts "#{i} is valid"
      elsif s_out
        puts "swapping #{z_str} with #{s_out}"
        swap(z_str, s_out)
        swaps << z_str
        swaps << s_out
      end

      c_tmp = find(i, "AND", "C_out", i-1, "S", i)
      puts "c_tmp is #{c_tmp}"
      @source[c_tmp] = str("C_tmp", i)
      c_out = find(i, "OR", "C_init", i, "C_tmp", i)
      puts "c_out is #{c_out}"
      @source[c_out] = str("C_out", i) 
    end
    ["swt", "pqc", "wsv", "bgs", "rjm", "z07", "z13", "z31"].sort.join(",")
  end

  def find_intermediates
    @source.each do |dest, (a, op, b)|
      if "xy".include?(a[0])
        n = a.delete("xy")
        name = op == "XOR" ? "S" : (n == "00" ? "C_out" : "C_init")
        @source[dest] = "#{name}#{n}"
      end
    end
  end

  def find(n, tgt_op, a_str, a_n, b_str, b_n)
    @source.each do |dest, src|
      next if src.is_a?(String)
      a, op, b = src
      next unless @source[a].is_a?(String) && @source[b].is_a?(String)
      return dest if op == tgt_op && [@source[a], @source[b]].sort == [str(a_str, a_n), str(b_str, b_n)]
    end
    nil
  end

  def str(c, n)
    "#{c}#{n.to_s.rjust(2,"0")}"
  end

  def swap(a, b)
    tmp = @source[a]
    @source[a] = @source[b]
    @source[b] = tmp
  end

  def test
    swap("swt", "z07")
    swap("pqc", "z13")
    # swap("wsv", "rjm")
    # swap("bgs", "z31")
    text = @source.keys.select { |k| k.start_with?("z") }.sort.map do |z|
      "#{z} = #{ppp(z)}"
    end
    File.write("out3", text.join("\n"))
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
end
