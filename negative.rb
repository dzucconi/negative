#!/usr/bin/env ruby

class Object
  def let() yield self end
  def identity()  self end
end # Object

class Hash
  def reverse_merge!(hsh)
    merge!(hsh) { |key, l, r| l }
  end

  def over_reverse_merge!(hsh)
    reject! { |k, v| v.nil? }.reverse_merge!(hsh)
  end
end # Hash

class Decoder
  DECODER = %q{eval("%s".split(/\n/).map(&:size).pack("C*"))}

  def self.decode(i)
    i.split(/\n/).map(&:size).pack("C*")
  end
end # Decoder

class Encoder
  DIR = File.dirname(File.expand_path(__FILE__))

  class << self
    def encode(i)
      i.unpack("C*").map { |x| " " * x }.join("\n")
    end

    def output(i, options={})
      options.over_reverse_merge!({ filename: "output.rb" })

      encode(i).let do |encoded|
        File.open("#{DIR}/#{options[:filename]}", "w") do |file|
          file << Decoder::DECODER % encoded
        end

        $stdout << "Output: #{options[:filename]}\n"
      end
    end

    def run(i, o)
      output(File.read(i), { filename: o })
    end
  end # self
end # Encoder

# Run
unless $0 == "irb"
  begin
    Encoder.run($*[0], $*[1])
  rescue ArgumentError
    $stdout << "Argument missing: filename\n"
  end
end
