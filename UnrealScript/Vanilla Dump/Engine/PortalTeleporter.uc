Class PortalTeleporter extends SceneCapturePortalActor
    native
    abstract;

var(PortalTeleporter) PortalTeleporter SisterPortal;
var(PortalTeleporter) int TextureResolutionX;
var(PortalTeleporter) int TextureResolutionY;
var PortalMarker MyMarker;
var(PortalTeleporter) bool bMovablePortal;
var bool bAlwaysTeleportNonPawns;
var bool bCanTeleportVehicles;

public final native function TextureRenderTarget2D CreatePortalTexture();

public final native function bool TransformActor(Actor A);

public final native function Vector TransformHitLocation(Vector HitLocation);

public final native function Vector TransformVectorDir(Vector V);

public simulated function bool StopsProjectile(Projectile P)
{
    return !TransformActor(P);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SceneCapturePortalComponent Name=SceneCapturePortalComponent0
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent2
        ReplacementPrimitive = None
        HiddenGame = FALSE
        CollideActors = TRUE
    End Template
    TextureResolutionX = 256
    TextureResolutionY = 256
    bAlwaysTeleportNonPawns = TRUE
    StaticMesh = StaticMeshComponent2
    SceneCapture = SceneCapturePortalComponent0
    Components = (SceneCapturePortalComponent0, None, StaticMeshComponent2)
    CollisionComponent = StaticMeshComponent2
    bWorldGeometry = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
}