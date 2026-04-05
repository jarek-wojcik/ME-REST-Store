Class Admin extends PlayerController
    config(Game);

public exec function PlayerList()
{
    local PlayerReplicationInfo PRI;
    
    foreach DynamicActors(Class'PlayerReplicationInfo', PRI, )
    {
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    AddCheats();
}
public exec function Switch(string URL)
{
    ServerSwitch(URL);
}
public exec function Admin(string CommandLine)
{
    ServerAdmin(CommandLine);
}
public exec function Kick(string S)
{
    ServerKick(S);
}
public exec function KickBan(string S)
{
    ServerKickBan(S);
}
public exec function RestartMap()
{
    ServerRestartMap();
}
public reliable server function ServerAdmin(string CommandLine)
{
    local string Result;
    
    Result = ConsoleCommand(CommandLine);
    if (Result != "")
    {
        ClientMessage(Result);
    }
}
public reliable server function ServerKick(string S)
{
    WorldInfo.Game.Kick(S);
}
public reliable server function ServerKickBan(string S)
{
    WorldInfo.Game.KickBan(S);
}
public reliable server function ServerRestartMap()
{
    ClientTravel("?restart", 2);
}
public reliable server function ServerSwitch(string URL)
{
    WorldInfo.ServerTravel(URL);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (None, CollisionCylinder)
    CollisionComponent = CollisionCylinder
}