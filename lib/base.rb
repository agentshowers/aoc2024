require "./lib/parser.rb"
require "./lib/utils.rb"

class Base
  include Utils

  def initialize(type = "example")
    @input = Parser.lines(DAY, type)
  end

  def print_one
    puts one
  end

  def print_two
    puts two
  end
end
