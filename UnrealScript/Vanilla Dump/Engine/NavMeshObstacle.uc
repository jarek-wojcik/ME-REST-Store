Class NavMeshObstacle extends Actor
    implements(Interface_NavMeshPathObstacle)
    native
    placeable;

var const native noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var(NavMeshObstacle) bool bEnabled;
var(NavMeshObstacle) bool bPreserveInternalGeo;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
    SetEnabled(bEnabled);
}
public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bEnabled)
    {
        RegisterObstacle();
    }
}
public native function RegisterObstacle();

public function SetEnabled(bool bInEnabled)
{
    if (bInEnabled)
    {
        RegisterObstacle();
    }
    else
    {
        UnRegisterObstacle();
    }
}
public native function UnRegisterObstacle();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawBoxComponent Name=DrawBox0
        BoxColor = {B = 255, G = 70, R = 64, A = 255}
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SpriteComponent Name=Sprite
        ReplacementPrimitive = None
        AlwaysLoadOnClient = FALSE
        AlwaysLoadOnServer = FALSE
    End Object
    Components = (Sprite, DrawBox0)
}