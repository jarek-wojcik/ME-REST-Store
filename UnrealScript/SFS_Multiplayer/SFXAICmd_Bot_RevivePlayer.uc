Class SFXAICmd_Bot_RevivePlayer extends SFXAICommand_Base_Combat within SFXAI_Bot;

var Pawn downedTarget;
var float reviveOffset;
var float reviveMoveSpeed;
var float fDistComparator;
var float TeleportOffsetRear;
var float TeleportOffsetSide;

function float getDistanceToDownedActor()
{
    return VSize(Outer.MyBP.location - downedTarget.location);
}
function revivePlayerOld()
{
    Outer.bMovingToDownedTarget = TRUE;
    Outer.MyBP.SetCollision(FALSE, FALSE, TRUE);
    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, downedTarget, reviveOffset);
    Class'SFSContext'.static.log(Self.Name, " Distance to Downed player " $ getDistanceToDownedActor(), downedTarget);
    if (getDistanceToDownedActor() <= reviveOffset)
    {
        if (SFXPawn_PlayerMP(downedTarget) != None && SFXPawn_PlayerParty(Outer.MyBP) != None)
        {
            //This kinda worked, but never fully resurrected the player.
            //SFXPawn_PlayerParty(Outer.MyBP).StartRevive(SFXPawn_PlayerMP(downedTarget));
            SFXPawn_PlayerMP(downedTarget).Resurrect(1.0, FALSE);
        }
        Outer.MyBP.SetCollision(TRUE, TRUE, TRUE);
        Outer.bMovingToDownedTarget = FALSE;
        Outer.PopCommand(Self);
    }
}
function teleportToDownedTarget()
{
    local Vector TargetLocation;
    local Vector vTeleportLocation;
    
    Class'SFSContext'.static.log(Self.Name, "teleportToDownedTarget(): downedTarget.location = " $ downedTarget.location.X $ ", " $ downedTarget.location.Y $ ", " $ downedTarget.location.Z, downedTarget);
    TargetLocation = downedTarget.location - Vector(downedTarget.Rotation) * TeleportOffsetRear;
    Class'SFSContext'.static.log(Self.Name, "teleport attempt #1 (rear): TargetLocation = " $ TargetLocation.X $ ", " $ TargetLocation.Y $ ", " $ TargetLocation.Z, downedTarget);
    //TargetLocation += vCross * TeleportOffsetSide;
    //tries to find nearest open location between TargetLocation and downedTarget. The result is recorded in vTeleportLocation.
    if (Outer.FindNearestOpenLocation(TargetLocation, vTeleportLocation, downedTarget))
    {
        Class'SFSContext'.static.log(Self.Name, "FindNearestOpenLocation SUCCESS #1: vTeleportLocation = " $ vTeleportLocation.X $ ", " $ vTeleportLocation.Y $ ", " $ vTeleportLocation.Z, downedTarget);
        Outer.MyBP.SafeSetLocation(vTeleportLocation);
    }
    else
    {
        TargetLocation = downedTarget.location + Vector(downedTarget.Rotation * TeleportOffsetRear);
        Class'SFSContext'.static.log(Self.Name, "teleport attempt #2 (other side): TargetLocation = " $ TargetLocation.X $ ", " $ TargetLocation.Y $ ", " $ TargetLocation.Z, downedTarget);
        if (Outer.FindNearestOpenLocation(TargetLocation, vTeleportLocation, downedTarget))
        {
            Class'SFSContext'.static.log(Self.Name, "FindNearestOpenLocation SUCCESS #2: vTeleportLocation = " $ vTeleportLocation.X $ ", " $ vTeleportLocation.Y $ ", " $ vTeleportLocation.Z, downedTarget);
            Outer.MyBP.SafeSetLocation(vTeleportLocation);
        }
        else
        {
            Class'SFSContext'.static.log(Self.Name, "FindNearestOpenLocation FAILED #2 ? FALLBACK SetLocation = " $ TargetLocation.X $ ", " $ TargetLocation.Y $ ", " $ TargetLocation.Z, downedTarget);
            Outer.MyBP.SetLocation(TargetLocation, );
        }
    }
}

auto state RevivePlayer extends InCombat 
{
    
Begin:
    while (TRUE)
    {
        Outer.Sleep(1.0);
        teleportToDownedTarget();
        Outer.Sleep(0.800000012);
        SFXPawn_PlayerMP(downedTarget).Resurrect(1.0, FALSE);
        Outer.Reset();
        Outer.ObjectiveGoalActor = None;
        Outer.DefaultOffset = Outer.default.DefaultOffset;
        Outer.BeginCombatCommand(Class'SFXAICmd_Bot_Base');
        Outer.PopCommand(Self);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TeleportOffsetRear = 500.0
    TeleportOffsetSide = 60.0
    reviveOffset = 150.0
    reviveMoveSpeed = 3.0
}