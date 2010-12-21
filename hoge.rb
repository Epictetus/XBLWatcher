file = File.open('/Users/humptydumptyegg/.xblwatcher/message.conf')
file.each do |line|
	p line
end
file.close
