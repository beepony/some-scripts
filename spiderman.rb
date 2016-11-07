#!/usr/bin/ruby 
# coding:utf-8
# a common signature for upyun api

require 'base64'
require 'json'
require 'digest'
require 'uri'
require 'net/http'

# 操作员选项
$operator = "bin"
$password = "binisbin"

# 异步拉取参数
pull = [{
  :url => "http://nicholasjohnson.com/images/sections/ruby.png",
  :random => false,
  :overwrite => true,
  :save_as => "/spidermantest/mamayaya.png"
}]

# 转换 json 之后，生成 base64 编码字符串
def tasks(params)
	Base64.strict_encode64(params.to_json)
end

# 需要用到的参数组
params = {
	app_name: "spiderman",
	bucket_name: "binimg",
	notify_url: "http://xiaolai-xuexi.com:3000/echo",
	tasks: "#{tasks(pull)}"
}


def md5(str)
	Digest::MD5.hexdigest(str.encode("utf-8"))
end

def gmdate
  Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
end
# 通过 hash 的 map 和 join 方法，将 hash 的 key、value 转换成 string 
def signature(params)
	str = params.map{|key,value| "#{key}#{value}"}.join
	md5($operator + "#{str}" + md5($password))
end

uri = URI('http://p0.api.upyun.com/pretreatment/')

# 设置下 request header
headers = {
	:Authorization => "UPYUN bin:#{signature(params)}",
	:Date => "#{gmdate}",
	:User_Agent => "beepony"
}

# 初始化请求对象
request = Net::HTTP::Post.new uri

# 设置 POST 请求头 
request["Authorization"] = "UPYUN #{$operator}:#{signature(params)}"
request["Date"] = "#{gmdate}"
request["User-Agent"] = 'beepony'

p request["Authorization"]
# 设置 POST data 请求体
request.set_form_data(params)

# 设置响应信息
res = Net::HTTP.start(uri.hostname,uri.port) do |http|
	http.request(request)
end

# 输出每一个响应头
puts res.code,res.msg,res.body
