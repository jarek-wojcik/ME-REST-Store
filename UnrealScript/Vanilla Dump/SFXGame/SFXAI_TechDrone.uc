Class SFXAI_TechDrone extends SFXAI_Core
    placeable
    config(AI);

public function Initialize()
{
    Super.Initialize();
    SetTimer(5.0, FALSE, 'ClearForcedTarget', );
}
public function ClearForcedTarget()
{
    ForcedTarget = None;
}
public function PeriodicMoveCheck()
{
    local float fTimeOfHit;
    local Name nmPowerName;
    local SFXWeapon oWeapon;
    local int nRequiresAttackTicket;
    local Vector AttackOrigin;
    
    Super.PeriodicMoveCheck();
    if (FRand() <= GetPowerUsePercent())
    {
        ChooseAttackPower(FireTarget, nmPowerName, nRequiresAttackTicket, AttackOrigin);
    }
    if (nmPowerName == 'None')
    {
        oWeapon = SFXWeapon(MyBP.Weapon);
        if (oWeapon == None)
        {
            return;
        }
        nRequiresAttackTicket = 1;
    }
    if (!HasLOSToTarget(FireTarget, fTimeOfHit))
    {
        return;
    }
    if (nRequiresAttackTicket > 0 && AcquireTicket(FireTarget, 2) == FALSE)
    {
        return;
    }
    Focus = FireTarget;
    MoveTarget = None;
    bReachedMoveGoal = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultCommand = Class'SFXAICmd_Combat_TechDrone'
}