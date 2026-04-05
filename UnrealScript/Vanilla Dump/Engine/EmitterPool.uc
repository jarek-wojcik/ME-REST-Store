Class EmitterPool extends Actor
    native
    transient
    config(Game);

struct native EmitterBaseInfo 
{
    var Vector RelativeLocation;
    var Rotator RelativeRotation;
    var editinline export ParticleSystemComponent PSC;
    var Actor Base;
    var bool bInheritBaseScale;
};

var const editinline export array<ParticleSystemComponent> PoolComponents;
var editinline export array<ParticleSystemComponent> ActiveComponents;
var editinline array<EmitterBaseInfo> RelativePSCs;
var const editinline export array<StaticMeshComponent> FreeSMComponents;
var const array<MaterialInstanceConstant> FreeMatInstConsts;
var editinline export ParticleSystemComponent PSCTemplate;
var int MaxActiveEffects;
var float SMC_MIC_ReductionTime;
var transient float SMC_MIC_CurrentReductionTime;
var int IdealStaticMeshComponents;
var int IdealMaterialInstanceConstants;
var globalconfig bool bLogPoolOverflow;
var globalconfig bool bLogPoolOverflowList;

public final native function ClearPoolComponents();

protected final native function FreeMaterialInstanceConstants(StaticMeshComponent SMC);

protected final native function FreeStaticMeshComponents(ParticleSystemComponent PSC);

protected final native function MaterialInstanceConstant GetFreeMatInstConsts(optional bool bCreateNewObject = TRUE);

protected final native function StaticMeshComponent GetFreeStaticMeshComponent(optional bool bCreateNewObject = TRUE);

protected final native function ParticleSystemComponent GetPooledComponent(ParticleSystem EmitterTemplate);

protected final native function ReturnToPool(ParticleSystemComponent PSC);

public function OnParticleSystemFinished(ParticleSystemComponent PSC)
{
    local int i;
    
    i = ActiveComponents.Find(PSC);
    if (i != -1)
    {
        ActiveComponents.Remove(i, 1);
        i = RelativePSCs.Find('PSC', PSC);
        if (i != -1)
        {
            RelativePSCs.Remove(i, 1);
        }
        ReturnToPool(PSC);
    }
}
public function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor AttachToActor, optional bool bInheritScaleFromBase)
{
    local int i;
    local ParticleSystemComponent Result;
    
    if (EmitterTemplate != None)
    {
        if (AttachToActor != None && (AttachToActor.bStatic || !AttachToActor.bMovable))
        {
            AttachToActor = None;
        }
        Result = GetPooledComponent(EmitterTemplate);
        if (AttachToActor != None)
        {
            i = RelativePSCs.Length;
            RelativePSCs.Length = i + 1;
            RelativePSCs[i].PSC = Result;
            RelativePSCs[i].Base = AttachToActor;
            RelativePSCs[i].RelativeLocation = SpawnLocation - AttachToActor.location;
            RelativePSCs[i].RelativeRotation = SpawnRotation - AttachToActor.Rotation;
            RelativePSCs[i].bInheritBaseScale = bInheritScaleFromBase;
            if (bInheritScaleFromBase)
            {
                RelativePSCs[i].PSC.SetScale(0.0);
            }
        }
        Result.SetTranslation(SpawnLocation);
        Result.SetRotation(SpawnRotation);
        AttachComponent(Result);
        Result.__OnSystemFinished__Delegate = OnParticleSystemFinished;
        return Result;
    }
    else
    {
        ScriptTrace();
        return None;
    }
}
public function ParticleSystemComponent SpawnEmitterCustomLifetime(ParticleSystem EmitterTemplate)
{
    return GetPooledComponent(EmitterTemplate);
}
public function ParticleSystemComponent SpawnEmitterMeshAttachment(ParticleSystem EmitterTemplate, SkeletalMeshComponent Mesh, Name AttachPointName, optional bool bAttachToSocket, optional Vector RelativeLoc, optional Rotator RelativeRot)
{
    local ParticleSystemComponent Result;
    
    Result = GetPooledComponent(EmitterTemplate);
    Result.SetAbsolute(FALSE, FALSE);
    Result.__OnSystemFinished__Delegate = OnParticleSystemFinished;
    if (bAttachToSocket)
    {
        Mesh.AttachComponentToSocket(Result, AttachPointName);
    }
    else
    {
        Mesh.AttachComponent(Result, AttachPointName, RelativeLoc, RelativeRot);
    }
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        SecondsBeforeInactive = 0.0
        ReplacementPrimitive = None
        AbsoluteTranslation = TRUE
        AbsoluteRotation = TRUE
    End Object
    PSCTemplate = ParticleSystemComponent0
    SMC_MIC_ReductionTime = 2.5
    IdealStaticMeshComponents = 250
    IdealMaterialInstanceConstants = 250
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}