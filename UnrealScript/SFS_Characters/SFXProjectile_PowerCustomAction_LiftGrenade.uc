Class SFXProjectile_PowerCustomAction_LiftGrenade extends SFXProjectile_PowerCustomAction_BouncingGrenade
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    SpeedThresholdFuseLength = 0.100000001
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}