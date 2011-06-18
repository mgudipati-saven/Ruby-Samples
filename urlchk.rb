#!/usr/bin/ruby
 
require 'net/http'
require 'net/smtp'
 
# Checks availabilty of a website.
# Uses a txt file to look for url list.
 
$urlfile = ARGV[0]
if $urlfile && File.exist?($urlfile)
  File.open($urlfile).each do |line|
  	# get rid of CRLF
  	line.chomp!

    # skip comments and empty lines
  	next if(line[0..0] == '#' || line.empty?)

  	url = line
    STDERR.print "."
    
  	# check if http:// was in the url, if not add it in there
  	url.insert(0, "http://") unless(url.match(/^https?\:\/\//))

  	# Get the HTTP response from the site we are checking
    begin
  	  res = Net::HTTP.get_response(URI.parse(url.to_s))
    rescue Timeout::Error => e
      STDERR.print "#{url} timedout"
      next
    rescue Exception => e
      STDERR.print "#{url} exception #{e}"
      next
    end
    
  	# Check the response code
  	unless(res.code =~ /2|3\d{2}/) then
  		STDOUT.puts "#{url} Unavailable - #{res.code}:#{res.message}"
  	end
  end # File.open
end # if File.exist?