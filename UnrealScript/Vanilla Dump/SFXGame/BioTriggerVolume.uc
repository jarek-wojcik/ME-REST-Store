Class BioTriggerVolume extends TriggerVolume
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
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    Enabled = TRUE
    BrushColor = {B = 100, G = 255, R = 255, A = 255}
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bProjTarget = FALSE
    bForceAllowKismetModification = TRUE
}