module("luci.controller.nwan", package.seeall)

function index()

	if nixio.fs.access("/etc/config/nwan") then

	local page 	
	page = entry({"admin", "services", "nwan"}, cbi("nwan/nwan"), _("N-WAN"),50)
	page.i18n = "nwan"
	page.dependent = true
	end

	if nixio.fs.access("/etc/config/nwannumset") then
	local page 
	page = entry({"admin", "Extend", "nwannumset"}, cbi("nwan/nwannumset"), _("macvlan"), 59)
	page.i18n = "nwan"
	page.dependent = true
	end


end
