# /usr/bin/ruby
# coding:utf-8
# purge in ruby

bucket = demo-bucket
password = demo-password
uri-list = "http://"

uri = 'http://purge.upyun.com/purge/'
res = RestClient::Resource.new ("#{uri}", opts)

opts = {

	 :Authorization => #{auth},
     :Date => #{gmdate},
     :purge => #{url-list},
}

gmdate = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')

sign = "#{uri-list}&#{bucket}&#{gmdate}&#{md5(password)}"

auth = "UpYun #{bucket}:#{password}:#{md5(sign)}"

def md5(str)
  Digest::MD5.hexdigest("str")
end


  


