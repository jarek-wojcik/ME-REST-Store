Class Emitter extends Actor
    native
    placeable;

struct CheckpointRecord 
{
    var bool bIsActive;
    
    structdefaultproperties
    {
        bIsActive = FALSE
    }
};

var(Emitter) const editinline editconst export ParticleSystemComponent ParticleSystemComponent;
var(Emitter) const editinline editconst export DynamicLightEnvironmentComponent LightEnvironment;
var bool bDestroyOnSystemFinish;
var(Emitter) bool bPostUpdateTickGroup;
var(Audio) bool bNoVFXSound;
var repnotify bool bCurrentlyActive;

public function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        ParticleSystemComponent.ActivateSystem();
        bCurrentlyActive = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ParticleSystemComponent.DeactivateSystem();
        bCurrentlyActive = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (ParticleSystemComponent.bSuppressSpawning || !bCurrentlyActive)
        {
            ParticleSystemComponent.ActivateSystem();
            bCurrentlyActive = TRUE;
        }
        else
        {
            ParticleSystemComponent.DeactivateSystem();
            bCurrentlyActive = FALSE;
        }
    }
    ParticleSystemComponent.LastRenderTime = WorldInfo.TimeSeconds;
    ForceNetRelevant();
    if (RemoteRole != ENetRole.ROLE_None)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'bCurrentlyActive', bCurrentlyActive == default.bCurrentlyActive);
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer && (RemoteRole == ENetRole.ROLE_None || bNetTemporary))
    {
        LifeSpan = 0.200000003;
    }
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.__OnSystemFinished__Delegate = OnParticleSystemFinished;
        bCurrentlyActive = ParticleSystemComponent.bAutoActivate;
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bCurrentlyActive')
    {
        ParticleSystemComponent.SetActive(bCurrentlyActive);
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public native function ResetPSC();

public simulated function SetActorParameter(Name ParameterName, Actor Param)
{
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.SetActorParameter(ParameterName, Param);
    }
}
public simulated function SetColorParameter(Name ParameterName, Color Param)
{
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.SetColorParameter(ParameterName, Param);
    }
}
public simulated function SetFloatParameter(Name ParameterName, float Param)
{
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.SetFloatParameter(ParameterName, Param);
    }
}
public event native function SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish);

public simulated function SetVectorParameter(Name ParameterName, Vector Param)
{
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.SetVectorParameter(ParameterName, Param);
    }
}
public simulated function ShutDown()
{
    Super.ShutDown();
    bCurrentlyActive = FALSE;
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bCurrentlyActive = Record.bIsActive;
    if (bCurrentlyActive)
    {
        ParticleSystemComponent.ActivateSystem();
    }
    else
    {
        ParticleSystemComponent.DeactivateSystem();
    }
    ForceNetRelevant();
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bIsActive = bCurrentlyActive;
}
public simulated function HideSelf();

public function OnParticleEventGenerator(SeqAct_ParticleEventGenerator Action);

public simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    if (bDestroyOnSystemFinish)
    {
        LifeSpan = 0.0000999999975;
    }
    bCurrentlyActive = FALSE;
}
public simulated function OnSetParticleSysParam(SeqAct_SetParticleSysParam Action)
{
    local int idx;
    local int ParamIdx;
    
    if (ParticleSystemComponent != None && Action.InstanceParameters.Length > 0)
    {
        for (idx = 0; idx < Action.InstanceParameters.Length; idx++)
        {
            if (Action.InstanceParameters[idx].ParamType != EParticleSysParamType.PSPT_None)
            {
                ParamIdx = ParticleSystemComponent.InstanceParameters.Find('Name', Action.InstanceParameters[idx].Name);
                if (ParamIdx == -1)
                {
                    ParamIdx = ParticleSystemComponent.InstanceParameters.Length;
                    ParticleSystemComponent.InstanceParameters.Length = ParamIdx + 1;
                }
                ParticleSystemComponent.InstanceParameters[ParamIdx] = Action.InstanceParameters[idx];
                if (Action.bOverrideScalar)
                {
                    ParticleSystemComponent.InstanceParameters[ParamIdx].Scalar = Action.ScalarValue;
                }
            }
        }
    }
}
public simulated function SetExtColorParameter(Name ParameterName, byte Red, byte Green, byte Blue, byte Alpha)
{
    local Color C;
    
    if (ParticleSystemComponent != None)
    {
        C.R = Red;
        C.G = Green;
        C.B = Blue;
        C.A = Alpha;
        ParticleSystemComponent.SetColorParameter(ParameterName, C);
    }
}
public function bool ShouldSaveForCheckpoint()
{
    return bNoDelete && RemoteRole != ENetRole.ROLE_None;
}

replication
{
    if (bNoDelete)
        bCurrentlyActive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        ReplacementPrimitive = None
    End Object
    ParticleSystemComponent = ParticleSystemComponent0
    Components = (None, ParticleSystemComponent0, None)
    bNoDelete = TRUE
    bHardAttach = TRUE
    bGameRelevant = TRUE
    bEdShouldSnap = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}