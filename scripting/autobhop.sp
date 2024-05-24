#pragma semicolon               1
#pragma newdecls                required

#include <sourcemod>

#define PLUGIN_VERSION "1.1"

bool g_Bhop[MAXPLAYERS + 1] = {false, ...};

ConVar g_cvAutoEnable = null;

public Plugin myinfo = 
{
    name =        "[L4D2] Server-Side Auto Bunnyhop",
    author =      "Vanilla, TouchMe",
    description = "Allows admins to enable autobhop.",
    version =     PLUGIN_VERSION,
    url =         "https://github.com/V3nilla/L4D2-Server-Side-AutoBhop"
};

public void OnPluginStart()
{
    LoadTranslations("autobhop.phrases");
    
    RegConsoleCmd("sm_bhop", Cmd_Bhop);
    
    g_cvAutoEnable = CreateConVar("sm_autobhop_autoenable", "0");
}

Action Cmd_Bhop(int client, int args)
{
    if (!IsPlayerAdmin(client))
    {
        PrintToChat(client, "%T%T", "Tag", client, "No Permission", client);
        return Plugin_Handled;
    }

    PrintToChat(client, "%T%T",
        "Tag", client,
        (g_Bhop[client] = !g_Bhop[client]) ? "AutoBhop Enabled" : "AutoBhop Disabled", client
    );

    return Plugin_Handled;
}

public Action OnPlayerRunCmd(int client, int &buttons)
{
    if (client && g_Bhop[client] && IsPlayerAlive(client) && buttons & IN_JUMP
    && ~GetEntProp(client, Prop_Send, "m_fFlags") & FL_ONGROUND && GetEntityMoveType(client) != MOVETYPE_LADDER)
    {
        buttons &= ~IN_JUMP;
    }

    return Plugin_Continue;
}

public void OnClientPostAdminCheck(int client)
{
    if (!GetConVarBool(g_cvAutoEnable) || !IsClientInGame(client) || IsFakeClient(client) || !IsPlayerAdmin(client)) {
        return;
    }

    g_Bhop[client] = true;
}

public void OnClientDisconnect(int client)
{
    g_Bhop[client] = false;
}

bool IsPlayerAdmin(int client)
{
    return view_as<bool>(GetUserFlagBits(client) & ADMFLAG_ROOT);
}
