Class SFXProjectile_PowerCustomAction_CombatDroneRocket extends SFXProjectile_PowerCustomAction_Seeking
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    fFuseLength = 5.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}