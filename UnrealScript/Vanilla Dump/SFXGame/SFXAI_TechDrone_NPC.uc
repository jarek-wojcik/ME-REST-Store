Class SFXAI_TechDrone_NPC extends SFXAI_Core
    placeable
    config(AI);

var bool bHasHowled;
var bool bHasFlanked;
var bool bHasTaunted;
var bool bHasWarned;

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
public function SetMovementSpeed()
{
    local float fDistanceSquared;
    
    if (MyBP == None || FireTarget == None)
    {
        return;
    }
    fDistanceSquared = VSizeSq(FireTarget.location - MyBP.location);
    if (fDistanceSquared < 640000.0 && bHasTaunted == FALSE)
    {
        bHasTaunted = TRUE;
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(39, MyBP, BioPawn(FireTarget), , , TRUE);
    }
    if (fDistanceSquared < 1000000.0 && bHasWarned == FALSE)
    {
        bHasWarned = TRUE;
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(39, MyBP, BioPawn(FireTarget), , , TRUE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultCommand = Class'SFXAICmd_Combat_TechDroneNPC'
}