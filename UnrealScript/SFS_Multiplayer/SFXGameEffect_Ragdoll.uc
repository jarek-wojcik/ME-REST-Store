Class SFXGameEffect_Ragdoll extends SFXGameEffect_PhysicsPower;

public function OnRemoved()
{
    local BioPawn Pawn;
    
    Super(SFXGameEffect).OnRemoved();
    Pawn = BioPawn(Owner);
    if (Owner == None || Pawn == None)
    {
        return;
    }
    Pawn.DecrementRagdollCount();
}
public function OnApplied()
{
    local BioPawn Pawn;
    local Vector impulse;
    local Vector HitLocation;
    
    Pawn = BioPawn(Owner);
    if (Owner == None || Pawn == None)
    {
        return;
    }
    Pawn.AddRagdollImpulse(impulse, Instigator, HitLocation, TRUE, 'None');
    Pawn.IncrementRagdollCount();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}