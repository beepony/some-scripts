# /usr/bin/ruby -w
# coding:utf-8
# dig the domain and bucket banding in UPYUN
# https://github.com/bluemonk/net-dns

require 'net/dns'
require 'json'

# 将给定的 url dig 出来 answer 里的第一条解析记录
def dig_dns(url)
    packet = Net::DNS::Resolver.start("#{url}")
    r = packet.answer[0].to_s.split(" ")
    print "#{r[0].to_s.chop}  " "#{r[4].to_s.split(".")[0]}\n"
end

# 将泛域名里面的 * 替换成 test，以符合域名解析规则
def subt(str)
	if str.include? '*'
		str.sub('*','upyun')
	else
		str
	end
end

# 包含域名的文件作为参数输入
# filename = ARGV[0]
filename = 'yuming.txt'
def afile(filename)
	File.open(filename,'r') do |f|
		f.each do |line|
			line.split(' ').each {|s|
				 dig_dns(subt(s)) 
			}
		end
	end
end

afile(filename)
