Class BioEvtSysTrackProp extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioWeaponPropActionData 
{
    var Function pfnExecute;
    var Function pfnGetTiming;
};
struct native BioPropTrackData 
{
    var Class<Object> pWeaponClass;
    var Name nmProp;
    var Name nmAction;
    var Object pPropMesh;
    var ParticleSystem pActionPartSys;
    var RvrClientEffectInterface pActionClientEffect;
    var(BioPropTrackData) bool bEquip;
    var(BioPropTrackData) bool bForceGenericWeapon;
    
    structdefaultproperties
    {
        bEquip = TRUE
    }
};
enum EDynPropActionList
{
    DynPropActionList_Unset,
};
enum EDynPropList
{
    DynPropList_Unset,
};

var(BioEvtSysTrackProp) array<BioPropTrackData> m_aPropKeys;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static native function float FindPartSysMaxDuration(ParticleSystem pParticleSystem, out int nLooping);

public static event function string GetNewTrackSubMenuName()
{
    return "Bio Conversation";
}
public static event function Name GetRightHandSocketName(Actor pActor)
{
    local BioPawn pPawn;
    
    pPawn = BioPawn(pActor);
    if (pPawn != None)
    {
        return pPawn.GetRightHandSocketName();
    }
    return Class'BioPawn'.default.RightHandSocketName;
}
public static event function SkeletalMesh GetWeaponMesh(Class<Object> cWeaponIn)
{
    local Class<SFXWeapon> cWeapon;
    
    cWeapon = Class<SFXWeapon>(cWeaponIn);
    if (cWeapon != None)
    {
        return SkeletalMeshComponent(cWeapon.default.Mesh).SkeletalMesh;
    }
    return None;
}
public static event function string KeyDataArrayName()
{
    return "m_aPropKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Prop Data";
}
public static event function string NewKeyDefaultName()
{
    return "Prop";
}
public static event function PropEquipWeapon(Class<Object> cWeapon, Object pDataStoreObject, bool bCurrentlyEquipped, optional bool bForceSuppressDamage = FALSE)
{
    local Name nmRightHand;
    local SkeletalMeshSocket pSocket;
    local SFXWeapon pFoundWeapon;
    local int nSpawned;
    local SkeletalMeshComponent pMainMesh;
    local Actor pActor;
    local BioEvtSysTrackPropInst pPropInst;
    local SFXModule_Gestures pGestMod;
    
    pActor = None;
    pPropInst = None;
    pGestMod = None;
    if (pDataStoreObject != None)
    {
        if (pDataStoreObject.IsA('BioEvtSysTrackPropInst'))
        {
            pPropInst = BioEvtSysTrackPropInst(pDataStoreObject);
            if (pPropInst != None)
            {
                pActor = pPropInst.m_pActor;
            }
        }
        else
        {
            pActor = Actor(pDataStoreObject);
            if (pActor != None)
            {
                pGestMod = pActor.GetModule(Class'SFXModule_Gestures');
            }
        }
    }
    if (pActor == None || cWeapon == None || !ClassIsChildOf(cWeapon, Class'SFXWeapon') && !bCurrentlyEquipped || pPropInst == None && pGestMod == None)
    {
        return;
    }
    pMainMesh = Class'SFXModule_Gestures'.static.ScriptGetMainMeshComp(pActor);
    if (pMainMesh == None)
    {
        return;
    }
    pFoundWeapon = None;
    if (pPropInst != None)
    {
        pFoundWeapon = SFXWeapon(pPropInst.FindWeaponData(cWeapon, nSpawned, bCurrentlyEquipped));
    }
    else
    {
        pFoundWeapon = SFXWeapon(pGestMod.FindWeaponData(cWeapon, nSpawned, bCurrentlyEquipped));
    }
    if (pFoundWeapon == None || pFoundWeapon.Mesh == None)
    {
        return;
    }
    nmRightHand = GetRightHandSocketName(pActor);
    pSocket = pMainMesh.GetSocketByName(nmRightHand);
    if (pSocket != None)
    {
        if (pMainMesh.IsComponentAttached(pFoundWeapon.Mesh, pSocket.BoneName) == TRUE)
        {
            return;
        }
    }
    pFoundWeapon.DetachWeapon();
    pFoundWeapon.AttachWeaponTo(pMainMesh, nmRightHand);
    pFoundWeapon.bInstantExpansion = TRUE;
    pFoundWeapon.Expand();
    if (bForceSuppressDamage)
    {
        pFoundWeapon.bSuppressDamage = TRUE;
    }
    pFoundWeapon.bSuppressCameraShake = TRUE;
    if (nSpawned == 0)
    {
        pFoundWeapon.SetWeaponHidden(FALSE);
    }
}
public static event function Object PropGetActorWeapon(Class<Object> cWeapon, Object pDataStoreObject, bool bCurrentlyEquipped, optional bool bSpawnGeneric = FALSE)
{
    local SFXWeapon pCurWpn;
    local SFXWeapon pFoundWeapon;
    local int nSpawned;
    local Actor pActor;
    local BioPawn pPawn;
    local BioEvtSysTrackPropInst pPropInst;
    local SFXModule_Gestures pGestMod;
    
    pFoundWeapon = None;
    pPawn = None;
    pActor = None;
    pPropInst = None;
    pGestMod = None;
    if (pDataStoreObject != None)
    {
        if (pDataStoreObject.IsA('BioEvtSysTrackPropInst'))
        {
            pPropInst = BioEvtSysTrackPropInst(pDataStoreObject);
            if (pPropInst != None)
            {
                pActor = pPropInst.m_pActor;
            }
        }
        else
        {
            pActor = Actor(pDataStoreObject);
            if (pActor != None)
            {
                pGestMod = pActor.GetModule(Class'SFXModule_Gestures');
            }
        }
    }
    pPawn = BioPawn(pActor);
    if (bCurrentlyEquipped && pPawn != None)
    {
        if (SFXInventoryManager(pPawn.InvManager) != None)
        {
            cWeapon = SFXInventoryManager(pPawn.InvManager).CurrentWeaponSelection;
        }
    }
    if (cWeapon != None && ClassIsChildOf(cWeapon, Class'SFXWeapon') && pActor != None && (pPropInst != None || pGestMod != None))
    {
        if (pPropInst != None)
        {
            pFoundWeapon = SFXWeapon(pPropInst.FindWeaponData(cWeapon, nSpawned, bCurrentlyEquipped));
        }
        else
        {
            pFoundWeapon = SFXWeapon(pGestMod.FindWeaponData(cWeapon, nSpawned, bCurrentlyEquipped));
        }
        if (pFoundWeapon == None)
        {
            if (pPawn != None && pPawn.InvManager != None && !bSpawnGeneric)
            {
                foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pCurWpn)
                {
                    if (ClassIsChildOf(pCurWpn.Class, cWeapon))
                    {
                        if (pFoundWeapon == None || pCurWpn.GetAIRating() > pFoundWeapon.GetAIRating())
                        {
                            pFoundWeapon = pCurWpn;
                        }
                    }
                }
            }
            if (pFoundWeapon != None)
            {
                if (pPropInst != None)
                {
                    pPropInst.AddWeaponData(cWeapon, pFoundWeapon, FALSE, bCurrentlyEquipped);
                }
                else
                {
                    pGestMod.AddWeaponData(cWeapon, pFoundWeapon, FALSE, bCurrentlyEquipped);
                }
            }
            else
            {
                pFoundWeapon = pActor.Spawn(Class<SFXWeapon>(cWeapon), pActor);
                if (pFoundWeapon != None)
                {
                    pFoundWeapon.SetOwner(pActor);
                    if (pPawn != None)
                    {
                        pFoundWeapon.Instigator = pPawn;
                    }
                    if (pPropInst != None)
                    {
                        pPropInst.AddWeaponData(cWeapon, pFoundWeapon, TRUE, bCurrentlyEquipped);
                    }
                    else
                    {
                        pGestMod.AddWeaponData(cWeapon, pFoundWeapon, TRUE, bCurrentlyEquipped);
                    }
                    pFoundWeapon.InitializeWeapon();
                }
            }
        }
    }
    if (pFoundWeapon == None)
    {
    }
    return pFoundWeapon;
}
public event function PropUnequipWeapon(Actor pActor, Object pWeaponIn, int nSpawned)
{
    local Name nmRightHand;
    local SkeletalMeshSocket pSocket;
    local SFXWeapon pWeapon;
    local SkeletalMeshComponent pMainMesh;
    local BioPawn pPawn;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pActor == None || pWeapon == None || pActor == None || pWeapon.Mesh == None)
    {
        return;
    }
    pMainMesh = Class'SFXModule_Gestures'.static.ScriptGetMainMeshComp(pActor);
    if (pMainMesh == None)
    {
        return;
    }
    pPawn = BioPawn(pActor);
    nmRightHand = GetRightHandSocketName(pActor);
    pSocket = pMainMesh.GetSocketByName(nmRightHand);
    if (pSocket != None)
    {
        if (pMainMesh.IsComponentAttached(pWeapon.Mesh, pSocket.BoneName) == TRUE)
        {
            pWeapon.DetachWeapon();
        }
    }
    pWeapon.bInstantExpansion = TRUE;
    pWeapon.Collapse();
    PropWepActionExecuteDisableIK(pWeapon, pActor);
    pWeapon.CleanUpDummyFire();
    if (nSpawned == 1)
    {
        pWeapon.SetOwner(None);
        pWeapon.Instigator = None;
        pWeapon.Destroy();
    }
    else if (pPawn != None)
    {
        if (int(pWeapon.CharacterSlot) < 5)
        {
            pWeapon.AttachWeaponTo(pMainMesh, pPawn.AttachSlots[int(pWeapon.CharacterSlot)]);
        }
        pWeapon.bSuppressDamage = FALSE;
        pWeapon.bSuppressCameraShake = FALSE;
    }
}
public event function PropUnequipWeaponForInst(Class<Object> cWeapon, BioEvtSysTrackPropInst pInst, bool bCurrentlyEquipped)
{
    local SFXWeapon pFoundWeapon;
    local int nSpawned;
    
    if (cWeapon == None || !ClassIsChildOf(cWeapon, Class'SFXWeapon') && !bCurrentlyEquipped || pInst == None || pInst.m_pActor == None)
    {
        return;
    }
    pFoundWeapon = SFXWeapon(pInst.FindWeaponData(cWeapon, nSpawned, bCurrentlyEquipped));
    if (pFoundWeapon == None || pFoundWeapon.Mesh == None)
    {
        return;
    }
    PropUnequipWeapon(pInst.m_pActor, pFoundWeapon, nSpawned);
    pInst.RemoveWeaponData(cWeapon);
}
public static function PropWepActionExecuteCollapse(Object pWeaponIn, Actor pActor)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    pWeapon.bForceReplayAnimation = TRUE;
    pWeapon.bInstantExpansion = FALSE;
    pWeapon.Collapse();
}
public static function PropWepActionExecuteDisableIK(Object pWeaponIn, Actor pActor)
{
    local SFXSkelControlLimb pSkelControl;
    local SkeletalMeshComponent pMainMesh;
    local SFXWeapon Weap;
    
    pMainMesh = Class'SFXModule_Gestures'.static.ScriptGetMainMeshComp(pActor);
    if (pMainMesh != None)
    {
        pSkelControl = SFXSkelControlLimb(pMainMesh.FindSkelControl('LeftArm'));
        if (pSkelControl != None)
        {
            Weap = SFXWeapon(pWeaponIn);
            if (Weap != None)
            {
                pSkelControl.SetSkelControlProfile(int(Weap.IKProfileID));
            }
            pSkelControl.bSetStrengthFromAnimNode = TRUE;
            pSkelControl.SetSkelControlActive(FALSE);
        }
    }
}
public static function PropWepActionExecuteDummyFireInfiniteOff(Object pWeaponIn, Actor pActor)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    pWeapon.CleanUpDummyFire();
}
public static function PropWepActionExecuteDummyFireInfiniteOn(Object pWeaponIn, Actor pActor)
{
    local Vector vHitLocation;
    local Vector vTmp;
    local Rotator rTmp;
    local SkeletalMeshComponent pMeshCmp;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    vHitLocation = vect(0.0, 0.0, 0.0);
    pMeshCmp = SkeletalMeshComponent(pWeapon.Mesh);
    if (pMeshCmp != None && pWeapon.MuzzleSocketName != 'None')
    {
        if (pMeshCmp.GetSocketWorldLocationAndRotation(pWeapon.MuzzleSocketName, vTmp, rTmp))
        {
            vHitLocation = vTmp + 1000.0 * Normal(Vector(rTmp));
        }
    }
    pWeapon.DummyFireNumTimes(-1, vHitLocation, pActor, 2.0);
}
public static function PropWepActionExecuteDummyFireOnce(Object pWeaponIn, Actor pActor)
{
    local Vector vHitLocation;
    local Vector vTmp;
    local Rotator rTmp;
    local SkeletalMeshComponent pMeshCmp;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    vHitLocation = vect(0.0, 0.0, 0.0);
    pMeshCmp = SkeletalMeshComponent(pWeapon.Mesh);
    if (pMeshCmp != None && pWeapon.MuzzleSocketName != 'None')
    {
        if (pMeshCmp.GetSocketWorldLocationAndRotation(pWeapon.MuzzleSocketName, vTmp, rTmp))
        {
            vHitLocation = vTmp + 1000.0 * Normal(Vector(rTmp));
        }
    }
    pWeapon.DummyFireNumTimes(1, vHitLocation, pActor, 2.0);
}
public static function PropWepActionExecuteDummyFireThrice(Object pWeaponIn, Actor pActor)
{
    local Vector vHitLocation;
    local Vector vTmp;
    local Rotator rTmp;
    local SkeletalMeshComponent pMeshCmp;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    vHitLocation = vect(0.0, 0.0, 0.0);
    pMeshCmp = SkeletalMeshComponent(pWeapon.Mesh);
    if (pMeshCmp != None && pWeapon.MuzzleSocketName != 'None')
    {
        if (pMeshCmp.GetSocketWorldLocationAndRotation(pWeapon.MuzzleSocketName, vTmp, rTmp))
        {
            vHitLocation = vTmp + 1000.0 * Normal(Vector(rTmp));
        }
    }
    pWeapon.DummyFireNumTimes(3, vHitLocation, pActor, 2.0);
}
public static function PropWepActionExecuteEnableIK(Object pWeaponIn, Actor pActor)
{
    local SFXSkelControlLimb pSkelControl;
    local float fOldBlend;
    local SkeletalMeshComponent pMainMesh;
    local SFXWeapon Weap;
    
    pMainMesh = Class'SFXModule_Gestures'.static.ScriptGetMainMeshComp(pActor);
    if (pMainMesh != None)
    {
        pSkelControl = SFXSkelControlLimb(pMainMesh.FindSkelControl('LeftArm'));
        if (pSkelControl != None)
        {
            Weap = SFXWeapon(pWeaponIn);
            if (Weap != None)
            {
                pSkelControl.SetSkelControlProfile(int(Weap.IKProfileID));
            }
            pSkelControl.bSetStrengthFromAnimNode = FALSE;
            fOldBlend = pSkelControl.BlendInTime;
            pSkelControl.BlendInTime = 0.200000003;
            pSkelControl.SetSkelControlActive(TRUE);
            pSkelControl.BlendInTime = fOldBlend;
        }
    }
}
public static function PropWepActionExecuteExpand(Object pWeaponIn, Actor pActor)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    pWeapon.bForceReplayAnimation = TRUE;
    pWeapon.bInstantExpansion = FALSE;
    pWeapon.Expand();
}
public static function PropWepActionExecuteFire(Object pWeaponIn, Actor pActor)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    pWeapon.PlayFireEffectsOnce();
}
public static function PropWepActionExecuteFireWithTracer(Object pWeaponIn, Actor pActor)
{
    local bool bSavedSuppress;
    local float fSavedTracerDistance;
    local bool bSavedForced;
    local Vector vHitLocation;
    local Vector vTmp;
    local Rotator rTmp;
    local SkeletalMeshComponent pMeshCmp;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    vHitLocation = vect(0.0, 0.0, 0.0);
    pMeshCmp = SkeletalMeshComponent(pWeapon.Mesh);
    if (pMeshCmp != None && pWeapon.MuzzleSocketName != 'None')
    {
        if (pMeshCmp.GetSocketWorldLocationAndRotation(pWeapon.MuzzleSocketName, vTmp, rTmp))
        {
            vHitLocation = vTmp + 1000.0 * Normal(Vector(rTmp));
        }
    }
    bSavedSuppress = pWeapon.bSuppressTracers;
    fSavedTracerDistance = pWeapon.ShowTracerDistance;
    bSavedForced = pWeapon.bForceSpawnTracer;
    pWeapon.bSuppressTracers = FALSE;
    pWeapon.ShowTracerDistance = 0.0;
    pWeapon.bForceSpawnTracer = TRUE;
    pWeapon.PlayFireEffectsOnce(vHitLocation);
    pWeapon.bSuppressTracers = bSavedSuppress;
    pWeapon.ShowTracerDistance = fSavedTracerDistance;
    pWeapon.bForceSpawnTracer = bSavedForced;
}
public static function PropWepActionExecuteReload(Object pWeaponIn, Actor pActor)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None)
    {
        return;
    }
    pWeapon.PlayReloadEject();
}
public static function float PropWepActionTimingCollapse(Object pWeaponIn)
{
    local SkeletalMeshComponent pMeshComp;
    local AnimSet pAnimSet;
    local AnimSequence pCurAnim;
    local int idx;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon != None)
    {
        pMeshComp = SkeletalMeshComponent(pWeapon.Mesh);
        if (pMeshComp != None && pMeshComp.AnimSets.Length > 0)
        {
            pAnimSet = pMeshComp.AnimSets[0];
            if (pAnimSet != None)
            {
                for (idx = 0; idx < pAnimSet.Sequences.Length; idx++)
                {
                    pCurAnim = pAnimSet.Sequences[idx];
                    if (pCurAnim != None && pCurAnim.SequenceName == 'WPN_Collapse')
                    {
                        return pCurAnim.SequenceLength;
                    }
                }
            }
        }
    }
    return 0.0;
}
public static function float PropWepActionTimingDisableIK(Object pWeaponIn)
{
    return 0.0;
}
public static function float PropWepActionTimingDummyFireInfiniteOff(Object pWeaponIn)
{
    return 0.0;
}
public static function float PropWepActionTimingDummyFireInfiniteOn(Object pWeaponIn)
{
    return 0.0;
}
public static function float PropWepActionTimingDummyFireOnce(Object pWeaponIn)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    return PropWepActionTimingFire(pWeapon);
}
public static function float PropWepActionTimingDummyFireThrice(Object pWeaponIn)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    return 3.0 * PropWepActionTimingFire(pWeapon);
}
public static function float PropWepActionTimingEnableIK(Object pWeaponIn)
{
    return 0.200000003;
}
public static function float PropWepActionTimingExpand(Object pWeaponIn)
{
    local SkeletalMeshComponent pMeshComp;
    local AnimSet pAnimSet;
    local AnimSequence pCurAnim;
    local int idx;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon != None)
    {
        pMeshComp = SkeletalMeshComponent(pWeapon.Mesh);
        if (pMeshComp != None && pMeshComp.AnimSets.Length > 0)
        {
            pAnimSet = pMeshComp.AnimSets[0];
            if (pAnimSet != None)
            {
                for (idx = 0; idx < pAnimSet.Sequences.Length; idx++)
                {
                    pCurAnim = pAnimSet.Sequences[idx];
                    if (pCurAnim != None && pCurAnim.SequenceName == 'WPN_Expand')
                    {
                        return pCurAnim.SequenceLength;
                    }
                }
            }
        }
    }
    return 0.0;
}
public static function float PropWepActionTimingFire(Object pWeaponIn)
{
    local int nLooping;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None || pWeapon.PSC_MuzFlashEmitter == None || pWeapon.PSC_MuzFlashEmitter.Template == None)
    {
        return 0.0;
    }
    return FindPartSysMaxDuration(pWeapon.PSC_MuzFlashEmitter.Template, nLooping);
}
public static function float PropWepActionTimingFireWithTracer(Object pWeaponIn)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    return PropWepActionTimingFire(pWeapon);
}
public static function float PropWepActionTimingReload(Object pWeaponIn)
{
    local int nLooping;
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon == None || pWeapon.PSC_MuzFlashEmitter == None || pWeapon.PSC_MuzFlashEmitter.Template == None)
    {
        return 0.0;
    }
    return FindPartSysMaxDuration(pWeapon.PSC_ShellCasing.Template, nLooping);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackPropInst'
    TrackTitle = "Prop"
}