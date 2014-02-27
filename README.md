OpenRouter-APP
=============

Some extend packages for OpenWrt

Add "src-git openrouter-app git://github.com/openrouter/openrouter-app.git" to feeds.conf.default.

```bash
./scripts/feeds update -a
./scripts/feeds install -a
```

the list of packages:
* luci-app-aira2 (make package/feeds/extra/luci-extra)
* yaaw (make package/feeds/extra/yaaw)
