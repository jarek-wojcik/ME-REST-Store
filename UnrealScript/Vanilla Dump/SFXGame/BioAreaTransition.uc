Class BioAreaTransition extends TriggerVolume
    deprecated;

var(BioAreaTransition) Name sMoveToArea;
var(BioAreaTransition) Name sMoveToStartPoint;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (SFXPawn_Player(Other) != None && sMoveToArea != 'None')
    {
        BioWorldInfo(WorldInfo).MoveToArea(sMoveToArea, sMoveToStartPoint);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}