module("luci.controller.dnsfilter", package.seeall)

function index()
	local page
	page = entry({"admin", "services", "dnsfilter"}, cbi("dnsfilter"), _("DNS-Filter"), 33)
	page.dependent = true
end
