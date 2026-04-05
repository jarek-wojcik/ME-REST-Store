Class FractureManager extends Actor
    native;

const FSM_DEFAULTRECYCLETIME = 0.2;

var array<FracturedStaticMeshPart> PartPool;
var array<int> FreeParts;
var transient array<FracturedStaticMeshActor> ActorsWithDeferredPartsToSpawn;
var int FSMPartPoolSize;
var(FractureManager) float DestroyVibrationLevel;
var(FractureManager) float DestroyMinAngVel;
var(FractureManager) float ExplosionVelScale;
var(FractureManager) bool bEnableAntiVibration;
var(FractureManager) bool bEnableSpawnChunkEffectForRadialDamage;

public native function CreateFSMParts();

public event simulated function Destroyed()
{
    Super.Destroyed();
    CleanUpFSMParts();
}
public native function float GetFSMDirectSpawnChanceScale();

public native function float GetFSMFractureCullDistanceScale();

public native function FracturedStaticMeshPart GetFSMPart(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation);

public native function float GetFSMRadialSpawnChanceScale();

public native function float GetNumFSMPartsScale();

public event simulated function PreBeginPlay()
{
    Super.PreBeginPlay();
    CreateFSMParts();
}
public simulated native function ResetPoolVisibility();

public event simulated function ReturnPartActor(FracturedStaticMeshPart Part)
{
    FreeParts.AddItem(Part.PartPoolIndex);
}
public event simulated function SpawnChunkDestroyEffect(ParticleSystem Effect, Box ChunkBox, Vector ChunkDir, float Scale)
{
    local Vector ChunkMiddle;
    local ParticleSystemComponent EffectComp;
    
    ChunkMiddle = 0.5 * (ChunkBox.Min + ChunkBox.Max);
    EffectComp = WorldInfo.MyEmitterPool.SpawnEmitter(Effect, ChunkMiddle, Rotator(ChunkDir));
    EffectComp.SetScale(Scale);
}
public simulated function SpawnDeferredParts()
{
    local int CurActorIndex;
    
    if (ActorsWithDeferredPartsToSpawn.Length > 0)
    {
        for (CurActorIndex = 0; CurActorIndex < ActorsWithDeferredPartsToSpawn.Length; ++CurActorIndex)
        {
            if (ActorsWithDeferredPartsToSpawn[CurActorIndex].SpawnDeferredParts())
            {
                ActorsWithDeferredPartsToSpawn.Remove(CurActorIndex, 1);
                --CurActorIndex;
            }
        }
    }
}
public event simulated function FracturedStaticMeshPart SpawnPartActor(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation)
{
    local FracturedStaticMeshPart NewPart;
    
    NewPart = GetFSMPart(Parent, SpawnLocation, SpawnRotation);
    if (NewPart != None)
    {
        NewPart.SetTimer(10.0, FALSE, 'TryToCleanUp', );
    }
    return NewPart;
}
public simulated function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
    SpawnDeferredParts();
}
public final simulated function CleanUpFSMParts()
{
    local int idx;
    
    for (idx = 0; idx < PartPool.Length; idx++)
    {
        PartPool[idx].Destroy();
        PartPool[idx] = None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FSMPartPoolSize = 50
    DestroyVibrationLevel = 3.0
    DestroyMinAngVel = 2.5
    ExplosionVelScale = 1.0
}