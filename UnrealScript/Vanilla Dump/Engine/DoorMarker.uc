Class DoorMarker extends NavigationPoint
    native
    placeable;

enum EDoorType
{
    DOOR_Shoot,
    DOOR_Touch,
};

var(DoorMarker) InterpActor MyDoor;
var(DoorMarker) Actor DoorTrigger;
var(DoorMarker) bool bWaitUntilCompletelyOpened;
var(DoorMarker) bool bInitiallyClosed;
var(DoorMarker) bool bBlockedWhenClosed;
var bool bDoorOpen;
var const transient bool bTempDisabledCollision;
var(DoorMarker) EDoorType DoorType;

public event function PostBeginPlay()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    Super(Actor).PostBeginPlay();
}
public event function Actor SpecialHandling(Pawn Other)
{
    local Actor TouchActor;
    
    if (bDoorOpen || MyDoor == None || bInitiallyClosed == (bDoorOpen || VSizeSq(MyDoor.Velocity) > 1.0))
    {
        return Self;
    }
    else if (DoorType == EDoorType.DOOR_Touch)
    {
        if (DoorTrigger == None)
        {
            return MyDoor;
        }
        else
        {
            TouchActor = DoorTrigger.SpecialHandling(Other);
            if (TouchActor == None)
            {
                TouchActor = DoorTrigger;
            }
            return TouchActor;
        }
    }
    else
    {
        return Self;
    }
}
public event function bool SuggestMovePreparation(Pawn Other)
{
    if (bDoorOpen || MyDoor == None)
    {
        return FALSE;
    }
    else if (VSizeSq(MyDoor.Velocity) > 1.0)
    {
        Other.Controller.WaitForMover(MyDoor);
        return TRUE;
    }
    else if (DoorType == EDoorType.DOOR_Shoot)
    {
        Other.Controller.Focus = DoorTrigger != None ? DoorTrigger : MyDoor;
        if (!Other.Controller.FireWeaponAt(Other.Controller.Focus))
        {
            Other.Controller.MoveTimer = 0.25;
            Other.Controller.bPreparingMove = TRUE;
            return TRUE;
        }
        else if (bWaitUntilCompletelyOpened)
        {
            Other.Controller.WaitForMover(MyDoor);
            Other.Controller.bPreparingMove = TRUE;
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else if (DoorType == EDoorType.DOOR_Touch && DoorTrigger != None && Other.Controller.ActorReachable(DoorTrigger))
    {
        if (Other.Controller.Focus == Other.Controller.MoveTarget)
        {
            Other.Controller.Focus = DoorTrigger;
        }
        Other.Controller.MoveTarget = DoorTrigger;
        Other.Controller.CurrentPath = None;
        Other.Controller.NextRoutePath = None;
        return FALSE;
    }
    else
    {
        return FALSE;
    }
}
public function MoverClosed()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    WorldInfo.Game.NotifyNavigationChanged(Self);
}
public function MoverOpened()
{
    bBlocked = !bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = bInitiallyClosed;
    WorldInfo.Game.NotifyNavigationChanged(Self);
}
public function bool ProceedWithMove(Pawn Other)
{
    if (DoorType == EDoorType.DOOR_Shoot && Other.Controller.Focus == MyDoor)
    {
        Other.Controller.StopFiring();
    }
    if (bDoorOpen || DoorType != EDoorType.DOOR_Shoot)
    {
        return TRUE;
    }
    Other.Controller.Focus = DoorTrigger != None ? DoorTrigger : MyDoor;
    if (!Other.Controller.FireWeaponAt(Other.Controller.Focus))
    {
        Other.Controller.MoveTimer = 0.25;
    }
    else if (bWaitUntilCompletelyOpened)
    {
        Other.Controller.WaitForMover(MyDoor);
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    bInitiallyClosed = TRUE
    ExtraCost = 100
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}