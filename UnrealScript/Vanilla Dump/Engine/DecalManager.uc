Class DecalManager extends Actor
    native
    config(Game);

struct native ActiveDecalInfo 
{
    var editinline export DecalComponent Decal;
    var float LifetimeRemaining;
};

var editinline export array<DecalComponent> PoolDecals;
var editinline array<ActiveDecalInfo> ActiveDecals;
var Vector2D DecalBlendRange;
var editinline export DecalComponent DecalTemplate;
var int MaxActiveDecals;
var globalconfig float DecalLifeSpan;
var float DecalDepthBias;

public static final native function bool AreDynamicDecalsEnabled();

public final native function AttachDecal(DecalComponent InDecalComponent, float InDecalLifeSpan);

public final native function bool CanSpawnDecals();

public event function DecalFinished(DecalComponent Decal)
{
    Decal.ResetToDefaults();
    PoolDecals[PoolDecals.Length] = Decal;
}
protected final native function DecalComponent GetPooledComponent();

public event function ResetPool()
{
    local int i;
    local DecalComponent Decal;
    
    for (i = 0; i != ActiveDecals.Length; ++i)
    {
        Decal = ActiveDecals[i].Decal;
        Decal.ResetToDefaults();
        PoolDecals[PoolDecals.Length] = Decal;
    }
    ActiveDecals.Length = 0;
}
public static final function SetDecalParameters(DecalComponent TheDecal, MaterialInterface DecalMaterial, Vector DecalLocation, Rotator DecalOrientation, float Width, float Height, float Thickness, bool bNoClip, float DecalRotation, PrimitiveComponent HitComponent, bool bProjectOnTerrain, bool bProjectOnSkeletalMeshes, Name HitBone, int HitNodeIndex, int HitLevelIndex, int InFracturedStaticMeshComponentIndex, float DepthBias, Vector2D BlendRange)
{
    TheDecal.location = DecalLocation;
    TheDecal.Orientation = DecalOrientation;
    TheDecal.DecalRotation = DecalRotation;
    TheDecal.Width = Width;
    TheDecal.Height = Height;
    TheDecal.FarPlane = Thickness * 0.5;
    TheDecal.NearPlane = -TheDecal.FarPlane;
    TheDecal.bNoClip = bNoClip;
    TheDecal.HitComponent = HitComponent;
    TheDecal.HitBone = HitBone;
    TheDecal.HitNodeIndex = HitNodeIndex;
    TheDecal.HitLevelIndex = HitLevelIndex;
    TheDecal.SetDecalMaterial(DecalMaterial);
    TheDecal.bProjectOnTerrain = bProjectOnTerrain;
    TheDecal.bProjectOnSkeletalMeshes = bProjectOnSkeletalMeshes;
    TheDecal.FracturedStaticMeshComponentIndex = InFracturedStaticMeshComponentIndex;
    TheDecal.DepthBias = DepthBias;
    TheDecal.BlendRange = BlendRange;
}
public function DecalComponent SpawnDecal(MaterialInterface DecalMaterial, Vector DecalLocation, Rotator DecalOrientation, float Width, float Height, float Thickness, bool bNoClip, optional float DecalRotation = FRand() * 360.0, optional PrimitiveComponent HitComponent, optional bool bProjectOnTerrain = TRUE, optional bool bProjectOnSkeletalMeshes, optional Name HitBone, optional int HitNodeIndex = -1, optional int HitLevelIndex = -1, optional float InDecalLifeSpan = DecalLifeSpan, optional int InFracturedStaticMeshComponentIndex = -1, optional float InDepthBias = DecalDepthBias, optional Vector2D InBlendRange = DecalBlendRange)
{
    local DecalComponent Result;
    
    if (!CanSpawnDecals())
    {
        return None;
    }
    Result = GetPooledComponent();
    SetDecalParameters(Result, DecalMaterial, DecalLocation, DecalOrientation, Width, Height, Thickness, bNoClip, DecalRotation, HitComponent, bProjectOnTerrain, bProjectOnSkeletalMeshes, HitBone, HitNodeIndex, HitLevelIndex, -1, InDepthBias, InBlendRange);
    AttachDecal(Result, InDecalLifeSpan);
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DecalComponent Name=BaseDecal
        DepthBias = -0.000039999999
        ReplacementPrimitive = None
        bIgnoreOwnerHidden = TRUE
    End Object
    DecalBlendRange = {X = 89.5, Y = 180.0}
    DecalTemplate = BaseDecal
    DecalLifeSpan = 10.0
    DecalDepthBias = -0.0000599999985
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}