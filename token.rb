
require 'time'
require 'digest/md5'

bucket = 'binimg'
expirate_time = 30
etime = Time.now.to_i + expirate_time
form_key = 'beepony'
path = '/test'
# MD5 生成的时候，一定要用双引号 Digest::MD5.hexdigest("string")
sign = Digest::MD5.hexdigest("#{form_key}&#{etime}&#{path}")[12,8]+ etime.to_s
uri = "http://#{bucket}.b0.upaiyun.com#{path}?_upt=#{sign}"

puts uri
