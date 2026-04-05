Class TriggerStreamingLevel extends Trigger
    placeable;

struct LevelStreamingData 
{
    var(LevelStreamingData) LevelStreaming Level;
    var(LevelStreamingData) bool bShouldBeLoaded;
    var(LevelStreamingData) bool bShouldBeVisible;
    var(LevelStreamingData) bool bShouldBlockOnLoad;
};

var(TriggerStreamingLevel) array<LevelStreamingData> Levels;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local PlayerController PlayerCon;
    local int Index;
    
    Super.Touch(Other, OtherComp, HitLocation, HitNormal);
    for (Index = 0; Index < Levels.Length; Index++)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PlayerCon)
        {
            Levels[Index].Level.bShouldBlockOnLoad = Levels[Index].bShouldBlockOnLoad;
            PlayerCon.LevelStreamingStatusChanged(Levels[Index].Level, Levels[Index].bShouldBeLoaded, Levels[Index].bShouldBeVisible, Levels[Index].bShouldBlockOnLoad);
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
    CylinderComponent = CollisionCylinder
    Components = (Sprite, CollisionCylinder)
    CollisionComponent = CollisionCylinder
}