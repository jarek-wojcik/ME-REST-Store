Class InstancedStaticMeshComponent extends StaticMeshComponent
    native
    editinlinenew;

struct native InstancedStaticMeshMappingInfo 
{
    var native Pointer Mapping;
    var native Pointer LightMap;
    var Texture2D LightmapTexture;
    var ShadowMap2D ShadowmapTexture;
};
struct native InstancedStaticMeshInstanceData 
{
    var Matrix Transform;
    var Vector2D LightmapUVBias;
    var Vector2D ShadowmapUVBias;
};

var array<InstancedStaticMeshInstanceData> PerInstanceData;
var transient array<InstancedStaticMeshMappingInfo> CachedMappings;
var transient int NumPendingLightmaps;
var int ComponentJoinKey;
var(InstancedStaticMeshComponent) int InstancingRandomSeed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
}