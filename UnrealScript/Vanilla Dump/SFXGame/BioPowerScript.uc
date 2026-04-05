Class BioPowerScript within BioPower
    native
    abstract;

var array<Actor> m_ImpactedActors;
var(BioPowerScript) Vector m_vWorldImpactLocation;
var(BioPowerScript) Vector m_vWorldImpactNormal;
var(BioPowerScript) Vector m_vProjectileVelocity;
var(BioPowerScript) Vector m_vProjectileLocation;
var transient Vector m_vLocationToAimAt;
var ForceFeedbackWaveform m_ImpactWaveForm;
var transient Actor m_oTargetToAimAt;
var stringref Recommended_TargetVulnerable;
var stringref NotRecommended_TargetOrganic;
var stringref NotRecommended_TargetMachine;
var stringref NotRecommended_TargetHasShields;
var stringref NotRecommended_TargetHasBiotics;
var stringref NotRecommended_TargetHasArmor;
var stringref NotRecommended_NoMedigel;
var stringref NotRecommended_NoSquadMemberDead;
var stringref NotRecommended_NoSquadMemberInjured;
var stringref NotRecommended_WeaponPowerAlreadyOn;
var stringref NotRecommended_TargetImmune;
var(BioPowerScript) bool m_bWeaponModePower;
var(BioPowerScript) bool bShouldTick;
var transient bool m_bPlayerOrderedPowerUse;

public event function bool AdjustCooldown(out float fCooldownTime)
{
    local float fStaticBonus;
    
    if (Pawn(Outer.Owner) != None && Pawn(Outer.Owner).InPlayerParty() && Outer.NewPower != None)
    {
        fStaticBonus = 1.0;
        GetCooldownResearchBonus(fStaticBonus);
        fCooldownTime *= fStaticBonus + Outer.NewPower.DynamicCooldownBonus - 1.0;
    }
    return TRUE;
}
public event function bool CanStartPower(Actor oCaster)
{
    return TRUE;
}
public event function bool EffectUnapply(Actor oCaster, float fCasterStability, Actor oImpacted, int nPreviouslyImpacted);

public native function bool GetFloorLocation(Vector vStartLocation, out Vector vFloorLocation);

public event function string GetHUDWheelIconInfo(BioPawn OwnerPawn)
{
    return "";
}
public event function InitializePowerScript();

public event function bool OnImpact(Actor oCaster, float fCasterStability, Actor oImpacted, int nPreviouslyImpacted);

public function OnProjectileExploded(Actor oCaster, Vector HitLocation, Vector HitNormal, Vector Velocity);

public native function bool PlayGuiSound(Name nmSound);

public event function bool ShouldUsePower(Actor Caster, Actor Target, out string sOptionalInfo)
{
    sOptionalInfo = "";
    return TRUE;
}
public event function Tick(float DeltaTime);

public function DebugDraw_Power(BioHUD H);

public function GetCooldownResearchBonus(out float fStaticResearchBonus);

public simulated function float GetDuration()
{
    return 0.0;
}
public simulated function float GetElapsedTime()
{
    return 0.0;
}
public function OnOwnerDied();

public function OnPowerAdded(SFXPower Power);

public function OnPowerRankIncreased();

public function OnPowersLoaded();

public function OnSquadMemberAdded(Pawn Pawn);

public function OnWeaponEquip(SFXWeapon Weapon);

public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact);

public function OnWeaponReload(SFXWeapon Weapon, bool QuickReload);

public function OnWeaponUnequip(SFXWeapon Weapon);

public function ReloadAmmoPower(BioPawn Target, SFXWeapon Weapon);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Object
    m_ImpactWaveForm = ForceFeedbackWaveformBase
    Recommended_TargetVulnerable = $340074
    NotRecommended_TargetOrganic = $340062
    NotRecommended_TargetMachine = $340063
    NotRecommended_TargetHasShields = $340065
    NotRecommended_TargetHasBiotics = $340067
    NotRecommended_TargetHasArmor = $340068
    NotRecommended_NoMedigel = $340367
    NotRecommended_NoSquadMemberDead = $340069
    NotRecommended_NoSquadMemberInjured = $340070
    NotRecommended_WeaponPowerAlreadyOn = $340223
    NotRecommended_TargetImmune = $341124
}