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

public plugin_precache()
{
	get_configsdir(g_szConfigsName, charsmax(g_szConfigsName))
	formatex(g_szFilename, charsmax(g_szFilename), "%s/AutoCommandExec.ini", g_szConfigsName)
	formatex(g_szTempFile, charsmax(g_szTempFile), "%s/TempFile.ini", g_szConfigsName)
	g_tPlayerData = TrieCreate()
	g_tRemovedData = TrieCreate()
	fileRead(0)
}

public plugin_end()
{
	fileRead(1)
}

public fileRead(iWrite)
{
	new iFilePointer = fopen(g_szFilename, "rt")
	new iTempFilePointer = fopen(g_szTempFile, "wt")

	new szData[512], szType[6], szInfo[32], szCommand[128], szRepeat[4], szMessage[192], szSetData[380]

	if(iWrite)
	{
		new szHelp[192]

		for(new i; i < sizeof(g_szFileHelp); i++)
		{
			formatex(szHelp, charsmax(szHelp), ";%s^n", g_szFileHelp[i])
			fputs(iTempFilePointer, szHelp)
		}
	}

	while(!feof(iFilePointer))
	{
		fgets(iFilePointer, szData, charsmax(szData))

		if(!iWrite)
			replace(szData, charsmax(szData), "^n", "")

		if(szData[0] == EOS || szData[0] == ';')
			continue

		parse(szData, szType, charsmax(szType), szInfo, charsmax(szInfo), szCommand, charsmax(szCommand), szRepeat, charsmax(szRepeat), szMessage, charsmax(szMessage))

		if(is_blank(szInfo))
			continue

		formatex(szSetData, charsmax(szSetData), "^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"", szType, szInfo, szCommand, szRepeat, szMessage)
		if(!TrieKeyExists(g_tRemovedData, szInfo)) TrieSetString(g_tPlayerData, szInfo, szSetData)

		if(iWrite)
		{
			if(TrieKeyExists(g_tPlayerData, szInfo))
				fputs(iTempFilePointer, szData)
		}
	}

	fclose(iFilePointer)
	fclose(iTempFilePointer)

	if(iWrite)
	{
		delete_file(g_szFilename)
		rename_file(g_szTempFile, g_szFilename, 1)
	}
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
