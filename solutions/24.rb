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
    swaps = []
    find_s_ins_and_c_inits

    c_tmp1 = find(1, "AND", "C_out", 0, "S", 1)
    @source[c_tmp1] = "C_tmp01"
    c_out1 = find(1, "OR", "C_init", 1, "C_tmp", 1)
    @source[c_out1] = "C_out01"

    (2..44).each do |i|
      s_out = find(i, "XOR", "C_out", i-1, "S", i)
      z_str = str("z", i)
      if !s_out
        if find(i, "XOR", "C_init", i, "C_out", i-1)
          c_init = @source.key(str("C_init", i))
          s_in = @source.key(str("S", i))
          swap(c_init, s_in)
          swaps += [c_init, s_in]
        end
      elsif s_out != z_str
        swap(z_str, s_out)
        swaps += [z_str, s_out]
      end

      c_tmp = find(i, "AND", "C_out", i-1, "S", i)
      @source[c_tmp] = str("C_tmp", i)
      c_out = find(i, "OR", "C_init", i, "C_tmp", i)
      @source[c_out] = str("C_out", i) 
    end
    swaps.sort.join(",")
  end

  def find_s_ins_and_c_inits
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
end
