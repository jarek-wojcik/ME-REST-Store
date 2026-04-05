Class SFXGameEffect
    native
    abstract;

enum EBonusFormula
{
    BonusFormula_Add,
    BonusFormula_Substract,
    BonusFormula_LargestValue,
    BonusFormula_Custom,
};
enum EDurationType
{
    DurationType_Instant,
    DurationType_Temporary,
    DurationType_Permanent,
};

var(SFXGameEffect) Name Category;
var(SFXGameEffect) float Duration;
var float CurrentTime;
var(SFXGameEffect) float EffectValue;
var(SFXGameEffect) Actor Owner;
var(SFXGameEffect) Controller Instigator;
var(SFXGameEffect) Actor Causer;
var const bool bPreventGibs;
var const bool bPreventEatable;
var(SFXGameEffect) EDurationType DurationType;
var const EBonusFormula BonusFormula;

public event function OnRemoved();

public event function OnUpdate(float DeltaSeconds);

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    ClientEffects.PrimeClass(default.Class);
}
public function Controller CheckOwnerInstigator(Controller Attacker)
{
    local Controller C;
    
    if (Attacker != None && Attacker.Instigator != None && Attacker.Instigator.Controller != None)
    {
        C = Attacker.Instigator.Controller;
    }
    else
    {
        C = Attacker;
    }
    return C;
}
public function ComputeCustomEffectValue(out float Value);

public static final function Class<SFXGameEffect> LoadGameEffectClass(string GEClassName)
{
    return Class<SFXGameEffect>(Class'SFXEngine'.static.GetSeekFreeObject(GEClassName, Class'Class'));
}
public function OnApplied();

public function OnCombatEnd();

public function OnPaused();

public function OnUnpaused();

public static function SpawnWeaponImpactVFX(Actor inInstigator, ImpactInfo Impact, ParticleSystem ImpactParticleSystem, optional bool UseImpactNormal = TRUE, optional bool UseGodBone = FALSE, optional float DrawScale = 1.0)
{
    local BioPawn oPawn;
    local SFXGRI oGRI;
    local SFXDuringAsyncWorkTicker oDuringAsync;
    local SkeletalMeshComponent oSkeletalMesh;
    local Vector DirectionToSprayParticles;
    local Name BoneName;
    
    oPawn = BioPawn(Impact.HitActor);
    if (oPawn == None)
    {
        return;
    }
    oGRI = SFXGRI(oPawn.WorldInfo.GRI);
    if (oGRI == None)
    {
        return;
    }
    oDuringAsync = oGRI.DuringAsyncWorker;
    if (oDuringAsync == None)
    {
        return;
    }
    oSkeletalMesh = oPawn.Mesh;
    if (oSkeletalMesh == None)
    {
        return;
    }
    if (UseImpactNormal)
    {
        DirectionToSprayParticles = Impact.HitNormal;
    }
    else
    {
        DirectionToSprayParticles = Impact.RayDir * float(-1);
    }
    if (UseGodBone)
    {
        BoneName = 'God';
    }
    else
    {
        BoneName = Impact.HitInfo.BoneName;
    }
    oDuringAsync.SpawnImpactEffectAtLocation(inInstigator, ImpactParticleSystem, oPawn, Impact.HitLocation, DirectionToSprayParticles, oSkeletalMesh, BoneName, DrawScale);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}