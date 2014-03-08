local fs = require "nixio.fs"
local util = require "nixio.util"
local dnsfilter_status=(luci.sys.call("[ -f /etc/dnsmasq.conf ]") == 0)
local button=""
------------------------------------------------------------------------
if dnsfilter_status then
	m = Map("dnsfilter", translate("DNS-Filter"), translate("过滤规则 [已启用]") .. button)
else
	m = Map("dnsfilter", translate("DNS-Filter"), translate("过滤规则 [未启用]"))
end
------------------------------------------------------------------------
s = m:section(TypedSection, "dnsfilter", translate("配置DNS过滤器"))
s.anonymous = true

s:tab("basic",  translate("基本设置"))
------------------------------------------------------------------------
button_update = s:taboption("basic", Button, "_button_update" ,"手动更新")
button_update.inputtitle = translate("更新过滤规则")
button_update.inputstyle = "apply"
function button_update.write(self, section)
	luci.sys.call("screen -S DNS -dm bash dns update")
end
------------------------------------------------------------------------
enable = s:taboption("basic", Flag, "enabled", translate("启用 DNS-Filter"))
enable.rmempty = false

adblock = s:taboption("basic", Flag, "adblock", translate("启用 AdBlock规则订阅"))
adblock.rmempty = false

hosts = s:taboption("basic", Flag, "hosts", translate("启用 HOSTS规则订阅"))
hosts.rmempty = false

autoupdate = s:taboption("basic", Flag, "autoupdate", translate("启用 每天自动更新"))
autoupdate.rmempty = false

proxy = s:taboption("basic", Flag, "proxy", translate("使用代理更新"))
proxy.rmempty = false
--AdBlock---------------------------------------------------------------
s:tab("editconf_adblock", translate("AdBlock订阅列表"))
editconf_adblock = s:taboption("editconf_adblock", Value, "_editconf_adblock", 
	translate("在右侧编辑订阅的规则列表"), 
	translate("注释用“ # ”"))
editconf_adblock.template = "cbi/tvalue"
editconf_adblock.rows = 20
editconf_adblock.wrap = "off"

function editconf_adblock.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/conf/adb_rules.txt") or ""
end
function editconf_adblock.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/adb_rules.txt", value)
		if (luci.sys.call("cmp -s /tmp/adb_rules.txt /etc/DNS-Filter/conf/adb_rules.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/conf/adb_rules.txt", value)
		end
		fs.remove("/tmp/adb_rules.txt")
	end
end
--HOSTS-----------------------------------------------------------------
s:tab("editconf_hosts", translate("HOSTS订阅列表"))
editconf_hosts = s:taboption("editconf_hosts", Value, "_editconf_hosts", 
	translate("在右侧编辑订阅的规则列表"), 
	translate("注释用“ # ”"))
editconf_hosts.template = "cbi/tvalue"
editconf_hosts.rows = 20
editconf_hosts.wrap = "off"

function editconf_hosts.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/conf/hosts_rules.txt") or ""
end
function editconf_hosts.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/hosts_rules.txt", value)
		if (luci.sys.call("cmp -s /tmp/hosts_rules.txt /etc/DNS-Filter/conf/hosts_rules.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/conf/hosts_rules.txt", value)
		end
		fs.remove("/tmp/hosts_rules.txt")
	end
end
--Block-----------------------------------------------------------------
s:tab("editconf_block", translate("本地过滤规则"))
editconf_block = s:taboption("editconf_block", Value, "_editconf_block", 
	translate("在右侧编辑过滤规则"), 
	translate("注释用“ # ”"))
editconf_block.template = "cbi/tvalue"
editconf_block.rows = 20
editconf_block.wrap = "off"

function editconf_block.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/block.txt") or ""
end
function editconf_block.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/block.txt", value)
		if (luci.sys.call("cmp -s /tmp/block.txt /etc/DNS-Filter/block.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/block.txt", value)
		end
		fs.remove("/tmp/block.txt")
	end
end
--Fix-------------------------------------------------------------------
s:tab("editconf_fix", translate("本地解析规则"))
editconf_fix = s:taboption("editconf_fix", Value, "_editconf_fix", 
	translate("在右侧编辑过滤规则"), 
	translate("注释用“ # ”"))
editconf_fix.template = "cbi/tvalue"
editconf_fix.rows = 20
editconf_fix.wrap = "off"

function editconf_fix.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/fix.txt") or ""
end
function editconf_fix.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/fix.txt", value)
		if (luci.sys.call("cmp -s /tmp/fix.txt /etc/DNS-Filter/fix.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/fix.txt", value)
		end
		fs.remove("/tmp/fix.txt")
	end
end
--Hijacking-------------------------------------------------------------
s:tab("editconf_hijacking", translate("本地防DNS劫持规则"))
editconf_hijacking = s:taboption("editconf_hijacking", Value, "_editconf_hijacking", 
	translate("在右侧编辑过滤规则"), 
	translate("注释用“ # ”"))
editconf_hijacking.template = "cbi/tvalue"
editconf_hijacking.rows = 20
editconf_hijacking.wrap = "off"

function editconf_hijacking.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/Prevent_DNS_Hijacking.txt") or ""
end
function editconf_hijacking.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/Prevent_DNS_Hijacking.txt", value)
		if (luci.sys.call("cmp -s /tmp/Prevent_DNS_Hijacking.txt /etc/DNS-Filter/Prevent_DNS_Hijacking.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/Prevent_DNS_Hijacking.txt", value)
		end
		fs.remove("/tmp/Prevent_DNS_Hijacking.txt")
	end
end
--White List------------------------------------------------------------
s:tab("editconf_whitelist", translate("白名单"))
editconf_whitelist = s:taboption("editconf_whitelist", Value, "_editconf_whitelist", 
	translate("在右侧编辑过滤规则"), 
	translate("注释用“ # ”"))
editconf_whitelist.template = "cbi/tvalue"
editconf_whitelist.rows = 20
editconf_whitelist.wrap = "off"

function editconf_whitelist.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/white_list.txt") or ""
end
function editconf_whitelist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/white_list.txt", value)
		if (luci.sys.call("cmp -s /tmp/white_list.txt /etc/DNS-Filter/white_list.txt") == 1) then
			fs.writefile("/etc/DNS-Filter/white_list.txt", value)
		end
		fs.remove("/tmp/white_list.txt")
	end
end
--Log-------------------------------------------------------------------
s:tab("editconf_log", translate("程序日志"))
editconf_log = s:taboption("editconf_log", Value, "_editconf_log")
editconf_log.template = "cbi/tvalue"
editconf_log.rows = 20
editconf_log.wrap = "off"
editconf_log.rmempty = false

function editconf_log.cfgvalue(self, section)
	return fs.readfile("/etc/DNS-Filter/log/dns_update.log") or ""
end
function editconf_log.write(self, section, value)
end
------------------------------------------------------------------------
return m
