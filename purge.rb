# /usr/bin/ruby
# coding:utf-8
# purge in ruby

require 'rest-client'
require 'json'
===================================================
bucket = 'bucket'
operator = 'operator'
password = 'password'
purge_api = 'http://purge.upyun.com/purge/'
purge_list = "http://bucket.b0.upaiyun.com/test.jpg"
===================================================

def md5(str)
  Digest::MD5.hexdigest(str)
end

gmdate = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')

sign = md5("#{uri_list}&#{bucket}&#{gmdate}&#{md5(password)}")

auth = "UpYun #{bucket}:#{operator}:#{sign}"

headers = {'Authorization' => auth,'Date' => gmdate}

payload = {'purge' => uri_list}

#puts headers,payload

res = RestClient.post uri,payload,headers

puts res.headers,res.body
#hds.each do |k,v| puts "#{k}:#{v}" end  


