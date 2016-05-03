#include <amxmodx>
#include <amxmisc>

#define WEB_BASE_URL "http://localhost"
#define WEB_FILENAME "webcommands"

new g_ConfigsDir[64]
new g_IniPath[128]
new g_WebBase[64]
new g_WebBaseCvar

new Array:g_WebCommands

public plugin_init()
{
	register_plugin("Register Web URI Commands", "1.0", "pvab")
	g_WebBaseCvar = create_cvar("web_base_url", WEB_BASE_URL)
	g_WebCommands = ArrayCreate(32)
}

public plugin_cfg()
{
	get_configsdir(g_ConfigsDir, sizeof(g_ConfigsDir) - 1)

	server_cmd("exec %s/%s.cfg", g_ConfigsDir, WEB_FILENAME)
	server_exec()

	formatex(g_IniPath, sizeof(g_IniPath) - 1, "%s/%s.ini", g_ConfigsDir, WEB_FILENAME)
	fileRead(g_IniPath)

	registerUriCommands()
}

public ShowMotd(id)
{
  new arg[32], url[128]

  read_argv(1, arg, sizeof(arg) - 1);
  formatex(url, sizeof(url) - 1, "%s%s", g_WebBase, arg)
  show_motd(id, url)
}

fileRead(filepath[])
{
	if (!file_exists(filepath))
	{
		return PLUGIN_CONTINUE
	}

	new f = fopen(filepath, "rt");

	if (!f)
	{
		return PLUGIN_CONTINUE
	}

	new data[32];

	while (!feof(f))
	{
		fgets(f, data, sizeof(data) - 1);

		if (!data[0] || data[0] == '^n' || data[0] == ';' || data[0] == '/' && data[1] == '/' )
		{
			continue;
		}

		ArrayPushString(g_WebCommands, data)
	}

	fclose(f);

	return true
}

registerUriCommands()
{
	new command[32], cntWebCommands;

	cntWebCommands = ArraySize(g_WebCommands)
	get_pcvar_string(g_WebBaseCvar, g_WebBase, sizeof(g_WebBase) - 1)

	for (new i = 0; i < cntWebCommands; i++)
	{
		formatex(command, sizeof(command) - 1, "say /%a", ArrayGetStringHandle(g_WebCommands, i))
		register_clcmd(command, "ShowMotd")
	}

	return ArrayDestroy(g_WebCommands)
}
