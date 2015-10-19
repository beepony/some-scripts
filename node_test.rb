# /usr/bin/ruby
# coding:utf-8
# puts the headers by proxy

require 'restclient'

# accept the argv
puts "Please input the Proxy: "
$proxy = STDIN.gets

puts "Please input the URL: "
$url = STDIN.gets


# restclient proxy
RestClient.proxy = "http://#{$proxy}"

res = RestClient::Resource.new "#{$url}"

# print the headers by key,value
hds = res.get.headers
hds.each do |k,v| puts "#{k}: #{v}" end




