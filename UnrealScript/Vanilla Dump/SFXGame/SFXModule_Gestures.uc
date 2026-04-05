Class SFXModule_Gestures extends SFXModule
    native
    editinlinenew;

struct native BioGesturesPosePlaying 
{
    var Name nmSetName;
    var Name nmAnimName;
    var bool bUseDynSets;
    var bool bLockedAsPoseCache;
};
struct native BioQueuedAction 
{
    var const native Pointer pPropActionData;
    var const native Pointer pGestureData;
    var float fTimeQueued;
    var bool bAddedThisFrame;
};
struct native BioFoundWeaponData 
{
    var Object pWeapon;
    var bool bSpawned;
    var bool bCurrentlyEquipped;
};
struct native BioUsedMeshPropData 
{
    var editinline export array<ParticleSystemComponent> aPartSys;
    var array<RvrClientEffectInterface> aClientEffects;
    var editinline export MeshComponent pPropCmp;
};
enum ESFXDefaultPoseEnum
{
    SFXDefPose_Unset,
};
enum ESFXAmbientPoseGroupEnum
{
    SFXAmbPoseGroup_Unset,
};
enum ESFXAmbientPerformanceEnum
{
    SFXAmbPerf_Unset,
};
enum ESFXAmbientPerfGroupEnum
{
    SFXAmbPerfGroup_Unset,
};

var transient native Map_Mirror m_mapUsedMeshProps;
var transient native Map_Mirror m_mapFoundWeapons;
var transient array<AnimSet> m_aBackupAnimSets;
var transient array<BioQueuedAction> m_aPropActionQueue;
var transient array<BioQueuedAction> m_aRetriggerData;
var transient BioGesturesPosePlaying m_tPosePlayingData;
var Name m_nmDefaultPoseAnim;
var AnimSet m_pDefaultPoseSet;
var SFXAmbPerfGameData m_pPerfGameData;
var transient int m_nCurrentPerfPose;
var transient float m_fTimeSinceLastPerfChoice;
var transient int m_nTransPoseIndex;
var transient int m_nPlayingGestureIndex;
var export BioGestureAnimSetMgr m_pAnimSetMgr;
var transient bool m_bInMatinee;
var transient bool m_bGestIsOneShot;
var transient bool m_bPerfPaused;
var(SFXModule_Gestures) bool m_bDisableBlinksAndNoise;

public native function AddWeaponData(Class<Object> cWeapon, Object pWep, bool bSpawned, bool bCurrentlyEquipped);

public native function Object FindWeaponData(Class<Object> cWeapon, out int nSpawned, bool bCurrentlyEquipped);

public native function RemoveWeaponData(Class<Object> cWeapon);

public static native function SkeletalMeshComponent ScriptGetMainMeshComp(Actor pActor);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioGestureAnimSetMgr Name=oAnimSetMgr
    End Object
    m_nCurrentPerfPose = -1
    m_nTransPoseIndex = -1
    m_nPlayingGestureIndex = -1
    m_pAnimSetMgr = oAnimSetMgr
}