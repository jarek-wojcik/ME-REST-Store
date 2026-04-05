Class SFXPlaceableBase extends InterpActor
    native
    placeable
    abstract;

var(Save) const Guid MyGuid;
var bool bIsDeactivated;
var bool bIsDestroyed;

public event simulated function PostBeginPlay()
{
    local SFXEngine Engine;
    local int idx;
    
    Super.PostBeginPlay();
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    idx = Engine.SavedPlaceableList.Find('PlaceableGUID', MyGuid);
    if (idx != -1)
    {
        bIsDestroyed = bool(Engine.SavedPlaceableList[idx].bIsDestroyed);
        if (bIsDestroyed)
        {
            SetDestroyed();
        }
        bIsDeactivated = bool(Engine.SavedPlaceableList[idx].bIsDeactivated);
        if (bIsDeactivated)
        {
            DeactivatePlaceable();
        }
    }
}
public simulated function ActivatePlaceable()
{
    bIsDeactivated = FALSE;
}
public simulated function DeactivatePlaceable()
{
    bIsDeactivated = TRUE;
}
public function GetDebugStrings(out array<string> DebugStrings);

public function GetDifficultyDebugStrings(out array<string> DifficultyDebugStrings);

public simulated function PlaceableDestroyed()
{
    bIsDestroyed = TRUE;
}
public simulated function ResetPlaceable()
{
    bIsDestroyed = default.bIsDestroyed;
    bIsDeactivated = default.bIsDeactivated;
}
public function SetDestroyed();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
}