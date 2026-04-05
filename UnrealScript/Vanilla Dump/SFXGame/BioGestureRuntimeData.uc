Class BioGestureRuntimeData
    native;

struct native BioWeaponPropData 
{
    var(BioWeaponPropData) array<string> aWeaponClassPrefixes;
    var(BioWeaponPropData) array<string> aWeaponPackages;
    var(BioWeaponPropData) Name nmWeaponBaseClassName;
};
struct native BioMeshPropData 
{
    var native Map_Mirror mapActions;
    var init string sMesh;
    var Vector vOffsetLocation;
    var Rotator rOffsetRotation;
    var Vector vOffsetScale;
    var Name nmPropName;
    var Name nmAttachTo;
};
struct native BioMeshPropActionData 
{
    var init string sParticleSys;
    var init string sClientEffect;
    var BioPropClientEffectParams tSpawnParams;
    var Vector vOffsetLocation;
    var Rotator rOffsetRotation;
    var Vector vOffsetScale;
    var Name nmActionName;
    var Name nmAttachTo;
    var bool bActivate;
    var bool bCooldown;
};
struct native BioPropClientEffectParams 
{
    var(BioPropClientEffectParams) Vector vHitLocation;
    var(BioPropClientEffectParams) Vector vHitNormal;
    var(BioPropClientEffectParams) Vector vRayDir;
    var(BioPropClientEffectParams) Vector vSpawnValue;
    var(BioPropClientEffectParams) Name nmHitBone;
    
    structdefaultproperties
    {
        vHitNormal = {X = 1.0, Y = 0.0, Z = 0.0}
        vRayDir = {X = -1.0, Y = 0.0, Z = 0.0}
    }
};

var native Map_Mirror m_mapAnimSetOwners;
var native Map_Mirror m_mapMeshProps;
var BioWeaponPropData m_tWeaponPropData;
var string m_sGlobalDefaultPose;
var Name m_nmDefaultPoseAnim;
var AnimSet m_pDefaultPoseSet;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_tWeaponPropData = {
                         aWeaponClassPrefixes = ("SFXWeapon_", "SFXHeavyWeapon_"), 
                         aWeaponPackages = ("SFXGameContent"), 
                         nmWeaponBaseClassName = 'SFXWeapon'
                        }
    m_sGlobalDefaultPose = "HMM_DL_StandingDefault.DL_Idle"
}