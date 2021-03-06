/*****************************************************************
*                            MADE BY
*
*   K   K   RRRRR    U     U     CCCCC    3333333      1   3333333
*   K  K    R    R   U     U    C     C         3     11         3
*   K K     R    R   U     U    C               3    1 1         3
*   KK      RRRRR    U     U    C           33333   1  1     33333
*   K K     R        U     U    C               3      1         3
*   K  K    R        U     U    C     C         3      1         3
*   K   K   R         UUUUU U    CCCCC    3333333      1   3333333
*
******************************************************************
*                       AMX MOD X Script                         *
*     You can modify the code, but DO NOT modify the author!     *
******************************************************************
*
* Description:
* ============
* This is a plugin for Counte-Strike 1.6's Zombie Plague Mod which shows score and alive humans/zombies at top of the screen.
*
*****************************************************************/

#include <amxmodx>
#include <fakemeta>
#include <zombieplague>

enum (+= 100)
{
	TASK_SHOWHUD2 = 3000
}

#define ID_SHOWHUD2 (taskid - TASK_SHOWHUD2)

const PEV_SPEC_TARGET = pev_iuser2
new nowin, zwin, hwin, g_Sync

public plugin_init() {
	register_plugin("[ZP] Addon: Score", "1.0", "kpuc313")
	
	register_event("TextMsg","RoundRestart","a","2=#Game_will_restart_in")
	register_event("TextMsg","RoundRestart","a","2=#Game_Commencing")
	
	g_Sync = CreateHudSyncObj()
}

public client_putinserver(id)
{
	set_task(1.0, "ShowHUD2", id+TASK_SHOWHUD2, _, _, "b")
}

public client_disconnect(id)
{
	remove_task(id+TASK_SHOWHUD2)
}

public RoundRestart() {
	nowin = 0
	zwin = 0
	hwin = 0
}

public ShowHUD2(taskid)
{
	static id, name[32]
	id = ID_SHOWHUD2;
	new hcount = zp_get_human_count();
	new zcount = zp_get_zombie_count();
	
	// Player died?
	if (!is_user_alive(id))
	{
		// Get spectating target
		id = pev(id, PEV_SPEC_TARGET)
		get_user_name(id, name, charsmax(name))
		
		// Target not alive
		if (!is_user_alive(id)) return;
	}
	
	// Spectating someone else?
	if (id != ID_SHOWHUD2)
	{
		set_hudmessage(255, 255, 255, -1.0, 0.0, 0, 6.0, 1.1, 0.0, 0.0, -1)
		ShowSyncHudMsg(ID_SHOWHUD2, g_Sync, "HU %s%d [%s%d] %s%d ZM^n[%s%d vs %s%d]", hwin >= 10 ? "" : "0", hwin, nowin >= 10 ? "" : "0", nowin, zwin >= 10 ? "" : "0", zwin, hcount >= 10 ? "" : "0", hcount, zcount >= 10 ? "" : "0", zcount)
	}
	else
	{
		set_hudmessage(255, 255, 255, -1.0, 0.0, 0, 6.0, 1.1, 0.0, 0.0, -1)
		ShowSyncHudMsg(ID_SHOWHUD2, g_Sync, "HU %s%d [%s%d] %s%d ZM^n[%s%d vs %s%d]", hwin >= 10 ? "" : "0", hwin, nowin >= 10 ? "" : "0", nowin, zwin >= 10 ? "" : "0", zwin, hcount >= 10 ? "" : "0", hcount, zcount >= 10 ? "" : "0", zcount)
	}
}

public zp_round_ended(iTeam)
{
	if (iTeam == WIN_NO_ONE)
		nowin++
	
	if (iTeam == WIN_ZOMBIES)
		zwin++
	
	if (iTeam == WIN_HUMANS)
		hwin++
}
