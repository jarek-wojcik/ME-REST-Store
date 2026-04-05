Class SpeedTree
    native;

var const native duplicatetransient Pointer SRH;
var const Guid LightingGuid;
var(Wind) Vector WindDirection;
var(Lighting) float LeafStaticShadowOpacity;
var(Material) MaterialInterface Branch1Material;
var(Material) MaterialInterface Branch2Material;
var(Material) MaterialInterface FrondMaterial;
var(Material) MaterialInterface LeafCardMaterial;
var(Material) MaterialInterface LeafMeshMaterial;
var(Material) MaterialInterface BillboardMaterial;
var(Wind) float WindStrength;
var const bool bLegacySpeedTree;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WindDirection = {X = 1.0, Y = 0.0, Z = 0.0}
    LeafStaticShadowOpacity = 0.5
    WindStrength = 0.200000003
}