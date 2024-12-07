#!/usr/bin/env ruby

Dir["./solutions/*.rb"].each {|file| require file }

raise StandardError.new("Missing day") if !ARGV[0]

type = ARGV[1] || "example"

clazz = Object.const_get("Day#{ARGV[0]}")
t1 = Time.now
day = clazz.new(type)
day.print_one
day.print_two
t2 = Time.now
time = 1000.0 * (t2 - t1)
puts "took #{time.round(2).to_s} ms"