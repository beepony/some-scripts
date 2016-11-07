# !/usr/bin/ruby -w
# this script is for testing zip and unzip features in upyun storage
require 'base64'
require 'json'
require 'digest'
require 'uri'
require 'net/http'


uri = URI('http://p0.api.upyun.com/pretreatment/')

# 操作员选项
$bucket_name = 'xxx'
$operator = "xxx"
$password = "xxx"
$app_name = "compress"
$notify_url = "http://xxx:3000/notify"

# 压缩参数

zip = [
	{
	  :sources => ["/test.jpg","/cat.gif"],
	  :save_as => "/aa/zip.zip"
	}
]

=begin
# 解压参数
unzip = [
	{
		:source  => "/test_zip/heheda.zip",
		:save_as => "/result/t/"
	}
]
=end
# 转换 json 之后，生成 base64 编码字符串
def tasks(params)
	Base64.strict_encode64(params.to_json)
end

# 需要用到的参数组
params = {
	app_name: "#{$app_name}",
	bucket_name: "#{$bucket_name}",
	notify_url: "#{$notify_url}",
	tasks: "#{tasks(zip)}"
}

puts params
def md5(str)
	Digest::MD5.hexdigest(str.encode("utf-8"))
end

def gmdate
  Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
end

def signature(params)
	str = params.map{|key,value| "#{key}#{value}"}.join
	md5($operator + "#{str}" + md5($password))
end

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
res.header.each_header {|k,v| puts "#{k}:#{v}"}


