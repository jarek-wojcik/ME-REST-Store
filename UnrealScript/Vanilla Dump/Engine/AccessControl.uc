Class AccessControl extends Info
    config(Game);

var const localized string ACDisplayText[3];
var const localized string ACDescText[3];
var globalconfig array<string> IPPolicies;
var globalconfig array<UniqueNetId> BannedIDs;
var const localized string IPBanned;
var const localized string WrongPassword;
var const localized string NeedPassword;
var const localized string SessionBanned;
var const localized string KickedMsg;
var const localized string DefaultKickReason;
var const localized string IdleKickReason;
var globalconfig string AdminPassword;
var globalconfig string GamePassword;
var Class<Admin> AdminClass;
var bool bDontAddDefaultAdmin;

public function bool ForceKickPlayer(PlayerController C, string KickReason)
{
    if (C != None && NetConnection(C.Player) != None)
    {
        if (C.Pawn != None)
        {
            C.Pawn.Suicide();
        }
        C.ClientWasKicked();
        if (C != None)
        {
            C.Destroy();
        }
        return TRUE;
    }
    return FALSE;
}
public function bool KickPlayer(PlayerController C, string KickReason)
{
    if (C != None && !IsAdmin(C) && NetConnection(C.Player) != None)
    {
        return ForceKickPlayer(C, KickReason);
    }
    return FALSE;
}
public event function PreLogin(string Options, string Address, out string OutError, bool bSpectator)
{
    local string InPassword;
    
    OutError = "";
    InPassword = WorldInfo.Game.ParseOption(Options, "Password");
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && WorldInfo.Game.AtCapacity(bSpectator))
    {
        OutError = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";
    }
    else if (GamePassword != "" && Caps(InPassword) != Caps(GamePassword) && (AdminPassword == "" || Caps(InPassword) != Caps(AdminPassword)))
    {
        OutError = InPassword == "" ? "Engine.AccessControl.NeedPassword" : "Engine.AccessControl.WrongPassword";
    }
    if (!CheckIPPolicy(Address))
    {
        OutError = "Engine.AccessControl.IPBanned";
    }
}
public function AdminEntered(PlayerController P)
{
    local string LoginString;
    
    LoginString = P.PlayerReplicationInfo.PlayerName @ "logged in as a server administrator.";
    WorldInfo.Game.Broadcast(P, LoginString);
}
public function AdminExited(PlayerController P)
{
    local string LogoutString;
    
    LogoutString = P.PlayerReplicationInfo.PlayerName $ "is no longer logged in as a server administrator.";
    WorldInfo.Game.Broadcast(P, LogoutString);
}
public function bool AdminLogin(PlayerController P, string Password)
{
    if (AdminPassword == "")
    {
        return FALSE;
    }
    if (Password == AdminPassword)
    {
        P.PlayerReplicationInfo.bAdmin = TRUE;
        return TRUE;
    }
    return FALSE;
}
public function bool AdminLogout(PlayerController P)
{
    if (P.PlayerReplicationInfo.bAdmin)
    {
        P.PlayerReplicationInfo.bAdmin = FALSE;
        P.bGodMode = FALSE;
        P.Suicide();
        return TRUE;
    }
    return FALSE;
}
public function bool CheckIPPolicy(string Address)
{
    local int i;
    local int J;
    local string Policy;
    local string Mask;
    local bool bAcceptAddress;
    local bool bAcceptPolicy;
    
    J = InStr(Address, ":", , , );
    if (J != -1)
    {
        Address = Left(Address, J);
    }
    bAcceptAddress = TRUE;
    for (i = 0; i < IPPolicies.Length; i++)
    {
        J = InStr(IPPolicies[i], ",", , , );
        if (J == -1)
        {
            continue;
        }
        Policy = Left(IPPolicies[i], J);
        Mask = Mid(IPPolicies[i], J + 1, );
        if (Policy ~= "ACCEPT")
        {
            bAcceptPolicy = TRUE;
        }
        else if (Policy ~= "DENY")
        {
            bAcceptPolicy = FALSE;
        }
        else
        {
            continue;
        }
        J = InStr(Mask, "*", , , );
        if (J != -1)
        {
            if (Left(Mask, J) == Left(Address, J))
            {
                bAcceptAddress = bAcceptPolicy;
            }
            continue;
        }
        if (Mask == Address)
        {
            bAcceptAddress = bAcceptPolicy;
        }
    }
    if (!bAcceptAddress)
    {
    }
    return bAcceptAddress;
}
public function Controller GetControllerFromString(string Target)
{
    local Controller C;
    local Controller FinalC;
    local int i;
    
    FinalC = None;
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        if (C.PlayerReplicationInfo != None && (C.PlayerReplicationInfo.PlayerName ~= Target || C.PlayerReplicationInfo.PlayerName ~= Target))
        {
            FinalC = C;
            break;
        }
    }
    if (C == None && WorldInfo != None && WorldInfo.GRI != None)
    {
        for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
        {
            if (string(WorldInfo.GRI.PRIArray[i].PlayerID) == Target)
            {
                FinalC = Controller(WorldInfo.GRI.PRIArray[i].Owner);
                break;
            }
        }
    }
    return FinalC;
}
public function bool IsAdmin(PlayerController P)
{
    if (P != None)
    {
        if (Admin(P) != None)
        {
            return TRUE;
        }
        if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bAdmin)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool IsIDBanned(const out UniqueNetId NetId)
{
    local int i;
    
    for (i = 0; i < BannedIDs.Length; i++)
    {
        if (BannedIDs[i] == NetId)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function Kick(string Target)
{
    local Controller C;
    
    C = GetControllerFromString(Target);
    if (C != None && C.PlayerReplicationInfo != None)
    {
        if (PlayerController(C) != None)
        {
            KickPlayer(PlayerController(C), DefaultKickReason);
        }
        else if (C.PlayerReplicationInfo.bBot)
        {
            if (C.Pawn != None)
            {
                C.Pawn.Destroy();
            }
            if (C != None)
            {
                C.Destroy();
            }
        }
    }
}
public function KickBan(string Target)
{
    local PlayerController P;
    local string IP;
    
    P = PlayerController(GetControllerFromString(Target));
    if (NetConnection(P.Player) != None)
    {
        if (!WorldInfo.IsConsoleBuild())
        {
            IP = P.GetPlayerNetworkAddress();
            if (CheckIPPolicy(IP))
            {
                IP = Left(IP, InStr(IP, ":", , , ));
                IPPolicies[IPPolicies.Length] = "DENY," $ IP;
                SaveConfig();
            }
        }
        if (P.PlayerReplicationInfo.UniqueId != P.PlayerReplicationInfo.default.UniqueId && !IsIDBanned(P.PlayerReplicationInfo.UniqueId))
        {
            BannedIDs.AddItem(P.PlayerReplicationInfo.UniqueId);
            SaveConfig();
        }
        KickPlayer(P, DefaultKickReason);
        return;
    }
}
public function bool ParseAdminOptions(string Options)
{
    local string InAdminName;
    local string InPassword;
    
    InPassword = Class'GameInfo'.static.ParseOption(Options, "Password");
    InAdminName = Class'GameInfo'.static.ParseOption(Options, "AdminName");
    return ValidLogin(InAdminName, InPassword);
}
public function bool RequiresPassword()
{
    return GamePassword != "";
}
public function bool SetAdminPassword(string P)
{
    AdminPassword = P;
    return TRUE;
}
public function SetGamePassword(string P)
{
    GamePassword = P;
    WorldInfo.Game.UpdateGameSettings();
}
public function bool ValidLogin(string Username, string Password)
{
    return AdminPassword != "" && Password == AdminPassword;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ACDisplayText[0] = "Game Password"
    ACDisplayText[1] = "Access Policies"
    ACDisplayText[2] = "Admin Password"
    ACDescText[0] = "If this password is set, players will have to enter it to join this server."
    ACDescText[1] = "Specifies IP addresses or address ranges which have been banned."
    ACDescText[2] = "Password required to login with administrator privileges on this server."
    IPPolicies = ("ACCEPT;*")
    IPBanned = "Your IP address has been banned on this server."
    WrongPassword = "The password you entered is incorrect."
    NeedPassword = "You need to enter a password to join this game."
    SessionBanned = "Your IP address has been banned from the current game session."
    KickedMsg = "You have been forcibly removed from the game."
    DefaultKickReason = "None specified"
    IdleKickReason = "Kicked for idling."
    AdminClass = Class'Admin'
}