require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day23 < Base
  DAY = 23

  def initialize(type = "example")
    @graph = {}
    @pairs = Parser.lines(DAY, type).map { _1.split("-").sort }
    @pairs.each do |a, b|
      @graph[a] ||= []
      @graph[a] << b
      @graph[b] ||= []
      @graph[b] << a
    end
    @graph.each do |k, v|
      @graph[k] = v.sort.map { [_1, true] }.to_h
    end
  end

  def one
    visited = {}
    count = 0
    @graph.keys.select { |x| x.start_with?("t") }.each do |origin|
      @graph[origin].keys.each do |point_a|
        next if visited[point_a]
        @graph[point_a].keys.each do |point_b|
          next if origin == point_b
          next if visited[point_b]
          count += 1 if @graph[point_b][origin]
        end
      end
      visited[origin] = true
    end
    count / 2
  end

  def two
    cliques = find_cliques(Set.new, @graph.keys, Set.new)
    cliques.sort_by { - _1.length }[0].sort.join(",")
  end

  def find_cliques(clique, potential, excluded)
    return [clique] if potential.empty? && excluded.empty?

    cliques = []
    while !potential.empty?
      v = potential.pop
      new_clique = clique.dup << v
      new_potential = potential.intersection(@graph[v].keys)
      new_excluded = excluded.intersection(@graph[v].keys)
      cliques += find_cliques(new_clique, new_potential, new_excluded)
      excluded << v
    end
    cliques
  end
end
