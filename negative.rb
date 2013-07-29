#!/usr/bin/env ruby

begin
  dir     = File.dirname(File.expand_path(__FILE__))
  input   = ARGV[0]

  raise ArgumentError if input.nil?

  encoded   = File.read(input).unpack("C*").map { |x| " " * x }.join("\n")
  reader    = %q{eval("%s".split(/\n/).map(&:size).pack("C*"))}

  File.open(dir + "/_#{input}", "w") do |f|
    f << reader % encoded
  end

  puts "Output: _#{input}"
rescue ArgumentError
  puts "Argument missing: filename"
end
