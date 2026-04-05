Class RvrClientEffectTrigger extends Trigger
    native
    placeable;

var(RvrClientEffectTrigger) array<RvrClientEffectInstanceConstant> m_lstEffects;
var(RvrClientEffectTrigger) array<Actor> m_lstTargetActors;
var(RvrClientEffectTrigger) Vector m_vSpawnParameters;

public event native function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal);


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