task default: :compile

desc "Compile source file to negative executable"
task :compile do
  # Run source.rb through itself to output negative
  `ruby source.rb -f source.rb -o negative -x`
  # Make executable
  `chmod 755 negative`
end
