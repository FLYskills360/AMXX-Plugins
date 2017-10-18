/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <hamsandwich>

#define PLUGIN  "Alive Player"
#define VERSION "1.0"
#define AUTHOR  "Advanced"

#define TASK_GETPLAYER     37852
#define SetBits(%1,%2)       %1 |= 1<<(%2 & 31)
#define ClearBits(%1,%2)   %1 &= ~(1<<(%2 & 31))
#define GetBits(%1,%2)       %1 &  1<<(%2 & 31)

new g_bitAlive
new g_SyncTeam1
new g_SyncTeam2
new g_iMaxPlayers

public plugin_init() 
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    
    RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn", 1)
    RegisterHam(Ham_Killed, "player", "fw_PlayerKilled", 1)
    
    g_SyncTeam1 = CreateHudSyncObj()
    g_SyncTeam2 = CreateHudSyncObj()
    g_iMaxPlayers = get_maxplayers()
    
    set_task(0.5, "GetPlayer", TASK_GETPLAYER, _, _, "b")
}

public client_putinserver(id)
{
    ClearBits(g_bitAlive, id)
}

public client_disconnect(id)
{
    ClearBits(g_bitAlive, id)
}

public fw_PlayerSpawn(id)
{
    if(is_user_alive(id))
    {
        SetBits(g_bitAlive, id)
    }
}

public fw_PlayerKilled(id)
{
    ClearBits(g_bitAlive, id)
}

public GetPlayer()
{
    static id, iTeam
    new iPlayerTrroNum, iPlayerCtNum
    
    for(id = 1; id <= g_iMaxPlayers; id++)
    {
        if(GetBits(g_bitAlive, id))
        {
            iTeam = get_user_team(id)
            
            switch(iTeam)
            {
                case 1: ++iPlayerTrroNum
                    
                case 2: ++iPlayerCtNum
                    
            }
            ShowCustomSync(id, g_SyncTeam1, "[Alive Hiders: %d]", 171, 0, 0, 0.15, 1, iPlayerTrroNum)
            ShowCustomSync(id, g_SyncTeam2, "[Alive Seekers: %d]", 11, 0, 171, 0.79, 2, iPlayerCtNum)
        }
    }
}

ShowCustomSync(id, SyncType, Msg[], Red, Green, Blue, Float:xPos, Channel, TeamCount) 
{
    set_hudmessage(Red, Green, Blue, xPos, 0.04, _, _, 2.0, _,  _, Channel)
    ShowSyncHudMsg(id, SyncType, Msg, TeamCount)
}  