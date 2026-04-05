Class Trigger_Dynamic extends Trigger
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SpriteComponent Name=Sprite
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (Sprite, CollisionCylinder)
    CollisionComponent = CollisionCylinder
}