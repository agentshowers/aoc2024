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
    cliques = []
    @graph.keys.each do |v|
      found_clique = false
      cliques.each do |clique|
        if clique.length == 1
          found_clique = @graph[v].keys.intersection(@graph[clique[0]].keys).length > 0
        else
          found_clique = clique.all? { |d| @graph[v][d] }
        end
        if found_clique
          clique << v
          break
        end
      end
      cliques << [v] unless found_clique
    end
    cliques.sort_by { - _1.length }[0].sort.join(",")
  end
end
