Class SFXAICmd_Base_HordeApproach extends SFXAICommand_Base_Combat within SFXAI_Core;

var bool bCombatStarted;

public function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen)
{
    Super(SFXAICommand).NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
    bCombatStarted = TRUE;
    if (Outer.MoveGoal != None)
    {
        Outer.MoveGoal = None;
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    Super(SFXAICommand).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    bCombatStarted = TRUE;
    if (Outer.MoveGoal != None)
    {
        Outer.MoveGoal = None;
    }
}
public function NotifyNearMiss(Vector HitLocation)
{
    Super(SFXAICommand).NotifyNearMiss(HitLocation);
    bCombatStarted = TRUE;
    if (Outer.MoveGoal != None)
    {
        Outer.MoveGoal = None;
    }
}
public function NotifyPendingPowerImpact(Name Label, float TimeBeforeImpact, SFXPowerCustomAction Power, SFXProjectile_PowerCustomAction Projectile)
{
    Super(SFXAICommand).NotifyPendingPowerImpact(Label, TimeBeforeImpact, Power, Projectile);
    bCombatStarted = TRUE;
    if (Outer.MoveGoal != None)
    {
        Outer.MoveGoal = None;
    }
}
public function Pushed()
{
    Super.Pushed();
    bCombatStarted = FALSE;
}

auto state Approach extends InCombat 
{
    
Begin:
    Outer.Sleep(0.25 + FRand() * 0.75);
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    if (!bCombatStarted && VSizeSq(Outer.FireTarget.location - Outer.Pawn.location) > 9000000.0)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, 1000.0);
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}