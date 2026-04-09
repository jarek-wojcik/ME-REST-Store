Class SFXAICmd_Base_ProtectorDrone extends SFXAICommand_Base_Combat within SFXAI_ProtectorDrone;

var Name ZapPower;
var Name PowerToUse;
var SFXPowerCustomAction oPower;
var Pawn oPlayer;
var float IdealMaxRangeToTarget;
var float IdealMinRangeToTarget;
var float IdealRangeToTarget;

public function bool ShouldUsePower(out Name PowerName)
{
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ZapPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        PowerName = ZapPower;
        return TRUE;
    }
    return FALSE;
}
public function Pushed()
{
    Super.Pushed();
}
public function bool SelectTarget()
{
    local float Radius;
    local Actor oActor;
    local Actor ClosestActor;
    local float ClosestDistance;
    local float fDistance;
    
    if (oPower == None)
    {
        oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ZapPower));
    }
    if (oPower != None)
    {
        Radius = oPower.ImpactRadius.CurrentValue;
    }
    foreach oPlayer.CollidingActors(Class'Actor', oActor, Radius, , , , )
    {
        if (BioPawn(oActor) == None || BioPawn(oActor).IsFriendly(oPlayer))
        {
            continue;
        }
        fDistance = VSize(oPlayer.location - oActor.location);
        if (ClosestActor == None || fDistance < ClosestDistance)
        {
            ClosestActor = oActor;
            ClosestDistance = fDistance;
        }
    }
    Outer.ForcedTarget = ClosestActor;
    if (Outer.ForcedTarget != None)
    {
        return Outer.SelectTarget();
    }
    return FALSE;
}

auto state Combat extends InCombat 
{
    
Begin:
    if (SFXPawn_ProtectorDrone(Outer.MyBP) != None)
    {
        oPlayer = Pawn(SFXPawn_ProtectorDrone(Outer.MyBP).Caster);
    }
    if (oPlayer != None && (!SelectTarget() || Outer.MyBP.PowerManager.GetSharedCooldown() > 0.0))
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, oPlayer, IdealRangeToTarget);
        Outer.Sleep(0.200000003);
    }
    else if (ShouldUsePower(PowerToUse))
    {
        Class'SFXAICmd_UsePower'.static.UsePower(Outer, PowerToUse, Outer.FireTarget, , TRUE);
        Outer.Sleep(0.200000003);
    }
    else
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, oPlayer, IdealRangeToTarget);
        Outer.Sleep(0.200000003);
    }
    Outer.TotalMoveTime = 0.0;
    Outer.MoveTimeout = RandRange(Outer.MoveTime.X, Outer.MoveTime.Y);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ZapPower = 'CombatDroneZap'
    IdealRangeToTarget = 50.0
}