--[[
LuCI - Lua Configuration Interface - pptpd support

Script by admin @ www.nvacg.com (af_xj@hotmail.com)

Licensed under the Apache License, Version 2.0 (the "license");
you may not use this file except in compliance with the License.
you may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.pptpd",package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("pptpd")
	if not nixio.fs.access("/etc/config/pptpd") then
		return
	end
	
	local page = entry({"admin","services","pptpd"},cbi("pptpd"),_("VPN Service"))
	page.i18n="pptpd"
	page.dependent=true
end
