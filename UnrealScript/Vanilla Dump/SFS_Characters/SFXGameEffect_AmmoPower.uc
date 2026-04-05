Class SFXGameEffect_AmmoPower extends SFXGameEffect;

var ParticleSystem HologramTemplate;
var ParticleSystem IconTemplate;
var float BulletsPerSecond;
var SFXWeapon OwnerWeapon;
var BioPawn OwnerPawn;
var WwiseEvent NormalImpactSound;
var WwiseEvent WeaponFireSound;
var clearcrosslevel SFXPowerCustomAction_AmmoPower Power;
var bool AddedByPlayer;
var bool bInCinematic;

public function OnRemoved()
{
    Super.OnRemoved();
    if (OwnerWeapon == None)
    {
        return;
    }
    OwnerWeapon.__OnWeaponImpact__Delegate = None;
    OwnerWeapon.__GetDamageVocProbabilityMod__Delegate = None;
    OwnerWeapon.__OnWeaponEquip__Delegate = None;
    OwnerWeapon.__OnWeaponReload__Delegate = None;
    OwnerWeapon.__OnWeaponUnequip__Delegate = None;
    OwnerWeapon.WeaponPowerFireSound = None;
}
public event function OnUpdate(float DeltaSeconds)
{
    local BioWorldInfo Info;
    local BioPlayerController PC;
    
    Info = BioWorldInfo(Owner.WorldInfo);
    if (Info != None)
    {
        PC = Info.GetLocalPlayerController();
        if (PC != None)
        {
            if (PC.GameModeManager2.IsActive(8) || PC.GameModeManager2.IsActive(7))
            {
                OwnerWeapon.SetAmmoPowerHologramEnabled(FALSE);
                return;
            }
        }
    }
    if (SFXWeapon(OwnerPawn.Weapon) == OwnerWeapon)
    {
        OwnerWeapon.SetAmmoPowerHologramEnabled(TRUE);
    }
    else
    {
        OwnerWeapon.SetAmmoPowerHologramEnabled(FALSE);
    }
}
public function float GetDamageVocProbabilityMod()
{
    return 1.0;
}
public function OnApplied()
{
    Super.OnApplied();
    OwnerWeapon = SFXWeapon(Owner);
    if (OwnerWeapon == None)
    {
        return;
    }
    OwnerPawn = BioPawn(OwnerWeapon.Instigator);
    if (OwnerPawn == None)
    {
        return;
    }
    OwnerWeapon.SetAmmoPowerHologramTemplates(HologramTemplate, IconTemplate);
    SetupFromWeapon();
    OwnerWeapon.__OnWeaponImpact__Delegate = OnWeaponImpact;
    OwnerWeapon.__GetDamageVocProbabilityMod__Delegate = GetDamageVocProbabilityMod;
    OwnerWeapon.__OnWeaponEquip__Delegate = OnWeaponEquip;
    OwnerWeapon.__OnWeaponReload__Delegate = OnWeaponReload;
    OwnerWeapon.__OnWeaponUnequip__Delegate = OnWeaponUnequip;
    if (WeaponFireSound != None)
    {
        OwnerWeapon.WeaponPowerFireSound = WeaponFireSound;
    }
}
public function OnWeaponEquip(SFXWeapon Weapon)
{
    SetupFromWeapon();
    Weapon.SetAmmoPowerHologramEnabled(TRUE, TRUE);
}
public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    if (Owner != None && Impact.HitActor != None)
    {
        SFXGRI(Owner.WorldInfo.GRI).PlayTransientSound(NormalImpactSound, Impact.HitActor.location);
    }
}
public function OnWeaponReload(SFXWeapon Weapon);

public function OnWeaponUnequip(SFXWeapon Weapon)
{
    Weapon.SetAmmoPowerHologramEnabled(TRUE, TRUE);
}
public function float GetBulletsPerSecond(SFXWeapon Weapon)
{
    local float RateOfFire;
    local SFXWeapon_Shotgun_Base oShotgun;
    
    if (Weapon == None)
    {
        return 0.0;
    }
    RateOfFire = Weapon.GetRateOfFire();
    oShotgun = SFXWeapon_Shotgun_Base(Weapon);
    if (oShotgun != None)
    {
        return RateOfFire / 60.0 * 8.0;
    }
    return RateOfFire / 60.0;
}
public function Actor GetHitTarget(ImpactInfo Impact)
{
    local BioPawn oPawn;
    
    if (Impact.HitActor == None)
    {
        return None;
    }
    oPawn = BioPawn(Impact.HitActor);
    if (oPawn == None)
    {
        oPawn = BioPawn(Impact.HitActor.Base);
    }
    if (oPawn != None && !oPawn.IsDead() && !oPawn.IsFriendly(OwnerPawn))
    {
        return oPawn;
    }
    return Impact.HitActor;
}
public function float GetWeaponDamage(SFXWeapon Weapon, ImpactInfo Impact)
{
    local float fDamage;
    
    if (Weapon != None)
    {
        fDamage = Weapon.GetFireModeBaseDamage();
        if (Impact.PenetrationDepth > float(0))
        {
            fDamage *= Weapon.PenetrationDamageBonus.Value;
        }
        return fDamage;
    }
    return 0.0;
}
public function SetupFromWeapon()
{
    if (!OwnerWeapon.bIsInitialized)
    {
        Owner.SetTimer(0.100000001, FALSE, 'SetupFromWeapon', Self);
        return;
    }
    BulletsPerSecond = GetBulletsPerSecond(OwnerWeapon);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}