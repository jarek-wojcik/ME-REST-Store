Class SFXDoorMarker extends NavigationPoint
    native
    placeable;

var(SFXDoorMarker) SFXDoor MyDoor;
var const transient int nUnblockCount;
var(SFXDoorMarker) bool bWaitUntilCompletelyOpened;
var(SFXDoorMarker) bool bInitiallyClosed;
var(SFXDoorMarker) bool bBlockedWhenClosed;
var bool bDoorOpen;
var const transient bool bTempDisabledCollision;
var const transient bool bPrevBlockedState;

public event function PostBeginPlay()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    UpdateConnectingPaths();
    Super(Actor).PostBeginPlay();
}
public native function int RestoreDoorMarkerBlockedState();

public event function Actor SpecialHandling(Pawn Other)
{
    return Self;
}
public event function bool SuggestMovePreparation(Pawn Other)
{
    if (bDoorOpen || MyDoor == None)
    {
        return FALSE;
    }
    return TRUE;
}
public native function int UnblockDoorMarker();

public final native function UpdateConnectingPaths();

public function bool ProceedWithMove(Pawn Other)
{
    return bDoorOpen;
}
public function DoorClosed()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    UpdateConnectingPaths();
    WorldInfo.Game.NotifyNavigationChanged(Self);
}
public function DoorOpened()
{
    bBlocked = !bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = bInitiallyClosed;
    UpdateConnectingPaths();
    WorldInfo.Game.NotifyNavigationChanged(Self);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    bInitiallyClosed = TRUE
    bBlockedWhenClosed = TRUE
    ExtraCost = 100
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}