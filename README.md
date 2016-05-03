# amxmodx-plugin-webcommands

> Register client commands to show web URLs

## Notes

* Only commands specified in `webcommands.ini` will be registered
* A client command will be appended to a base URL specified in the `web_base_url` CVAR  
  The resulting URL will be shown to the client in a MOTD window
* `web_base_url` may be set in `webcommands.cfg`

It would be wise to choose unique client commands that have no chance of conflicting with existing plugins on your server

## Variables

### `WEB_BASE_URL`

Default CVAR value for base URL. A sensible initial value has been set

### `kz_web_base`

CVAR for base URL

## Usage

### `webcommands.cfg`

Config file where the `web_base_url` CVAR value may be stored

### `webcommands.ini`

Config file where client commands are registered

---

Both `webcommands.ini` and `webcommands.cfg` config files should be placed in the config directory. If building with [amxmodx-build](https://github.com/tenub/amxmodx-build), file copy is handled automatically
