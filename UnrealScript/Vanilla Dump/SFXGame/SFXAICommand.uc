Class SFXAICommand extends GameAICommand within SFXAI_NativeBase;

var delegate<UsePowerDelegate> __UsePowerDelegate__Delegate;
var delegate<FireWeaponDelegate> __FireWeaponDelegate__Delegate;
var delegate<MoveToDelegate> __MoveToDelegate__Delegate;
var transient SFXAICommand SFXChildCommand;
var transient bool bAbortIfChildFailed;

public function bool NotifyBump(Actor Other, Vector HitNormal)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyBump(Other, HitNormal);
    }
    return FALSE;
}
public function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen)
{
    if (SFXChildCommand != None)
    {
        SFXChildCommand.NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
    }
}
public function bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyHitWall(HitNormal, Wall);
    }
    return FALSE;
}
public function NotifyNewEnemy(Pawn NewEnemy)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyNewEnemy(NewEnemy);
    }
}
public function OnEnteredPlaypen()
{
    if (SFXChildCommand != None)
    {
        SFXChildCommand.OnEnteredPlaypen();
    }
}
public function Paused(GameAICommand NewCommand)
{
    Super.Paused(NewCommand);
    SFXChildCommand = SFXAICommand(NewCommand);
}
public function UpdateMovementActions()
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.UpdateMovementActions();
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    }
}
public function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyWeaponFinishedFiring(W, FireMode);
    }
}
public function bool CancelCommand(optional int nReason)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.CancelCommand(nReason);
    }
    return TRUE;
}
public function bool CanInterruptCurrentCommand()
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        return SFXChildCommand.CanInterruptCurrentCommand();
    }
    return TRUE;
}
public function bool FireWeaponAtTarget(Actor oTarget, bool bCheckLOS, bool bForceShoot, float fAttackDuration, optional delegate<FireWeaponDelegate> FireDelegate)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.FireWeaponAtTarget(oTarget, bCheckLOS, bForceShoot, fAttackDuration, FireDelegate);
    }
    else
    {
        return FALSE;
    }
}
public delegate function FireWeaponDelegate(int nReason);

public delegate function MoveToDelegate(int nReason);

public function bool MoveToGoalExternal(Actor NewMoveGoal, optional float NewMoveOffset, optional bool bForceWalk, optional delegate<MoveToDelegate> MoveDelegate)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.MoveToGoalExternal(NewMoveGoal, NewMoveOffset, bForceWalk, MoveDelegate);
    }
    else
    {
        return FALSE;
    }
}
public function NotifyArmourDestroyed(Name ArmourPiece, Controller instigatedBy)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyArmourDestroyed(ArmourPiece, instigatedBy);
    }
}
public function NotifyArmourHit(float Damage, Name ArmourPiece, Controller instigatedBy, Vector HitLocation, Vector Momentum, optional Class<DamageType> DamageType, optional Actor DamageCauser)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyArmourHit(Damage, ArmourPiece, instigatedBy, HitLocation, Momentum);
    }
}
public function NotifyFriendDied(BioPawn FriendPawn)
{
    if (SFXChildCommand != None)
    {
        SFXChildCommand.NotifyFriendDied(FriendPawn);
    }
}
public function bool NotifyMoodChange()
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        return SFXChildCommand.NotifyMoodChange();
    }
    return FALSE;
}
public function NotifyNearMiss(Vector HitLocation)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyNearMiss(HitLocation);
    }
}
public function NotifyPendingPowerImpact(Name Label, float TimeBeforeImpact, SFXPowerCustomAction Power, SFXProjectile_PowerCustomAction Projectile)
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.NotifyPendingPowerImpact(Label, TimeBeforeImpact, Power, Projectile);
    }
}
public function PeriodicMoveCheck()
{
    if (SFXChildCommand != None)
    {
        assert(ChildCommand != None);
        SFXChildCommand.PeriodicMoveCheck();
    }
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    SFXChildCommand = None;
    if (bAbortIfChildFailed && ChildStatus == 'Aborted')
    {
        Outer.AbortCommand(Self);
    }
}
public function bool ShouldRun()
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.ShouldRun();
    }
    return FALSE;
}
public function bool StartFollowingActor(Actor ActorToFollow)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.StartFollowingActor(ActorToFollow);
    }
    else
    {
        return FALSE;
    }
}
public delegate function UsePowerDelegate(int nReason);

public function bool UsePowerOnTarget(Name nmPowerToUse, Actor oTarget, optional delegate<UsePowerDelegate> PowerDelegate, optional bool bIgnoreSuppression)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.UsePowerOnTarget(nmPowerToUse, oTarget, PowerDelegate, bIgnoreSuppression);
    }
    else
    {
        return FALSE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAbortIfChildFailed = TRUE
}