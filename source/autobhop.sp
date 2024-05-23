#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.0"

bool g_Bhop[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
    name = "[L4D2] Server-Side Auto Bunnyhop",
    author = "Vanilla",
    description = "Automatically enables bunnyhopping for players.",
    version = PLUGIN_VERSION,
    url = "https://github.com/V3nilla"
};

public OnPluginStart()
{
    RegConsoleCmd("sm_bhop", Cmd_Bhop);
}

public Action:Cmd_Bhop(int client, int args)
{
    if (!IsPlayerAdmin(client))
    {
        PrintToChat(client, "[Auto Bunnyhop] You dont have permission to use this command!");
        return Plugin_Handled;
    }

    g_Bhop[client] = !g_Bhop[client];

    if (g_Bhop[client])
    {
        PrintToChat(client, "[Auto Bunnyhop] AutoBhop is now ENABLED.");
    }
    else
    {
        PrintToChat(client, "[Auto Bunnyhop] AutoBhop is now DISABLED.");
    }

    return Plugin_Handled;
}

public Action:OnPlayerRunCmd(int client, int &buttons)
{
    if (client > 0 && g_Bhop[client] && IsPlayerAlive(client))
    {
        if ((buttons & IN_JUMP) && !(GetEntProp(client, Prop_Send, "m_fFlags") & FL_ONGROUND))
        {
            buttons &= ~IN_JUMP;
        }
    }
    return Plugin_Continue;
}

bool IsPlayerAdmin(int client)
{
    return GetUserFlagBits(client) & ADMFLAG_ROOT;
}
