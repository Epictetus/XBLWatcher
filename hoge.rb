file = File.open('/Users/humptydumptyegg/.xblwatcher/message.conf')
file.each do |line|
	puts line
end
file.close
