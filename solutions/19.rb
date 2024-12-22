require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day19 < Base
  DAY = 19

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @trie = {
      "word_end" => false,
      "children" => {}
    }
    lines[0].split(', ').each do |pattern|
      insert(pattern, 0, @trie["children"])
    end
    @cache = {}
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
    return 1 if design.length == 0
    @cache[design] ||= begin
      total = 0
      i = 0
      children = @trie["children"]
      while i < design.length && children[design[i]]
        node = children[design[i]]
        total += counts(design[i+1..]) if node["word_end"]
        children = node["children"]
        i += 1
      end
      total
    end
  end

  def insert(pattern, index, trie)
    char = pattern[index]
    trie[char] ||= {
      "word_end" => false,
      "children" => {}
    }
    if index == pattern.length - 1
      trie[char]["word_end"] = true
    else
      insert(pattern, index + 1, trie[char]["children"])
    end
  end
end
