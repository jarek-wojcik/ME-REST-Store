Class KMeshProps
    native
    noexport;

struct KAggregateGeom 
{
    var(KAggregateGeom) editfixedsize array<KSphereElem> SphereElems;
    var(KAggregateGeom) editfixedsize array<KBoxElem> BoxElems;
    var(KAggregateGeom) editfixedsize array<KSphylElem> SphylElems;
    var(KAggregateGeom) editfixedsize array<KConvexElem> ConvexElems;
    var native noimport nontransactional Pointer RenderInfo;
    var(KAggregateGeom) bool bSkipCloseAndParallelChecks;
};
struct KConvexElem 
{
    var array<Vector> VertexData;
    var array<Plane> PermutedVertexData;
    var array<int> FaceTriData;
    var array<Vector> EdgeDirections;
    var array<Vector> FaceNormalDirections;
    var array<Plane> FacePlaneData;
    var Box ElemBox;
};
struct KSphylElem 
{
    var(KSphylElem) editconst Matrix TM;
    var(KSphylElem) editconst float Radius;
    var(KSphylElem) editconst float Length;
    var(KSphylElem) bool bNoRBCollision;
    var(KSphylElem) bool bPerPolyShape;
    
    structdefaultproperties
    {
        TM = {
              XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
              YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
              ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
              WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
             }
        Radius = 1.0
        Length = 1.0
    }
};
struct KBoxElem 
{
    var(KBoxElem) editconst Matrix TM;
    var(KBoxElem) editconst float X;
    var(KBoxElem) editconst float Y;
    var(KBoxElem) editconst float Z;
    var(KBoxElem) bool bNoRBCollision;
    var(KBoxElem) bool bPerPolyShape;
    
    structdefaultproperties
    {
        TM = {
              XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
              YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
              ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
              WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
             }
        X = 1.0
        Y = 1.0
        Z = 1.0
    }
};
struct KSphereElem 
{
    var(KSphereElem) editconst Matrix TM;
    var(KSphereElem) editconst float Radius;
    var(KSphereElem) bool bNoRBCollision;
    var(KSphereElem) bool bPerPolyShape;
    
    structdefaultproperties
    {
        TM = {
              XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
              YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
              ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
              WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
             }
        Radius = 1.0
    }
};

var(KMeshProps) Vector COMNudge;
var(KMeshProps) KAggregateGeom AggGeom;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}