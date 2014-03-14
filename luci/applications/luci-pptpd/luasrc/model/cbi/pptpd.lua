--[[
LuCI - Lua Configuration Interface - pptpd support

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

local running=(luci.sys.call("pidof pptpd > /dev/null") == 0)

m=Map("pptpd",translate("VPN Service"),translate("This is a web interface to config PPTP service."))

s=m:section(TypedSection,"pptpd",translate("Global"))
s.addremove=false
s.anonymous=true
enable=s:option(Flag,"enabled",translate("Enabled"))
enable.rmempty=false
function enable.cfgvalue(self,section)
	return luci.sys.init.enabled("pptpd") and self.enabled or self.disabled
end
function enable.write(self,section,value)
	if value == "1" then
    if running then
      luci.sys.call("/etc/init.d/pptpd stop >/dev/null")
    end
		luci.sys.call("/etc/init.d/pptpd enable >/dev/null")
		luci.sys.call("/etc/init.d/pptpd start >/dev/null")
	else
		luci.sys.call("/etc/init.d/pptpd stop >/dev/null")
		luci.sys.call("/etc/init.d/pptpd disable >/dev/null")
	end
end

ip=m:section(TypedSection,"pptpd",translate("IP"))
ip.addremove=false
ip.anonymous=true
ip.template="cbi/tblsection"

basic_ip=ip:option(Value,"basic_ip",translate("Basic IP"))
basic_ip.placeholder="172.16.1"
start_ip=ip:option(Value,"start_ip",translate("Start from"))
start_ip.placeholder="2"
start_ip.datatype="range(2,250)"
end_ip=ip:option(Value,"end_ip",translate("End to"))
end_ip.placeholder="250"
end_ip.datatype="range(2,250)"

users=m:section(TypedSection,"ppp",translate("Users"))
users.addremove=true
users.anonymous=true
users.template="cbi/tblsection"
users.sortable=false

user=users:option(Value,"user",translate("UserName"))
pass=users:option(Value,"pass",translate("Password"))
usere=users:option(Flag,"enable",translate("Enabled"))

return m
