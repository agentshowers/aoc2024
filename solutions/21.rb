require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day21 < Base
  DAY = 21

  PATHS = {
    "0" => {"1"=>["^<"], "2"=>["^"], "3"=>["^>", ">^"], "4"=>["^^<"], "5"=>["^^"], "6"=>["^^>", ">^^"], "7"=>["^^^<"], "8"=>["^^^"], "9"=>["^^^>", ">^^^"], "A"=>[">"]}, 
    "1" => {"0"=>[">v"], "2"=>[">"], "3"=>[">>"], "4"=>["^"], "5"=>["^>", ">^"], "6"=>["^>>", ">>^"], "7"=>["^^"], "8"=>["^^>", ">^^"], "9"=>["^^>>", ">>^^"], "A"=>[">>v"]}, 
    "2" => {"0"=>["v"], "1"=>["<"], "3"=>[">"], "4"=>["^<", "<^"], "5"=>["^"], "6"=>["^>", ">^"], "7"=>["^^<", "<^^"], "8"=>["^^"], "9"=>["^^>", ">^^"], "A"=>["v>", ">v"]}, 
    "3" => {"0"=>["v<", "<v"], "1"=>["<<"], "2"=>["<"], "4"=>["^<<", "<<^"], "5"=>["^<", "<^"], "6"=>["^"], "7"=>["^^<<", "<<^^"], "8"=>["^^<", "<^^"], "9"=>["^^"], "A"=>["v"]}, 
    "4" => {"0"=>[">vv"], "1"=>["v"], "2"=>["v>", ">v"], "3"=>["v>>", ">>v"], "5"=>[">"], "6"=>[">>"], "7"=>["^"], "8"=>["^>", ">^"], "9"=>["^>>", ">>^"], "A"=>[">>vv"]}, 
    "5" => {"0"=>["vv"], "1"=>["v<", "<v"], "2"=>["v"], "3"=>["v>", ">v"], "4"=>["<"], "6"=>[">"], "7"=>["^<", "<^"], "8"=>["^"], "9"=>["^>", ">^"], "A"=>["vv>", ">vv"]}, 
    "6" => {"0"=>["vv<", "<vv"], "1"=>["v<<", "<<v"], "2"=>["v<", "<v"], "3"=>["v"], "4"=>["<<"], "5"=>["<"], "7"=>["^<<", "<<^"], "8"=>["^<", "<^"], "9"=>["^"], "A"=>["vv"]}, 
    "7" => {"0"=>[">vvv"], "1"=>["vv"], "2"=>["vv>", ">vv"], "3"=>["vv>>", ">>vv"], "4"=>["v"], "5"=>["v>", ">v"], "6"=>["v>>", ">>v"], "8"=>[">"], "9"=>[">>"], "A"=>[">>vvv"]}, 
    "8" => {"0"=>["vvv"], "1"=>["vv<", "<vv"], "2"=>["vv"], "3"=>["vv>", ">vv"], "4"=>["v<", "<v"], "5"=>["v"], "6"=>["v>", ">v"], "7"=>["<"], "9"=>[">"], "A"=>["vvv>", ">vvv"]}, 
    "9" => {"0"=>["vvv<", "<vvv"], "1"=>["vv<<", "<<vv"], "2"=>["vv<", "<vv"], "3"=>["vv"], "4"=>["v<<", "<<v"], "5"=>["v<", "<v"], "6"=>["v"], "7"=>["<<"], "8"=>["<"], "A"=>["vvv"]},
    "A"=>{"0"=>["<"], "1"=>["^<<"], "2"=>["^<", "<^"], "3"=>["^"], "4"=>["^^<<"], "5"=>["^^<", "<^^"], "6"=>["^^"], "7"=>["^^^<<"], "8"=>["^^^<", "<^^^"], "9"=>["^^^"], "<"=>["v<<"], ">"=>["v"], "^"=>["<"], "v"=>["v<", "<v"]},
    "<" => {">"=>[">>"], "^"=>[">^"], "v"=>[">"], "A"=>[">>^"]}, 
    ">" => {"<"=>["<<"], "^"=>["^<", "<^"], "v"=>["<"], "A"=>["^"]},
    "^"=>{"<"=>["v<"], ">"=>["v>", ">v"], "v"=>["v"], "A"=>[">"]}, 
    "v" => {"<"=>["<"], ">"=>[">"], "^"=>["^"], "A"=>["^>", ">^"]},
  }

  def initialize(type = "example")
    @lines = Parser.lines(DAY, type)
    @cache = {}
  end

  def one
    solve(2)
  end

  def two
    solve(25)
  end

  def solve(robots)
    @lines.map do |line|
      line.to_i * solve_line(line, robots)
    end.sum
  end

  def solve_line(line, robots)
    return line.length if robots < 0
    total = 0
    total += count_paths("A", line[0], robots)
    line.chars.each_cons(2) do |a, b|
      total += count_paths(a, b, robots)
    end
    total
  end

  def count_paths(source, dest, robots)
    @cache["#{source},#{dest},#{robots}"] ||= begin
      paths = source == dest ? [""] : PATHS[source][dest]
      paths.map do |p|
        solve_line(p + "A", robots - 1)
      end.min
    end
  end
end
