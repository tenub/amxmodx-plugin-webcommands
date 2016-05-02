#include <amxmodx>

#define PLUGIN "Register Web URI Commands"
#define VERSION "1.0"
#define AUTHOR "pvab"

#define DEFAULT_WEB_BASE_URL "http://localhost"
#define DEFAULT_WEB_COMMANDS "commands"

new g_WebBase[64], g_WebCommands[512], g_BaseCvar, g_CommandsCvar

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	g_BaseCvar = create_cvar("kz_web_base", DEFAULT_WEB_BASE_URL)
	g_CommandsCvar = create_cvar("kz_web_commands", DEFAULT_WEB_COMMANDS)
	RegisterURICommands()
}

public RegisterURICommands()
{
	new i, command[32];

	get_pcvar_string(g_BaseCvar, g_WebBase, sizeof(g_WebBase) - 1)
	get_pcvar_string(g_CommandsCvar, g_WebCommands, sizeof(g_WebCommands) - 1)

	while ((i = argparse(g_WebCommands, i, command, sizeof(command) - 1)) >= 0) {
		formatex(command, sizeof(command) - 1, "say /%s", command)
		register_clcmd(command, "ShowMotd")
	}
}


public ShowMotd(id)
{
	new arg[32], url[128]

	read_argv(1, arg, sizeof(arg) - 1);
	formatex(url, sizeof(url) - 1, "%s%s", g_WebBase, arg)
	show_motd(id, url)
}
