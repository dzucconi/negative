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
  SHEBANG = "#!/usr/bin/env ruby\n"
  DECODER = %q{eval("%s".split(/\n/).map(&:size).pack("C*"))}

  class << self
    def decode(i)
      i.split(/\n/).map(&:size).pack("C*")
    end

    def run(i)
      begin
        eval(decode(File.read(i)))
      rescue Exception
        $stdout << "Failed.\n"
      end
    end
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
          file << (options[:executable] ? Decoder::SHEBANG : nil)
          file << (options[:reader]     ? Decoder::DECODER % encoded : encoded)
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
          ["-f", "--filename [FILENAME]", String, "input filename", :filename],
          ["-o", "--output [FILENAME]", String, "ouput filename", :output],
          ["-i", "--[no-]input", "use -f as an input to eval", :input],
          ["-z", "--[no-]reader", "include reader", :reader],
          ["-x", "--[no-]executable", "output is executable", :executable]
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
      if options[:input]
        Decoder.run(options[:filename])
      else
        Encoder.run(options[:filename], options)
      end
    end
  rescue ArgumentError
    $stdout << "Missing --filename\n"
  rescue => e
    $stdout << "#{e}\n"
  end
end
