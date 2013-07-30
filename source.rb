#!/usr/bin/env ruby

require "optparse"

class Object
  def let() yield self end

  def identity() self end
end # Object

class Hash
  def reverse_merge!(hsh)
    merge!(hsh) { |key, l, r| l }
  end
end # Hash

class Decoder
  DECODER = %q{eval("%s".split(/\n/).map(&:size).pack("C*"))}

  def self.decode(i)
    i.split(/\n/).map(&:size).pack("C*")
  end
end # Decoder

class Encoder
  DEFAULTS = { output: "output.rb", reader: true }

  class << self
    def encode(i)
      i.unpack("C*").map { |x| " " * x }.join("\n")
    end

    def output(i, options={})
      encode(i).let do |encoded|
        File.open("#{File.dirname(File.expand_path(__FILE__))}/#{options[:output]}",
                  "w") do |file|
          file << (options[:reader] ? Decoder::DECODER % encoded : encoded)
        end

        $stdout << "Output: #{options[:output]}\n"
      end
    end

    def run(i, options={})
      output(File.read(i), options)
    end
  end # self
end # Encoder

# Run
unless $0 == "irb"
  begin
    {}.tap do |options|
      OptionParser.new do |opts|
        opts.banner = "Usage: ./negative [OPTION]...\n\nEncode .rb files as whitespace"

        [
          ["-f", "--filename [FILENAME]", String, "Input filename", :filename],
          ["-o", "--output [FILENAME]", String, "Ouput filename", :output],
          ["-z", "--[no-]reader", "Include reader", :reader]
        ].

        each do |args|
          args.pop.let do |key|
            opts.on(*args) do |value|
              options[key] = value
            end
          end
        end
      end.parse!
    end.let do |options|
      options.reverse_merge!(Encoder::DEFAULTS)

      raise ArgumentError if options[:filename].nil?

      Encoder.run(options[:filename], options)
    end
  rescue ArgumentError
    $stdout << "Missing -f\n"
  rescue => e
    $stdout << "#{e}\n"
  end
end