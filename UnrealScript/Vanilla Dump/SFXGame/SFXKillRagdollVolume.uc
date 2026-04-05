Class SFXKillRagdollVolume extends TriggerVolume
    placeable;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Pawn RagdollPawn;
    
    if (Other.Physics == EPhysics.PHYS_RigidBody)
    {
        RagdollPawn = Pawn(Other);
        if (RagdollPawn != None && SFXPawn_PlayerParty(Other) == None)
        {
            RagdollPawn.Suicide();
        }
    }
}
public event function UnTouch(Actor Other);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushColor = {B = 100, G = 255, R = 255, A = 255}
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}