Class BioPower
    native;

enum EBioPowerType
{
    BIO_POWER_TYPE_UNKNOWN,
    BIO_POWER_TYPE_CYLINDER,
    BIO_POWER_TYPE_TARGET,
    BIO_POWER_TYPE_PARTY,
    BIO_POWER_TYPE_IMPACT_VOLUME,
    BIO_POWER_TYPE_MELEE,
};
enum EBioPowerResource
{
    BIO_POWER_RESOURCE_VFX_PLAYER_CRUST,
    BIO_POWER_RESOURCE_VFX_PLAYER_MATERIAL,
    BIO_POWER_RESOURCE_VFX_TARGET_CRUST,
    BIO_POWER_RESOURCE_VFX_TARGET_MATERIAL,
    BIO_POWER_RESOURCE_VFX_FRAMEBUFFER,
    BIO_POWER_RESOURCE_VFX_TRAVELLING,
    BIO_POWER_RESOURCE_VFX_IMPACT,
    BIO_POWER_RESOURCE_VFX_WORLD_IMPACT,
    BIO_POWER_RESOURCE_VFX_RELEASE,
    BIO_POWER_RESOURCE_VFX_CASTING_BEAM,
    BIO_POWER_RESOURCE_CASTING,
    BIO_POWER_RESOURCE_RELEASE,
};

var string m_sRTPCName;
var Name m_nmPower;
var(BioPower) BioPowerScript Script;
var(BioPower) Controller Instigator;
var SFXPower NewPower;
var Actor Owner;
var transient int m_nSuppressedCount;
var transient bool m_bFakePower;
var transient bool m_bDisableVFX;
var transient bool m_bDisableDamageAndEffects;
var transient bool m_bDisableAnimation;

public native function bool CanCasterMoveDuringPower();

public final native function CreatePowerScript();

public native function bool GetAnimSet(out AnimSet oAnimSet);

public native function bool GetBlockedByObjects();

public native function float GetCastingTime();

public native function float GetConeHalfAngle();

public native function bool GetDescription(out string sDescription);

public native function EBioCapMode GetDiscipline();

public native function bool GetDisplayName(out string sDisplayName);

public native function float GetEffectDuration();

public native function float GetGlobalCooldown();

public native function float GetImpactRadius();

public native function bool GetImpactText(out stringref srImpactText);

public native function float GetMaximumRange();

public native function float GetMinimumRange();

public native function int GetPowerIcon();

public native function float GetProjectileRadius();

public native function float GetProjectileSpeed();

public native function float GetReleaseAnimRate();

public native function bool GetStopOnFirstHit();

public native function EBioPowerType GetType();

public native function float GetVFXIntensity();

public native function InitializePower(Name nmPower);

public native function bool IsEnabled();

public native function bool IsSuppressed();

public native function bool ShouldDisplayInHUD();

public native function int SuppressPower(bool bSuppress);

public native function Tick(float fDeltaTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sRTPCName = "Power_Rank"
}