Class BioTrigger extends Trigger
    placeable;

var(BioTrigger) bool Enabled;
var(BioTrigger) bool OneShot;
var transient bool Touched;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (!Touched)
    {
        Touched = TRUE;
        if (Enabled)
        {
            if (OneShot)
            {
                Enabled = FALSE;
            }
        }
    }
}
public event function UnTouch(Actor Other)
{
    if (Touched)
    {
        Touched = FALSE;
        if (Enabled)
        {
            if (OneShot)
            {
                Enabled = FALSE;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SpriteComponent Name=Sprite
        ReplacementPrimitive = None
    End Template
    Enabled = TRUE
    CylinderComponent = CollisionCylinder
    Components = (Sprite, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bProjTarget = FALSE
}