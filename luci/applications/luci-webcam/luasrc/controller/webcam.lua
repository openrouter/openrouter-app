--[[
RA-MOD
]]--

module("luci.controller.webcam", package.seeall)

function index()


	if nixio.fs.access("/etc/config/mjpg-streamer") then
	local page

	page = entry({"admin", "Extend","webcam"}, cbi("webcam"), _("webcam"), 60)
	page.i18n = "webcam"
	page.dependent = true
	end
end
