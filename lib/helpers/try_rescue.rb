def try(times = 1, options = {}, &block)
  val = yield
rescue (options[:on] || Exception) => e
  puts "************ Rescued something! #{e} (#{e.class})!"
  puts e.backtrace
  retry if (times -= 1) > 0 and e.class != Interrupt
else
  val
end


# Usage

=begin
try 3 do
  open 'http://foobar.com'
end
try 5, :on => ArgumentError do
  something
end
=end
