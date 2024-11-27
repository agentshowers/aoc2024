#!/usr/bin/env ruby

require 'net/http'
require 'erb'
require 'dotenv'

raise StandardError.new("Missing day") if !ARGV[0]

Dotenv.load

day = ARGV[0]
year = ENV['YEAR']

%x{ ./download.rb #{day} #{year} }

# Generate code

TEMPLATE_FILE = 'template.erb'

$day = day

render = ERB.new(File.read(TEMPLATE_FILE),trim_mode: ">")
File.write("solutions/#{day}.rb", render.result)

# Open page

%x{ touch example/#{day}.txt }
%x{ code solutions/#{day}.rb }
%x{ code example/#{day}.txt }

%x{ open -a Firefox 'https://adventofcode.com/#{year}/day/#{day}' }