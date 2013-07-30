```bash
Usage: ruby negative [OPTION]...

Encode .rb files as whitespace
    -f, --filename [FILENAME]        Input filename
    -o, --output [FILENAME]          Ouput filename
    -z, --[no-]reader                Include reader
```

```ruby
eval("                                                                                                                
                                                                                                                     
                                                                                                                    
                                                                                                                   
                                
                                  
                                                                              
                                                                                                               
                                
                                                                                                      
                                                                                                                     
                                                                                                                    
                                                                                                                     
                                                                                                                  
                                                                                                     
                                              
                                  ".split(/\n/).map(&:size).pack("C*"))
# => No future.
```
