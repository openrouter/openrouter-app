
m = Map("mjpg-streamer", translate("mjpg-streamer webcam"),translate(" webcam mod by xiaobiao. "))

s = m:section(TypedSection, "mjpg-streamer", "")
s.addremove = false
s.anonymous = false

s:tab("general", translate("General Settings"))





e=s:taboption("general",Flag, "enabled", translate("enabled webcam"),translate("enable or disable mjpg-streamer webcam. "))

device=s:taboption("general",Value, "device", translate("device"))

device.rmempty = true
device:value("/dev/video0","/dev/video0")
device:value("/dev/video1","/dev/video1")


resolution=s:taboption("general",Value, "resolution", translate("resolution"))
resolution:value("800x480","800x480")
resolution:value("800x600","800x600")
resolution:value("960x720","960x720")
resolution:value("1280x720","1280x720")
resolution.optional = ture

resolution.rmempty = true

fps=s:taboption("general",Value, "fps", translate("fps"))
device.rmempty = true
fps:value("15","15")
fps:value("20","20")
fps:value("25","25")
fps:value("30","30")

port=s:taboption("general",Value, "port", translate("port"))
port:value("8080","8080")
port.rmempty = true

s:taboption("general",Flag, "PassWordLogin", translate("PassWord Login"),translate("Enable or disable password login webcam."))

username=s:taboption("general",Value, "username", translate("username"))
username:value("root","root")
username.rmempty = true

password=s:taboption("general",Value, "password", translate("password"))
password.rmempty = true
password.password = true

s:taboption("general", DummyValue,"opennewwindow" ,translate("<br /><p align=\"justify\"><script type=\"text/javascript\">function openwindowwebcam(){window.open('http://' + location.hostname + ':' + document.getElementById('cbid.mjpg-streamer.core.port').value )}</script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Open video model\" onclick=\"openwindowwebcam()\" /></p>"))

s:taboption("general", DummyValue,"opennewwindow" ,translate("<br /><p align=\"justify\"><script type=\"text/javascript\">function openwindowwebcam1(){window.open('http://' + location.hostname + ':' + document.getElementById('cbid.mjpg-streamer.core.port').value + '/stream_simple.html','webcam')}</script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Play video with stream\" onclick=\"openwindowwebcam1()\" /></p>"))

s:taboption("general", DummyValue,"opennewwindow" ,translate("<br /><p align=\"justify\"><script type=\"text/javascript\">function openwindowwebcam2(){window.open('http://' + location.hostname + ':' + document.getElementById('cbid.mjpg-streamer.core.port').value + '/javascript_simple.html','webcam')}</script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Play video with javascript\" onclick=\"openwindowwebcam2()\" /></p>"))






function s.parse(self, ...)
	TypedSection.parse(self, ...)
	os.execute("/etc/init.d/mjpg-streamer restart>/var/log/mjpg-streamer.log")
	os.execute("/etc/init.d/mjpg-streamer enable>/var/log/mjpg-streamer.log")
end

return m
