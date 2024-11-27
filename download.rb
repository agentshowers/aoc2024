#!/usr/bin/env ruby

require 'net/http'
require 'erb'
require 'dotenv'

Dotenv.load

day = ARGV[0]

def download(day)
  uri = URI("https://adventofcode.com/#{ENV['YEAR']}/day/#{day}/input")
  req = Net::HTTP::Get.new(uri)
  req['Cookie'] = "session=#{ENV['COOKIE']}"
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) { |http| http.request(req) }
  File.open("input/#{day}.txt", 'w') do |file|
    file.write(res.body)
  end
end

if day
  download(day)
else
  (1..25).to_a.each { |d| download(d) }
end
