task default: :compile

desc "Compile source file to negative executable"
task :compile do
  # Run source.rb through itself to output negative
  `ruby source.rb -f source.rb -o negative`
  # Prepend shebang
  `echo "#!/usr/bin/env ruby" | cat - negative > /tmp/out && mv /tmp/out negative`
  # Make executable
  `chmod 755 negative`
end
