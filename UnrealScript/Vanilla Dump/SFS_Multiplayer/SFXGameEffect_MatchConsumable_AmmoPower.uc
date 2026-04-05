Class SFXGameEffect_MatchConsumable_AmmoPower extends SFXGameEffect_MatchConsumableBase
    config(Game);

var ParticleSystem HologramTemplate;
var ParticleSystem IconTemplate;
var float BulletsPerSecond;
var WwiseEvent NormalImpactSound;
var WwiseEvent WeaponFireSound;
var float DamageFloatProbabilityModifier;
var clearcrosslevel SFXPowerCustomActionMP_ConsumableAmmoPower Power;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    local SFXInventoryManager InvManager;
    
    Super(SFXGameEffect).OnRemoved();
    InvManager = SFXInventoryManager(OwnerPawn.InvManager);
    if (InvManager == None)
    {
        return;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        RemoveFromWeapon(Weapon);
    }
}
public event function OnUpdate(float DeltaSeconds)
{
    local SFXWeapon OwnerWeapon;
    local SFXWeapon Weapon;
    local SFXInventoryManager InvManager;
    
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    if (OwnerPawn == None)
    {
        return;
    }
    OwnerWeapon = SFXWeapon(OwnerPawn.Weapon);
    if (OwnerWeapon == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(OwnerPawn.InvManager);
    if (InvManager == None)
    {
        return;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) != None)
        {
            continue;
        }
        if (Weapon == OwnerWeapon)
        {
            Weapon.SetAmmoPowerHologramEnabled(TRUE);
        }
        else
        {
            Weapon.SetAmmoPowerHologramEnabled(FALSE);
        }
    }
}
public function float GetDamageVocProbabilityMod()
{
    return DamageFloatProbabilityModifier;
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    local SFXInventoryManager InvManager;
    
    Super.OnApplied();
    Power = SFXPowerCustomActionMP_ConsumableAmmoPower(OwnerPawn.PowerManager.GetPowerByClass(Class'SFXPowerCustomActionMP_ConsumableAmmoPower'));
    InvManager = SFXInventoryManager(OwnerPawn.InvManager);
    if (InvManager == None)
    {
        return;
    }
    SetupFromWeapon();
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) != None)
        {
            continue;
        }
        ApplyToWeapon(Weapon);
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
    local SFXWeapon_Shotgun_Base Shotgun;
    
    if (Weapon == None)
    {
        return 0.0;
    }
    RateOfFire = Weapon.GetRateOfFire();
    Shotgun = SFXWeapon_Shotgun_Base(Weapon);
    if (Shotgun != None)
    {
        return RateOfFire / 60.0 * float(Shotgun.PelletSpread.Length);
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
public function RemoveFromWeapon(SFXWeapon Weapon)
{
    Weapon.__OnWeaponImpact__Delegate = None;
    Weapon.__GetDamageVocProbabilityMod__Delegate = None;
    Weapon.__OnWeaponEquip__Delegate = None;
    Weapon.__OnWeaponReload__Delegate = None;
    Weapon.__OnWeaponUnequip__Delegate = None;
    Weapon.WeaponPowerFireSound = None;
}
public function SetupFromWeapon()
{
    local SFXWeapon OwnerWeapon;
    
    if (OwnerPawn == None)
    {
        return;
    }
    OwnerWeapon = SFXWeapon(OwnerPawn.Weapon);
    if (OwnerWeapon == None)
    {
        return;
    }
    if (!OwnerWeapon.bIsInitialized)
    {
        Owner.SetTimer(0.100000001, FALSE, 'SetupFromWeapon', Self);
        return;
    }
    BulletsPerSecond = GetBulletsPerSecond(OwnerWeapon);
}
public function ApplyToWeapon(SFXWeapon Weapon)
{
    Weapon.__OnWeaponImpact__Delegate = OnWeaponImpact;
    Weapon.__GetDamageVocProbabilityMod__Delegate = GetDamageVocProbabilityMod;
    Weapon.__OnWeaponEquip__Delegate = OnWeaponEquip;
    Weapon.__OnWeaponUnequip__Delegate = OnWeaponUnequip;
    Weapon.__OnWeaponReload__Delegate = OnWeaponReload;
    Weapon.WeaponPowerFireSound = WeaponFireSound;
    Weapon.SetAmmoPowerHologramTemplates(HologramTemplate, IconTemplate);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageFloatProbabilityModifier = 0.0500000007
}