puts (1..100).map{ |b| c = [b % 3 < 1 ? :fizz : "", b % 5 < 1 ? :buzz : ""] * ""; c == "" ? b : c }.join("\n")