--[[
-
]]--

module("luci.controller.aria2", package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("aria2")
	if not nixio.fs.access("/etc/config/aria2") then
		return
	end

	local page = entry({"admin", "services", "aria2"}, cbi("aria2"), _("Aria2 Settings"))
	page.dependent = true

end
