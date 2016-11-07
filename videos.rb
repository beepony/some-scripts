# !/usr/bin/ruby -w
# this script is for testing zip and unzip features in upyun storage
require 'base64'
require 'json'
require 'digest'
require 'uri'
require 'net/http'

# 请求接口
uri = URI('http://p0.api.upyun.com/pretreatment/')

# 操作员选项
$operator = "xxx"
$password = "xxx"
$bucket_name = "xxx"
$source = "/a.mp4"
$notify_url = "http://xxx.com"

# 音视频处理参数，类型是数组
video_params = [
	{
	"type" => "probe"
	#{}"avopts" => "/ht/6",
	#{}"return_info" => true
	#{}"save_as" => "test_json.mp4"
	#{}"type" => 'probe'
}
]


# 转换 json 之后，生成 base64 编码字符串，使用 strict 模式
def tasks(params)
	Base64.strict_encode64(params.to_json)
end

# 签名认证需要用到的参数组，需要按照字典顺讯排列，否则提示签名错误
params = {

	:accept => "json",
	:bucket_name => "#{$bucket_name}",
	:notify_url => "#{$notify_url}",
	:source => "#{$source}",
	:tasks => "#{tasks(video_params)}",
}

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

# 设置 POST data 请求体
request.set_form_data(params)

# 设置响应信息
res = Net::HTTP.start(uri.hostname,uri.port) do |http|
	http.request(request)
end

# 输出每一个响应头
puts res.code,res.msg,res.body
res.header.each_header {|k,v| puts "#{k}:#{v}"}
