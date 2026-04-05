Class SFXModule_Audio extends SFXModule
    native
    config(Game);

struct native RTPCPair 
{
    var init string RTPCName;
    var float RTPCValue;
};

var array<RTPCPair> RTPCs;
var WwiseEvent DefaultFootStepEvent;
var(SFXModule_Audio) float FootstepCullDistance;
var transient float m_fLastFootStepTime;
var globalconfig float TimeBetweenFootsteps;
var globalconfig float RunThreshold;
var bool bPlayFootstepSounds;

public simulated function Actor PlayFootStepSound(int FootDown, out TraceHitInfo HitInfo)
{
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector TraceStart;
    local Vector TraceEnd;
    local Actor TraceActor;
    local PlayerController P;
    local float Width;
    local float Height;
    local bool bFootstepRelevant;
    
    bFootstepRelevant = FALSE;
    foreach ModuleOwner.LocalPlayerControllers(Class'PlayerController', P)
    {
        if (ModuleOwner.CheckMaxEffectDistance(P, ModuleOwner.location, FootstepCullDistance))
        {
            bFootstepRelevant = TRUE;
            break;
        }
    }
    if (!bFootstepRelevant)
    {
        return None;
    }
    if (ModuleOwner.WorldInfo.TimeSeconds - m_fLastFootStepTime < TimeBetweenFootsteps)
    {
        return None;
    }
    m_fLastFootStepTime = ModuleOwner.WorldInfo.TimeSeconds;
    TraceStart = ModuleOwner.location;
    ModuleOwner.GetBoundingCylinder(Width, Height);
    TraceEnd = ModuleOwner.location - vect(0.0, 0.0, 1.0) * Height * 2.0;
    TraceActor = ModuleOwner.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, , , HitInfo, );
    if (bPlayFootstepSounds)
    {
        PlayStepSound(FootDown, HitInfo);
    }
    return TraceActor;
}
public native function SFXSetAudioComponentRTPCs(ActorComponent pWwiseAudioComponent);

public final simulated function WwiseEvent GetFootStepSound(PhysicalMaterial PhysMat, int FootDown)
{
    if (PhysMat == None || PhysMat.PhysicalMaterialProperty == None || SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty) == None || SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialFootSteps == None)
    {
        return None;
    }
    return GetSpecificFootStepSound(SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialFootSteps, FootDown);
}
public simulated function WwiseEvent GetSpecificFootStepSound(SFXPhysicalMaterialFootSteps FootStepSounds, int FootDown)
{
    local bool isRunning;
    
    if (VSize(ModuleOwner.Velocity) > RunThreshold)
    {
        isRunning = TRUE;
    }
    return isRunning ? FootStepSounds.RunningSound : FootStepSounds.WalkingSound;
}
public final simulated function PlayStepSound(int FootDown, TraceHitInfo HitInfo)
{
    local WwiseEvent FootStepEvent;
    local PhysicalMaterial ParentPhysMaterial;
    
    if (HitInfo.PhysMaterial != None)
    {
        FootStepEvent = GetFootStepSound(HitInfo.PhysMaterial, FootDown);
        ParentPhysMaterial = HitInfo.PhysMaterial.Parent;
    }
    else if (HitInfo.Material != None)
    {
        FootStepEvent = GetFootStepSound(HitInfo.Material.PhysMaterial, FootDown);
        if (HitInfo.Material.PhysMaterial != None)
        {
            ParentPhysMaterial = HitInfo.Material.PhysMaterial.Parent;
        }
    }
    while (FootStepEvent == None && ParentPhysMaterial != None)
    {
        FootStepEvent = GetFootStepSound(ParentPhysMaterial, FootDown);
        ParentPhysMaterial = ParentPhysMaterial.Parent;
    }
    if (FootStepEvent != None)
    {
        ModuleOwner.PlaySound(FootStepEvent, TRUE);
    }
    else
    {
        ModuleOwner.PlaySound(DefaultFootStepEvent, TRUE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultFootStepEvent = WwiseEvent'Wwise_Generic_Foley.Play_foot_metal_run'
    FootstepCullDistance = 1500.0
    TimeBetweenFootsteps = 0.200000003
    RunThreshold = 150.0
    bPlayFootstepSounds = TRUE
}