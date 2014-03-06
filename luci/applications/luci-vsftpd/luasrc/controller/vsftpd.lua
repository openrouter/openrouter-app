--[[
RA-MOD
]]--

module("luci.controller.vsftpd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/vsftpd.conf") then
		return
	end

	local page
	page = entry({"admin", "Extend", "vsftpd"}, cbi("vsftpd"), _("vsftpd"), 50)
	page.i18n = "vsftpd"
	page.dependent = true
end
