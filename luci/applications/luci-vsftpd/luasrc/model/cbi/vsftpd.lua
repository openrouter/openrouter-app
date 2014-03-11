--[[
LuCI - Lua Configuration Interface - vsftpd support

Script by Admin @ www.NVACG.com (af_xj@hotmail.com , xujun@smm.cn)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

require("luci.sys")
require("luci.util")

local running=(luci.sys.call("pidof vsftpd > /dev/null") == 0)

m=Map("vsftpd",translate("FTP Service"),translate("Use this page, you can share your file under web via ftp."))

s=m:section(TypedSection,"vsftpd",translate("Global"))
s.addremove=false
s.anonymous=true
enable=s:option(Flag,"enabled",translate("Enabled"))
enable.rmempty=false
function enable.cfgvalue(self,section)
	return luci.sys.init.enabled("vsftpd") and self.enabled or self.disabled
end
function enable.write(self,section,value)
	if value == "1" then
	  if running then
		luci.sys.call("/etc/init.d/vsftpd stop >/dev/null")
	  end
		luci.sys.call("/etc/init.d/vsftpd enable >/dev/null")
		luci.sys.call("/etc/init.d/vsftpd start >/dev/null")
	else
		luci.sys.call("/etc/init.d/vsftpd stop >/dev/null")
		luci.sys.call("/etc/init.d/vsftpd disable >/dev/null")
	end
end
banner=s:option(Value,"ftpd_banner",translate("FTP banner"))
banner.rmempty=true
banner.placeholder="OpenWRT Router Embd FTP service."
max_clients=s:option(Value,"max_clients",translate("Max number of clients"))
max_clients.placeholder="10"
max_clients.datatype="range(1,100)"
max_clients.rmempty=false

permissions=m:section(TypedSection,"vsftpd",translate("Permissions"))
permissions.addremove=false
permissions.anonymous=true
local_enabled=permissions:option(Flag,"local_enable",translate("Allow local member"))
local_enabled.rmempty=false
local_write=permissions:option(Flag,"write_enable",translate("Member can write"))
local_write.rmempty=false
local_write:depends("local_enable",1)
local_chown=permissions:option(Flag,"chown_uploads",translate("Allow change permissions"))
local_chown.rmempty=false
local_chown:depends("local_enable",1)
local_chroot=permissions:option(Flag,"chroot_local_user",translate("Enable chroot"))
local_chroot.rmempty=false
local_chroot:depends("local_enable",1)
local_umask=permissions:option(Value,"local_umask",translate("uMask for new uploads"))
local_umask:value("000","000")
local_umask:value("022","022")
local_umask:value("027","027")
local_umask.placeholder="000"
local_umask.datatype="range(0,777)"
local_umask.rmempty=true
local_umask:depends("local_enable",1)
local_userlist=permissions:option(Flag,"userlist_enable",translate("Enable userlist"))
local_userlist.rmempty=false
local_userlist:depends("local_enable",1)
local_userlist_type=permissions:option(ListValue,"userlist_type",translate("Userlist control type"))
local_userlist_type:value("allow","allow")
local_userlist_type:value("deny","deny")

authenticate=m:section(TypedSection,"vsftpd",translate("Authenticate"))
authenticate.addremove=false
authenticate.anonymous=true
anon_enabled=authenticate:option(Flag,"anonymous_enable",translate("Allow anonymous"))
anon_enabled.rmempty=false
anon_upload=authenticate:option(Flag,"anon_upload_enable",translate("Anonymous can upload"))
anon_upload.rmempty=false
anon_upload:depends("anonymous_enable",1)
anon_mkdir=authenticate:option(Flag,"anon_mkdir_write_enable",translate("Anonymous can create folder"))
anon_mkdir.rmempty=false
anon_mkdir:depends("anonymous_enable",1)

userlist=m:section(TypedSection,"vsftpd",translate("Userlist"))
userlist.addremove=false
userlist.anonymous=true
list=userlist:option(DynamicList,"userlist",translate("user"))
for _, list_user in luci.util.vspairs(luci.util.split(luci.sys.exec("cat /etc/passwd | cut -f 1 -d:"))) do
    list:value(list_user)
end

return m
