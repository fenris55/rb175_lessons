require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(' ')
  path, params = path_and_params.split('?')

  params = params.split('&').each_with_object({}) do |pair, hash|
    key, value = pair.split('=')
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do 
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  puts request_line

  # my original solution:
  # http_method, middle, version = request_line.split(' ') #gives http_method
  # path, query = middle.split('?') #gives http_version
  # hash_pairs = query.split(/[^a-zA-Z0-9]/).each_slice(2).to_a #creates nested array of key-value els

  # params = Hash.new
  # hash_pairs.each do |key, value| #populates hash with subarray pairs
  #   params[key] = value
  # end

  http_method, path, params  = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  # client.puts "Content-Type: text/plain\r\n\r\n" # from previous
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  # client.puts request_line
  
  #my original solution: 
  # params["rolls"].to_i.times { client.puts rand(params["sides"].to_i) + 1 }
  
  client.puts "<h1>Rolls!</h1>" 
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

   rolls.times do 
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end
  
  client.puts "</body>"
  client.puts "</html>"  
  client.close
end

# NOTE: the logic I used assumes that each param key only hash a single word value. A value
# word1+word2 would end up having the + removing,and the logic that populates the key-value 
# subarray will be thrown off. Works for the present purposes. (Solution uses each_with_object
# and splits first at & and then at =)

# commented out my solution and added the one given by the lesson to ensure it works
# with future assignments. 