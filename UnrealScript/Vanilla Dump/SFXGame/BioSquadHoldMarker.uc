Class BioSquadHoldMarker extends NavigationPoint
    native
    placeable;

var(BioSquadHoldMarker) string BaseTag;
var Vector LiftOffset;
var InterpActor MyLift;

public function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (Base == None)
    {
        SetBaseByTag();
    }
    if (Base == MyLift)
    {
        LiftOffset = location - MyLift.location;
    }
}
public native function SetBaseByTag();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=SpriteComponent Name=Sprite_Marker
        Sprite = Texture2D'BioBaseResources.Squad_HoldPoint'
        ReplacementPrimitive = None
        AlwaysLoadOnClient = FALSE
        AlwaysLoadOnServer = FALSE
    End Object
    ExtraCost = 400
    CylinderComponent = CollisionCylinder
    bNeverUseStrafing = TRUE
    bForceNoStrafing = TRUE
    bSpecialMove = TRUE
    bNoAutoConnect = TRUE
    Components = (None, None, CollisionCylinder, None, Sprite_Marker)
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
}