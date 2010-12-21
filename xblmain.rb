require 'rubygems'
require 'Mechanize'

$LOAD_PATH << File.dirname(__FILE__)
require "xblagent.rb"
require "xblwatcher.rb"
require "xblrubytter.rb"
require "xblconfig.rb"

$KCODE = "UTF-8"

# 設定ファイルの読み込み
config = XBLWatcherConfig.new

# プロキシ使用時
#proxy_host = 'proxy.fun.ac.jp'
#proxy_port = 8080
#$xblrubytter = XboxLiveRubytter.new(config.accountHash['Twitter_ACCESS_TOKEN'], config.accountHash['Twitter_ACCESS_TOKEN_SECRET'], 'http://' + proxy_host + ':' + proxy_port.to_s)
#agent = XboxLiveAgent.new(config.accountHash['XBL_MailAddress'], config.accountHash['XBL_Password'], proxy_host, proxy_port) 
#watcher = XboxLiveWatcher.new(agent, config)

# Twitter通信クラスを初期化
$xblrubytter = XboxLiveRubytter.new(config.accountHash['Twitter_ACCESS_TOKEN'], config.accountHash['Twitter_ACCESS_TOKEN_SECRET'])

#XboxLiveAgentはXboxLiveとの通信を行います
agent = XboxLiveAgent.new(config.accountHash['XBL_MailAddress'], config.accountHash['XBL_Password']) 

#XboxLiveWatcherはXboxLiveAgentの通信結果を使って実績やステータスの監視を行います
watcher = XboxLiveWatcher.new(agent, config)

begin
	# 最終起動時刻が12時間前より前だった場合、情報の更新だけする
	if watcher.lastActivateTime < Time.now - (60*60*12) then
		puts '最終起動時刻より12時間経過しているのでデータの更新だけをおこなう'
		watcher.reloadXBL(agent)
	else
		watcher.watchXBL(agent, $xblrubytter, config.messageHash)
	end
	watcher.saveWatcher()
rescue
	puts 'Twitter関係以外の部分で予期せぬエラー'
	puts $!
	puts $@
rescue GetHTMLError
	puts 'HTMLの取得に失敗しました'
end
