Class SFXAnimationMarker extends Actor
    native
    placeable;

var(SFXAnimationMarker) string Text;
var editinline export StaticMeshComponent ZoneMeshComp;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None, None)
    DrawScale3D = {X = 4.0, Y = 4.0, Z = 1.0}
    bStatic = TRUE
    bHidden = TRUE
    bNoDelete = TRUE
    bMovable = FALSE
}