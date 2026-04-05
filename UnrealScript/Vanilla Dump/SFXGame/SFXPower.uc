Class SFXPower
    native
    abstract
    config(Game);

struct native UnlockRequirement 
{
    var Class<Object> PowerClass;
    var float Rank;
    var stringref CustomUnlockText;
};
struct native RankInfo 
{
    var int Icon;
    var stringref Name;
    var stringref Description;
    var stringref UnlockBlurb;
};

var array<float> ImpactRadius;
var array<float> EffectDuration;
var array<float> Damage;
var array<float> Force;
var array<RankInfo> Ranks;
var array<int> RankCosts;
var array<UnlockRequirement> UnlockRequirements;
var Class<Object> PowerScriptClass;
var Class<Object> EvolvedPowerClass1;
var Class<Object> EvolvedPowerClass2;
var Name PowerName;
var Name BaseName;
var Vector2D CastingTime;
var Vector2D CooldownTime;
var Vector2D GlobalCooldownTime;
var Vector2D MinimumRange;
var Vector2D MaximumRange;
var Vector2D VFXIntensity;
var Vector2D ProjectileSpeed;
var Vector2D ProjectileRadius;
var Vector2D ConeHalfAngle;
var stringref DisplayName;
var stringref Description;
var stringref ImpactText;
var int Icon;
var AnimSet Animations;
var float ReleasePlayRate;
var config float DynamicCooldownBonus;
var config float DynamicDurationBonus;
var config float DynamicDamageBonus;
var float Rank;
var float MaxRank;
var float DelayBeforeFirstUse;
var float DelayBetweenUses;
var float TimeUntilNextUse;
var stringref TalentDescription;
var int WheelDisplayIndex;
var transient BioPawn MyPawn;
var transient BioPower OldPower;
var bool UsesSharedCooldown;
var bool BlockedByObjects;
var bool AimingIgnoresObstructions;
var bool StopOnFirstHit;
var bool CanMoveWhileCasting;
var bool DisplayInHUD;
var bool AISelectable;
var bool IsHenchmenUnique;
var bool DisplayInCharacterRecord;
var EBioPowerType PowerType;
var EBioCapabilityTypes CapabilityType;
var EBioCapMode Discipline;
var ESFXVocalizationEventID VocalizationEvent;

public native function float GetArrayValue(out array<float> ArrayValues, optional int nRankToUse = -1);

public native function bool GetDescription(int nRankIndex, out string sDescription);

public function float GetImpactRadius()
{
    return 100.0;
}
public native function bool GetParsedString(stringref srValue, int nRankIndex, out string sOutput);

public native function float GetScaledValue(Vector2D ValueToScale, optional int nRankToUse = -1);

public native function GetStringFromStringRef(stringref TheStringRef, out string TheString, optional bool bParse = FALSE, optional int nParseIndex = 0);

public native function bool GetUnlockBlurb(int nRankIndex, out string sUnlockBlurb);

public native function bool IsTargetInRange(Actor Target);

private final native function bool ParseString(int nRankIndex, out string sParsedString);

private final native function ProcessToken(int nRankIndex, out string sToken);

public native function Tick(float fDeltaTime);

public function float GetDamage()
{
    local float fDamage;
    local float fStaticBonus;
    
    fDamage = GetArrayValue(Damage);
    if (MyPawn != None && MyPawn.InPlayerParty())
    {
        fStaticBonus = 1.0;
        GetDamageResearchBonus(fStaticBonus);
        fDamage *= fStaticBonus + DynamicDamageBonus - 1.0;
    }
    return fDamage;
}
public function GetDamageResearchBonus(out float fStaticDamageBonus);

public function float GetDuration()
{
    local float fDuration;
    local float fStaticBonus;
    
    fDuration = GetArrayValue(EffectDuration);
    if (MyPawn != None && MyPawn.InPlayerParty())
    {
        fStaticBonus = 1.0;
        GetDurationResearchBonus(fStaticBonus);
        fDuration *= fStaticBonus + DynamicDurationBonus - 1.0;
    }
    return fDuration;
}
public function GetDurationResearchBonus(out float fStaticDamageBonus);

public function float GetForce()
{
    return GetArrayValue(Force);
}
public function RecalculateCooldownBonus();

public function RecalculateDamageBonus();

public function RecalculateDurationBonus();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RankCosts = (1, 2, 3, 4)
    ReleasePlayRate = 1.0
    DynamicCooldownBonus = 1.0
    DynamicDurationBonus = 1.0
    DynamicDamageBonus = 1.0
    MaxRank = 4.0
    UsesSharedCooldown = TRUE
    BlockedByObjects = TRUE
    CanMoveWhileCasting = TRUE
    DisplayInHUD = TRUE
    AISelectable = TRUE
    DisplayInCharacterRecord = TRUE
}