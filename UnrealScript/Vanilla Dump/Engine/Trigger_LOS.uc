Class Trigger_LOS extends Trigger
    placeable;

var array<PlayerController> PCsWithLOS;

public event simulated function Tick(float DeltaTime)
{
    local array<SequenceEvent> losEvents;
    local SeqEvent_LOS Evt;
    local PlayerController Player;
    local int idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local float cameraDist;
    local array<int> ActivateIndices;
    
    if (FindEventsOfClass(Class'SeqEvent_LOS', losEvents))
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', Player)
        {
            if (Player.Pawn != None)
            {
                Player.GetPlayerViewPoint(cameraLoc, cameraRot);
                cameraDist = PointDistToLine(location, Vector(cameraRot), cameraLoc);
                for (idx = 0; idx < losEvents.Length; idx++)
                {
                    Evt = SeqEvent_LOS(losEvents[idx]);
                    if (cameraDist <= Evt.ScreenCenterDistance && VSize(Player.Pawn.location - location) <= Evt.TriggerDistance && Normal(location - cameraLoc) Dot Vector(cameraRot) > 0.0 && (!Evt.bCheckForObstructions || Player.LineOfSightTo(Self, cameraLoc, )))
                    {
                        ActivateIndices[0] = 0;
                        if (PCsWithLOS.Find(Player) == -1 && losEvents[idx].CheckActivate(Self, Player.Pawn, FALSE, ActivateIndices))
                        {
                            PCsWithLOS.AddItem(Player);
                        }
                        continue;
                    }
                    if (PCsWithLOS.Find(Player) != -1)
                    {
                        ActivateIndices[0] = 1;
                        if (losEvents[idx].CheckActivate(Self, Player.Pawn, FALSE, ActivateIndices))
                        {
                            PCsWithLOS.RemoveItem(Player);
                        }
                    }
                }
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
    CylinderComponent = CollisionCylinder
    Components = (Sprite, CollisionCylinder)
    CollisionComponent = CollisionCylinder
}