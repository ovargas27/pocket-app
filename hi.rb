require 'sinatra'
require 'uri'
require 'net/http'


set :consumer_key, '10717-2f516ebeba469d892cb3ce9a'


get '/' do
  "Hello World!"
end

get '/callback' do
  puts "================="
  puts request.body
  puts "-----------------"
  puts request.inspect
  puts "================="
  "redirected -- #{request.body}"
end

get '/login' do
  url= URI.parse('https://getpocket.com/v3/oauth/request')
  req = Net::HTTP::Post.new(url.path)
  req.set_form_data({'consumer_key' => settings.consumer_key, 'redirect_uri' => 'callback'})

  sock = Net::HTTP.new(url.host, url.port)
  sock.use_ssl = true
  res = sock.start {|http| http.request(req) }


  puts "============="
  res = res.body.match( /^code=(.*)$/ )
  puts ".............."
  puts res
  puts ".............."
  code = res[1]
  puts code
  puts "-------------"
  puts res.inspect
  puts "============="

  redirect to("https://getpocket.com/auth/authorize?request_token=#{code}&redirect_uri=http://localhost:4567/callback")
  redirect to('/bar')

end
