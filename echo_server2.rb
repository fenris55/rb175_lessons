# notes: second pass 
# initially would not print to browser; fixed by using all double quotes. 
require "socket"

server = TCPServer.new("localhost", 3003) #creates server
loop do 
  client =server.accept # opens connection, creates client object
  
  request_line = client.gets # get first line of request
  puts request_line # prints first line to console

  #chrome needs a correctly fortmatted response, with status code
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"
  client.puts request_line # sends back request_line to client and prints in browser
  client.close # close connection with client
end