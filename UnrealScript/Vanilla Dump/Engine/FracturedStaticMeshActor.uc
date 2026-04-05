Class FracturedStaticMeshActor extends Actor
    native
    placeable;

struct native DeferredPartToSpawn 
{
    var Vector InitialVel;
    var Vector InitialAngVel;
    var int ChunkIndex;
    var float RelativeScale;
    var bool bExplosion;
};

var array<int> ChunkHealth;
var(FracturedStaticMeshActor) array<Class<DamageType>> FracturedByDamageType;
var(FracturedStaticMeshActor) array<ParticleSystem> OverrideFragmentDestroyEffects;
var transient array<DeferredPartToSpawn> DeferredPartsToSpawn;
var PhysEffectInfo PartImpactEffect;
var(FracturedStaticMeshActor) int MaxPartsToSpawnAtOnce;
var(FracturedStaticMeshActor) const editinline editconst export FracturedStaticMeshComponent FracturedStaticMeshComponent;
var const editinline transient export FracturedSkinnedMeshComponent SkinnedComponent;
var(FracturedStaticMeshActor) float ChunkHealthScale;
var(FracturedStaticMeshActor) float FractureCullMinDistance;
var(FracturedStaticMeshActor) float FractureCullMaxDistance;
var SoundCue ExplosionFractureSound;
var SoundCue SingleChunkFractureSound;
var transient MaterialInterface MI_LoseChunkPreviousMaterial;
var transient bool bHasShownMissingSoundWarning;
var(FracturedStaticMeshActor) bool bBreakChunksOnActorTouch;

public event simulated native function BreakOffIsolatedIslands(out array<byte> FragmentVis, array<int> IgnoreFrags, Vector ChunkDir, array<FracturedStaticMeshPart> DisableCollWithPart, bool bWantPhysChunks);

public event simulated native function BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles);

public event simulated function Explode()
{
    local array<byte> FragmentVis;
    local int i;
    local Vector SpawnDir;
    local FracturedStaticMesh FracMesh;
    local FracturedStaticMeshPart FracPart;
    local float PartScale;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    for (i = 0; i < FragmentVis.Length; i++)
    {
        if (int(FragmentVis[i]) != 0 && i != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            SpawnDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(i);
            PartScale = FracMesh.ExplosionPhysicsChunkScaleMin + FRand() * (FracMesh.ExplosionPhysicsChunkScaleMax - FracMesh.ExplosionPhysicsChunkScaleMin);
            FracPart = SpawnPart(i, 0.5 * SpawnDir * FracMesh.ChunkLinVel + Velocity, 0.5 * VRand() * FracMesh.ChunkAngVel, PartScale, TRUE);
            if (FracPart != None)
            {
                FracPart.FracturedStaticMeshComponent.SetRBCollidesWithChannel(14, FALSE);
            }
            FragmentVis[i] = 0;
        }
    }
    FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
}
public event simulated function HideFragmentsToMaximizeMemoryUsage()
{
    local array<byte> FragmentVis;
    local int i;
    local int Incr;
    
    Incr = 4;
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    i = 0;
    while (i < FragmentVis.Length)
    {
        if (int(FragmentVis[i]) != 0 && i != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            FragmentVis[i] = 0;
        }
        i += Incr;
    }
    FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
}
public event simulated function HideOneFragment()
{
    local array<byte> FragmentVis;
    local int i;
    
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    for (i = 0; i < FragmentVis.Length; i++)
    {
        if (int(FragmentVis[i]) != 0 && i != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            FragmentVis[i] = 0;
            FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
            return;
        }
    }
}
public event simulated function PostBeginPlay()
{
    local PhysicalMaterial PhysMat;
    
    Super.PostBeginPlay();
    ResetHealth();
    if (!bBreakChunksOnActorTouch)
    {
        SetTickIsDisabled(TRUE);
    }
    PhysMat = FracturedStaticMeshComponent.GetFracturedMeshPhysMaterial();
    PartImpactEffect = PhysMat.FindPhysEffectInfo(0);
    PhysMat.FindFractureSounds(ExplosionFractureSound, SingleChunkFractureSound);
    ResetVisibility();
}
protected final simulated native function RemoveDecals(int IndexToRemoveDecalsFrom);

public final simulated native function ResetHealth();

public event simulated native function ResetVisibility();

public event simulated native function bool SpawnDeferredParts();

public final simulated native function FracturedStaticMeshPart SpawnPart(int ChunkIndex, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion);

public final simulated native function FracturedStaticMeshPart SpawnPartMulti(array<int> ChunkIndices, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion);

public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local array<byte> FragmentVis;
    local Vector ChunkDir;
    local Vector MomentumDir;
    local FracturedStaticMesh FracMesh;
    local FracturedStaticMeshPart FracPart;
    local array<FracturedStaticMeshPart> NoCollParts;
    local int TotalVisible;
    local array<int> IgnoreFrags;
    local Box ChunkBox;
    local ParticleSystem EffectPSys;
    local float PhysChance;
    local float PartScale;
    local byte bWantPhysChunksAndParticles;
    local Pawn InstigatorPawn;
    local WorldFractureSettings FractureSettings;
    local Vector NewHitLocation;
    local Vector HitNormal;
    
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (DamageType != None && !DamageType.default.bCausesFracture || !IsFracturedByDamageType(DamageType))
    {
        return;
    }
    if (HitInfo.HitComponent == None)
    {
        if (Momentum == vect(0.0, 0.0, 0.0))
        {
            Momentum = location - HitLocation;
        }
        TraceComponent(NewHitLocation, HitNormal, FracturedStaticMeshComponent, HitLocation + float(100) * Normal(Momentum), HitLocation, , HitInfo, TRUE);
    }
    if (HitInfo.Item == FracturedStaticMeshComponent.GetCoreFragmentIndex() || !FracturedStaticMeshComponent.IsFragmentVisible(HitInfo.Item) || !FracturedStaticMeshComponent.IsFragmentDestroyable(HitInfo.Item))
    {
        return;
    }
    if (EventInstigator != None)
    {
        InstigatorPawn = EventInstigator.Pawn;
    }
    else if (DamageCauser != None)
    {
        InstigatorPawn = DamageCauser.Instigator;
    }
    if (!FractureEffectIsRelevant(FALSE, InstigatorPawn, bWantPhysChunksAndParticles))
    {
        return;
    }
    if (RB_LineImpulseActor(DamageCauser) != None)
    {
        ChunkHealth[HitInfo.Item] = 0;
    }
    else if (DamageType != None)
    {
        ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage * DamageType.default.FracturedMeshDamage);
    }
    else
    {
        ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage);
    }
    if (ChunkHealth[HitInfo.Item] <= 0)
    {
        FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
        FractureSettings = WorldInfo.GetWorldFractureSettings();
        FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
        TotalVisible = FracturedStaticMeshComponent.GetNumVisibleFragments();
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            if (TotalVisible == 1)
            {
                return;
            }
        }
        if (TotalVisible == FragmentVis.Length)
        {
            SetLoseChunkReplacementMaterial();
        }
        FragmentVis[HitInfo.Item] = 0;
        ChunkDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(HitInfo.Item);
        MomentumDir = Normal(Momentum);
        if (VSize(ChunkDir) < 0.00999999978 || MomentumDir Dot ChunkDir > -0.200000003)
        {
            ChunkDir += MomentumDir;
        }
        ChunkDir.Z = float(Max(int(ChunkDir.Z), 0));
        ChunkDir.Z /= FracMesh.ChunkLinHorizontalScale;
        ChunkDir = Normal(ChunkDir);
        if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
        {
            PhysChance = FractureSettings.bEnableChanceOfPhysicsChunkOverride ? FractureSettings.ChanceOfPhysicsChunkOverride : FracMesh.ChanceOfPhysicsChunk;
            PhysChance *= WorldInfo.MyFractureManager.GetFSMDirectSpawnChanceScale();
            if (int(bWantPhysChunksAndParticles) == 1 && FracMesh.bSpawnPhysicsChunks && FRand() < PhysChance && !FracturedStaticMeshComponent.IsNoPhysFragment(HitInfo.Item))
            {
                PartScale = FracMesh.NormalPhysicsChunkScaleMin + FRand() * (FracMesh.NormalPhysicsChunkScaleMax - FracMesh.NormalPhysicsChunkScaleMin);
                FracPart = SpawnPart(HitInfo.Item, ChunkDir * FracMesh.ChunkLinVel + Velocity, VRand() * FracMesh.ChunkAngVel, PartScale, FALSE);
                if (FracPart != None)
                {
                    FracPart.FracturedStaticMeshComponent.DisableRBCollisionWithSMC(FracturedStaticMeshComponent, TRUE);
                }
            }
            if (int(bWantPhysChunksAndParticles) == 1)
            {
                if (OverrideFragmentDestroyEffects.Length > 0)
                {
                    EffectPSys = OverrideFragmentDestroyEffects[Rand(OverrideFragmentDestroyEffects.Length)];
                }
                else if (FracMesh.FragmentDestroyEffects.Length > 0)
                {
                    EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.Length)];
                }
                if (EffectPSys != None && WorldInfo.MyFractureManager != None)
                {
                    ChunkBox = FracturedStaticMeshComponent.GetFragmentBox(HitInfo.Item);
                    WorldInfo.MyFractureManager.SpawnChunkDestroyEffect(EffectPSys, ChunkBox, ChunkDir, FracMesh.FragmentDestroyEffectScale);
                }
            }
        }
        if (FracturedStaticMeshComponent.GetCoreFragmentIndex() == -1 && !FracMesh.bFixIsolatedChunks)
        {
            IgnoreFrags[0] = HitInfo.Item;
            if (FracPart != None)
            {
                NoCollParts[0] = FracPart;
            }
            BreakOffIsolatedIslands(FragmentVis, IgnoreFrags, ChunkDir, NoCollParts, int(bWantPhysChunksAndParticles) == 1 ? TRUE : FALSE);
        }
        FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            FracturedStaticMeshComponent.RecreatePhysState();
        }
    }
}
public simulated function bool FractureEffectIsRelevant(bool bForceDedicated, Pawn EffectInstigator, out byte bWantPhysChunksAndParticles)
{
    local bool bResult;
    local PlayerController P;
    local float FinalMinDistance;
    local float FinalCullDistance;
    
    bWantPhysChunksAndParticles = 1;
    if (EffectInstigator == None)
    {
        return TRUE;
    }
    else
    {
        if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
        {
            return bForceDedicated;
        }
        if (WorldInfo.NetMode == ENetMode.NM_ListenServer && WorldInfo.Game.NumPlayers > 1)
        {
            if (bForceDedicated)
            {
                return TRUE;
            }
            if (EffectInstigator != None && EffectInstigator.IsHumanControlled() && EffectInstigator.IsLocallyControlled())
            {
                return TRUE;
            }
        }
        else if (EffectInstigator != None && EffectInstigator.IsHumanControlled())
        {
            return TRUE;
        }
        FinalMinDistance = FractureCullMinDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
        FinalCullDistance = FractureCullMaxDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
        foreach LocalPlayerControllers(Class'PlayerController', P)
        {
            if (P.ViewTarget != None)
            {
                if (P.Pawn == EffectInstigator && EffectInstigator != None)
                {
                    return TRUE;
                }
                else
                {
                    if (CheckMaxEffectDistance(P, location, FinalMinDistance))
                    {
                        return TRUE;
                    }
                    bResult = CheckMaxEffectDistance(P, location, FinalCullDistance);
                    break;
                }
            }
        }
        if (bResult)
        {
            if (WorldInfo.TimeSeconds - LastRenderTime < 0.5)
            {
                return TRUE;
            }
            else
            {
                bWantPhysChunksAndParticles = 0;
                return TRUE;
            }
        }
        else
        {
            bWantPhysChunksAndParticles = 0;
            return FALSE;
        }
    }
}
public simulated function bool IsFracturedByDamageType(Class<DamageType> dmgType)
{
    local int i;
    
    if (FracturedByDamageType.Length == 0)
    {
        return TRUE;
    }
    for (i = 0; i < FracturedByDamageType.Length; i++)
    {
        if (dmgType == FracturedByDamageType[i])
        {
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function SetLoseChunkReplacementMaterial()
{
    local MaterialInterface LoseChunkOutsideMat;
    local FracturedStaticMesh FracMesh;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    if (FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride != None)
    {
        LoseChunkOutsideMat = FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride;
    }
    else
    {
        LoseChunkOutsideMat = FracMesh.LoseChunkOutsideMaterial;
    }
    if (LoseChunkOutsideMat != None)
    {
        MI_LoseChunkPreviousMaterial = FracturedStaticMeshComponent.GetMaterial(FracMesh.OutsideMaterialIndex).GetMaterial();
        FracturedStaticMeshComponent.SetMaterial(FracMesh.OutsideMaterialIndex, LoseChunkOutsideMat);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironment0
        bDynamic = FALSE
        bEnabled = FALSE
        bForceNonCompositeDynamicLights = TRUE
    End Object
    Begin Object Class=FracturedSkinnedMeshComponent Name=FracturedSkinnedComponent0
        ReplacementPrimitive = None
        LightEnvironment = LightEnvironment0
        bDisableAllRigidBody = TRUE
    End Object
    Begin Object Class=FracturedStaticMeshComponent Name=FracturedStaticMeshComponent0
        bUseDynamicIBWithHiddenFragments = TRUE
        WireframeColor = {B = 255, G = 128, R = 0, A = 255}
        ReplacementPrimitive = None
        bAllowApproximateOcclusion = TRUE
        bForceDirectLightMap = TRUE
    End Object
    MaxPartsToSpawnAtOnce = 6
    FracturedStaticMeshComponent = FracturedStaticMeshComponent0
    SkinnedComponent = FracturedSkinnedComponent0
    ChunkHealthScale = 1.0
    FractureCullMinDistance = 512.0
    FractureCullMaxDistance = 4096.0
    Components = (LightEnvironment0, FracturedSkinnedComponent0, FracturedStaticMeshComponent0)
    CollisionComponent = FracturedStaticMeshComponent0
    bNoDelete = TRUE
    bWorldGeometry = TRUE
    bRouteBeginPlayEvenIfStatic = FALSE
    bGameRelevant = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bProjTarget = TRUE
    bEdShouldSnap = TRUE
    bPathColliding = TRUE
}