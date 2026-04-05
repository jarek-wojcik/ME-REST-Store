Class Mutator extends Info
    native
    abstract;

var(Mutator) array<string> GroupNames;
var Mutator NextMutator;
var bool bUserAdded;

public event function Destroyed()
{
    WorldInfo.Game.RemoveMutator(Self);
    Super(Actor).Destroyed();
}
public function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    if (bToEntry)
    {
        ActorList[ActorList.Length] = Self;
    }
    if (NextMutator != None)
    {
        NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
    }
}
public event function PreBeginPlay()
{
    if (!MutatorIsAllowed())
    {
        Destroy();
    }
}
public function AddMutator(Mutator M)
{
    if (NextMutator == None)
    {
        NextMutator = M;
    }
    else
    {
        NextMutator.AddMutator(M);
    }
}
public function bool AlwaysKeep(Actor Other)
{
    if (NextMutator != None)
    {
        return NextMutator.AlwaysKeep(Other);
    }
    return FALSE;
}
public function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != None)
    {
        return NextMutator.CanLeaveVehicle(V, P);
    }
    return TRUE;
}
public function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return NextMutator == None || NextMutator.CheckEndGame(Winner, Reason);
}
public function bool CheckRelevance(Actor Other)
{
    local bool bResult;
    
    if (AlwaysKeep(Other))
    {
        return TRUE;
    }
    bResult = IsRelevant(Other);
    return bResult;
}
public function bool CheckReplacement(Actor Other)
{
    return TRUE;
}
public function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != None)
    {
        NextMutator.DriverEnteredVehicle(V, P);
    }
}
public function DriverLeftVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != None)
    {
        NextMutator.DriverLeftVehicle(V, P);
    }
}
public function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    if (NextMutator != None)
    {
        return NextMutator.FindPlayerStart(Player, InTeam, IncomingName);
    }
    else
    {
        return None;
    }
}
public function GetServerDetails(out ServerResponseLine ServerState)
{
    local int i;
    
    i = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = i + 1;
    ServerState.ServerInfo[i].Key = "Mutator";
    ServerState.ServerInfo[i].Value = GetHumanReadableName();
}
public function GetServerPlayers(out ServerResponseLine ServerState);

public function bool HandleRestartGame()
{
    return NextMutator != None && NextMutator.HandleRestartGame();
}
public function InitMutator(string Options, out string ErrorMessage)
{
    if (NextMutator != None)
    {
        NextMutator.InitMutator(Options, ErrorMessage);
    }
}
public function bool IsRelevant(Actor Other)
{
    local bool bResult;
    
    bResult = CheckReplacement(Other);
    if (bResult && NextMutator != None)
    {
        bResult = NextMutator.IsRelevant(Other);
    }
    return bResult;
}
public function ModifyLogin(out string Portal, out string Options)
{
    if (NextMutator != None)
    {
        NextMutator.ModifyLogin(Portal, Options);
    }
}
public function ModifyPlayer(Pawn Other)
{
    if (NextMutator != None)
    {
        NextMutator.ModifyPlayer(Other);
    }
}
public function Mutate(string MutateString, PlayerController Sender)
{
    if (NextMutator != None)
    {
        NextMutator.Mutate(MutateString, Sender);
    }
}
public function bool MutatorIsAllowed()
{
    return !WorldInfo.IsDemoBuild();
}
public function NetDamage(int OriginalDamage, out int Damage, Pawn injured, Controller instigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
    if (NextMutator != None)
    {
        NextMutator.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    }
}
public function NotifyLogin(Controller NewPlayer)
{
    if (NextMutator != None)
    {
        NextMutator.NotifyLogin(NewPlayer);
    }
}
public function NotifyLogout(Controller Exiting)
{
    if (NextMutator != None)
    {
        NextMutator.NotifyLogout(Exiting);
    }
}
public function bool OverridePickupQuery(Pawn Other, Class<Inventory> ItemClass, Actor Pickup, out byte bAllowPickup)
{
    return NextMutator != None && NextMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup);
}
public function string ParseChatPercVar(Controller Who, string Cmd)
{
    if (NextMutator != None)
    {
        Cmd = NextMutator.ParseChatPercVar(Who, Cmd);
    }
    return Cmd;
}
public function bool PreventDeath(Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    return NextMutator != None && NextMutator.PreventDeath(Killed, Killer, DamageType, HitLocation);
}
public function ScoreKill(Controller Killer, Controller Killed)
{
    if (NextMutator != None)
    {
        NextMutator.ScoreKill(Killer, Killed);
    }
}
public function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    if (NextMutator != None)
    {
        NextMutator.ScoreObjective(Scorer, Score);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}