Class EmitterCameraLensEffectBase extends Emitter
    native
    placeable
    abstract;

var ParticleSystem PS_CameraEffect;
var ParticleSystem PS_CameraEffectNonExtremeContent;
var float BaseFOV;
var(EmitterCameraLensEffectBase) const float DistFromCamera;
var transient Camera BaseCamera;
var(EmitterCameraLensEffectBase) const protectedwrite bool bAllowMultipleInstances;

public function Destroyed()
{
    if (BaseCamera != None)
    {
        BaseCamera.RemoveCameraLensEffect(Self);
    }
    Super(Actor).Destroyed();
}
public simulated function PostBeginPlay()
{
    ParticleSystemComponent.SetDepthPriorityGroup(2);
    Super.PostBeginPlay();
    ActivateLensEffect();
}
public simulated native function UpdateLocation(const out Vector CamLoc, const out Rotator CamRot, float CamFOVDeg);

public simulated function ActivateLensEffect()
{
    local ParticleSystem PSToActuallySpawn;
    
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
    {
        if (WorldInfo.GRI.ShouldShowGore())
        {
            PSToActuallySpawn = PS_CameraEffect;
        }
        else
        {
            PSToActuallySpawn = PS_CameraEffectNonExtremeContent;
        }
        if (PSToActuallySpawn != None)
        {
            SetTemplate(PS_CameraEffect, bDestroyOnSystemFinish);
        }
    }
}
public function NotifyRetriggered();

public function RegisterCamera(Camera C)
{
    BaseCamera = C;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=ParticleSystemComponent0
        SecondsBeforeInactive = 0.0
        ReplacementPrimitive = None
        bOnlyOwnerSee = TRUE
    End Template
    BaseFOV = 80.0
    DistFromCamera = 90.0
    ParticleSystemComponent = ParticleSystemComponent0
    bDestroyOnSystemFinish = TRUE
    Components = (ParticleSystemComponent0)
    LifeSpan = 10.0
    bNoDelete = FALSE
    bNetInitialRotation = TRUE
    TickGroup = ETickingGroup.TG_PostAsyncWork
}