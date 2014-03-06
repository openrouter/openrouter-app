--[[
LuCI - Lua Configuration Interface - aria2 support

Script by animefans_xj @ nowvideo.dlinkddns.com (af_xj@yahoo.com.cn)
Based on luci-app-transmission and luci-app-upnp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

require("luci.sys")
require("luci.util")

local running=(luci.sys.call("pidof aria2c > /dev/null") == 0)
local button=""
if running then
	button="&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"button\" value=\" " .. translate("Open Aria2 Web Interface") .. " \" onclick=\"window.open('http://'+window.location.host+'/yaaw')\"/>"
end

m=Map("aria2",translate("Aria2 Downloader"),translate("Use this page, you can download files from HTTP FTP and BitTorrent via Aria2.") .. button)

s=m:section(TypedSection,"aria2",translate("Global"))
s.addremove=false
s.anonymous=true
enable=s:option(Flag,"enabled",translate("Enabled"))
enable.rmempty=false
--[[function enable.cfgvalue(self,section)
	return luci.sys.init.enabled("aria2") and self.enabled or self.disabled
end
function enable.write(self,section,value)
	if value == "1" then
		luci.sys.call("/etc/init.d/aria2 enable >/dev/null")
		luci.sys.call("/etc/init.d/aria2 start >/dev/null")
	else
		luci.sys.call("/etc/init.d/aria2 stop >/dev/null")
		luci.sys.call("/etc/init.d/aria2 disable >/dev/null")
	end
end]]--
user=s:option(ListValue,"user",translate("Run daemon as user"))
local list_user
for _, list_user in luci.util.vspairs(luci.util.split(luci.sys.exec("cat /etc/passwd | cut -f 1 -d :"))) do
	user:value(list_user)
end
--[[event_poll]]--
event_poll=s:option(ListValue,"event_poll",translate("Event Poll"),translate("Specify the method for polling events. The possible values are epoll, kqueue, port, poll and select. For each epoll, kqueue, port and poll, it is available if system supports it. epoll is available on recent Linux. kqueue is available on various *BSD systems including Mac OS X. port is available on Open Solaris. The default value may vary depending on the system you use."))
event_poll:value("epoll", translate("epoll"))
event_poll:value("kqueue", translate("kqueue"))
event_poll:value("port", translate("port"))
event_poll:value("poll", translate("poll"))
event_poll:value("select", translate("select"))
event_poll.rmempty=false
event_poll.placeholder="epoll"
--[[log Enable]]--
logEnable = s:option(Flag,"logEnable",translate("Log Enabled"),translate("Enable log"))
logEnable.rmempty = false

--[[log Size]]--
logSize = s:option(ListValue,"logSize",translate("Log Size"), translate("Bytes"))
logSize:depends("logEnable",1)
logSize:value("64000", translate("64KB"))
logSize:value("128000", translate("128KB"))
logSize:value("256000", translate("256KB"))
logSize:value("512000", translate("512KB"))
logSize.rmempty=false
logSize.placeholder="256000"

--[[Log  level]]--
logSize = s:option(ListValue,"Loglevel",translate("Log Level"))
logSize:depends("logEnable",1)
logSize:value("debug", translate("Debug"))
logSize:value("info", translate("Info"))
logSize:value("notice", translate("Notice"))
logSize:value("warn", translate("Warn"))
logSize:value("error", translate("Error"))
logSize.rmempty=false
logSize.placeholder="notice"

--[[check_integrity]]--
check_integrity = s:option(Flag,"check_integrity",translate("Check Integrity"),translate("Check file integrity by validating piece hashes or a hash of entire file"))
check_integrity.rmempty = false

--[[Continue?]]--
Continue = s:option(Flag,"Continue",translate("Continue"),translate("Continue downloading a partially downloaded file."))
Continue.rmempty = false

--[[file_allocation : aria2 param : file_allocation ]]--
file_allocation = s:option(ListValue, "file_allocation", translate("File Allocation"), translate("none: doesn't pre-allocate file space. prealloc:pre-allocates file space before download begins.This may take some time depending on the size ofthe file.If you are using newer file systems such as ext4(with extents support), btrfs, xfs or NTFS(MinGW build only), falloc is your bestchoice. It allocates large(few GiB) filesalmost instantly. Don't use falloc with legacyfile systems such as ext3 and FAT32 because ittakes almost same time as prealloc and itblocks aria2 entirely until allocation finishes.falloc may not be available if your system doesn't have posix_fallocate() function.trunc : uses ftruncate() system call or platform-specific counterpart to truncate a file to a specified length."))
file_allocation:value("none","none")
file_allocation:value("prealloc","prealloc")
file_allocation:value("trunc","trunc")
file_allocation:value("falloc","falloc")
file_allocation.rmempty=false
file_allocation.placeholder="falloc"

         --[[Enable_mmap  ]]--
Enable_mmap = s:option(Flag,"Enable_mmap",translate("Enable MMap"),translate("Map files into memory"))
Enable_mmap.rmempty = false
Enable_mmap:depends("file_allocation", "prealloc")
Enable_mmap:depends("file_allocation", "trunc")
Enable_mmap:depends("file_allocation", "falloc")

--[[disk_cache : aria2 param : disk_cache ]]--
disk_cache = s:option(ListValue, "disk_cache", translate("Disk Cache"), translate("Disk Cache Size"))
disk_cache:value("1M","1M")
disk_cache:value("2M","2M")
disk_cache:value("3M","3M")
disk_cache.rmempty=false
disk_cache.placeholder="1M"

--[[min_split_size : aria2 param : min_split_size]]--
min_split_size = s:option(ListValue, "min_split_size", translate("Min split size"), translate("MB The min size to split the file to pieces to download"))
min_split_size:value("10M","10M")
min_split_size:value("20M","20M")
min_split_size:value("30M","30M")
min_split_size.rmempty = false
min_split_size.placeholder = "30M"

location=m:section(TypedSection,"aria2",translate("Location"))
location.addremove=false
location.anonymous=true
config_dir=location:option(Value,"config_dir",translate("Config Directory"))
config_dir.placeholder="/mnt/sda1/.Programs/aria2"
download_dir=location:option(Value,"download_dir",translate("Download Directory"))
download_dir.placeholder="/mnt/sda1/Downloads"

task=m:section(TypedSection,"aria2",translate("Task"))
task.addremove=false
task.anonymous=true
restore_task=task:option(Flag,"restore_task",translate("Restore unfinished task when boot"))
restore_task.rmempty=false
--[[load_cookies]]--
load_cookies=task:option(Flag,"load_cookies", translate("Load Cookies from FILE using the Firefox3 format and Mozilla/Firefox(1.x/2.x)/Netscape format.(Aria2Cookies.cookies)"))
load_cookies.rmempty = false
--[[ save_interval : aria2 param : --auto-save-interval ]]--
save_interval=task:option(Value,"save_interval",translate("Save interval"),translate("In seconds, 0 means unsave and let tasks can't be restore"))
save_interval:value("5","5")
save_interval:value("10","10")
save_interval:value("20","20")
save_interval:value("30","30")
save_interval:value("40","40")
save_interval:value("50","50")
save_interval:value("60","60")
save_interval.rmempty=true
save_interval.placeholder="60"
save_interval.datatype="range(0,600)"
--[[ queue_size : aria2 param : -j ]]--
queue_size=task:option(Value,"queue_size",translate("Download queue size"))
queue_size:value("1","1")
queue_size:value("2","2")
queue_size:value("3","3")
queue_size:value("4","4")
queue_size:value("5","5")
queue_size.rmempty=true
queue_size.placeholder="2"
queue_size.datatype="range(1,20)"
--[[ split : aria2 param : -s ]]--
split=task:option(Value,"split",translate("Blocks of per task"))
split:value("1","1")
split:value("2","2")
split:value("3","3")
split:value("4","4")
split:value("5","5")
split:value("6","6")
split:value("7","7")
split:value("8","8")
split:value("9","9")
split.rmempty=true
split.placeholder="5"
split.datatype="range(1,20)"
--[[ thread : aria2 param : -x ]]--
thread=task:option(ListValue,"thread",translate("Download threads of per server"))
thread:value("1","1")
thread:value("2","2")
thread:value("3","3")
thread:value("4","4")
thread:value("5","5")
thread:value("6","6")
thread:value("7","7")
thread:value("8","8")
thread:value("9","9")
thread:value("10","10")

--[[force_save ]]--
force_save=task:option(Flag, "force_save", translate("Force Save"), translate("Save download with --save-session option even if the download is completed or removed"))
force_save.rmempty = false


--[[max_tries]]--
max_tries=task:option(Value, "max_tries", translate("Max Trie Times"), translate("Max Try Times,0 Means No Limit"))
max_tries:value("0","NoLimit")
max_tries:value("10","10Times")
max_tries:value("20","10Times")
max_tries.rmempty=false
max_tries.placeholder="0"
max_tries.datatype="range(0,1000)"

--[[max_tries]]--
retry_wait=task:option(Value, "retry_wait", translate("Retry Wait Time"), translate("Retry Wait Time SEC"))
retry_wait:value("20","20Seconds")
retry_wait:value("30","30Seconds")
retry_wait:value("60","1Minute")
retry_wait.rmempty=false
retry_wait.placeholder="20"

network=m:section(TypedSection,"aria2",translate("Network"))
network.addremove=false
network.anonymous=true
disable_ipv6=network:option(Flag,"disable_ipv6",translate("Disable IPv6"))
disable_ipv6.rmempty=false
enable_lpd=network:option(Flag,"enable_lpd",translate("Enable Local Peer Discovery"))
enable_lpd.rmempty=false
enable_dht=network:option(Flag,"enable_dht",translate("Enable DHT Network"))
enable_dht.rmempty=false
listen_port=network:option(Value,"listen_port",translate("Port for BitTorrent"))
listen_port.placeholder="6882"
listen_port.datatype="range(1,65535)"
download_speed=network:option(Value,"download_speed",translate("Download speed limit"),translate("In KB/S, 0 means unlimit"))
download_speed.placeholder="0"
download_speed.datatype="range(0,100000)"
upload_speed=network:option(Value,"upload_speed",translate("Upload speed limit"),translate("In KB/S, 0 means unlimit"))
upload_speed.placeholder="0"
upload_speed.datatype="range(0,100000)"

rpc=m:section(TypedSection,"aria2",translate("Remote Control"))
rpc.addremove=false
rpc.anonymous=true
rpc_auth=rpc:option(Flag,"rpc_auth",translate("Use RPC Auth"))
rpc_auth.rmempty=false
rpc_user=rpc:option(Value,"rpc_user",translate("User name"))
rpc_user.placeholder="admin"
rpc_user:depends("rpc_auth",1)
rpc_password=rpc:option(Value,"rpc_password",translate("Password"))
rpc_password.placeholder="admin"
rpc_password:depends("rpc_auth",1)

advanced=m:section(TypedSection,"aria2",translate("Advanced"))
advanced.addremove=false
advanced.anonymous=true
    --[[user_agent]]
user_agent=advanced:option(Value, "user_agent", translate("User Agent"), translate("Specify User Agent"))
user_agent.placeholder = "Transmission/2.72 (13582)"

    --[[peer_id_prefix]]
peer_id_prefix=advanced:option(Value, "peer_id_prefix", translate("Peer ID Prefix"), translate("Specify The Prefix Of Peer ID"))
peer_id_prefix.placeholder = "-TR2720-"

extra_cmd=advanced:option(Flag,"extra_cmd",translate("add extra commands"))
extra_cmd.rmempty=false
cmd_line=advanced:option(Value,"cmd_line",translate("Command-Lines"),translate("To check all commands availabled, visit:") .. "&nbsp;<a onclick=\"window.open('http://'+window.location.host+'/aria2/help.htm')\" style=\"cursor:pointer\"><font color='blue'><i><u>http://aria2.sourceforge.net/manual/en/html/index.html</u></i></font></a>")
cmd_line:depends("extra_cmd",1)

return m


