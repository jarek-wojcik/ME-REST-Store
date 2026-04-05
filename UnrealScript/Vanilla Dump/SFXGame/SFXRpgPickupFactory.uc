Class SFXRpgPickupFactory extends SFXPickupFactory
    native
    placeable
    abstract;

public event simulated function SetInitialState()
{
    bScriptInitialized = TRUE;
    if (!HasPickup())
    {
        GotoState('Disabled', , , );
    }
    else if (GetModule(Class'SFXModule_SavedUse').HasBeenUsed())
    {
        GotoState('Disabled', , , );
    }
    else if (InitialState != 'None')
    {
        GotoState(InitialState, , , );
    }
    else
    {
        GotoState('Auto', , , );
    }
}
public simulated function SetPickupMesh()
{
    local PrimitiveComponent PMesh;
    
    if (!HasPickup())
    {
        return;
    }
    PMesh = GetPickupMesh();
    if (PMesh != None)
    {
        if (PickupMesh != None)
        {
            DetachComponent(PickupMesh);
            PickupMesh = None;
        }
        PickupMesh = new (Self) PMesh.Class (PMesh);
        AttachComponent(PickupMesh);
        if (bPickupHidden)
        {
            SetPickupHidden();
        }
        else
        {
            SetPickupVisible();
        }
    }
}
public simulated function InitializePickup()
{
    if (HasPickup())
    {
        SetTooltips();
        SetPickupMesh();
    }
    SetPickupMesh();
}
public function SetRespawn()
{
    GotoState('Disabled', , , );
}
public function SpawnCopyFor(Pawn Recipient);

public simulated function PrimitiveComponent GetPickupMesh()
{
    return None;
}
public simulated function bool HasPickup()
{
    return TRUE;
}
public simulated function SetTooltips();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=PickupFactoryLightEnvironment
    End Template
    Begin Template Class=SFXModule_SavedUse Name=SavedSelMod1
        __OnUsed__Delegate = class'SFXRpgPickupFactory'.Used
    End Template
    LightEnvironment = PickupFactoryLightEnvironment
    Components = (None, None, None, None, PickupFactoryLightEnvironment)
    Modules = (SavedSelMod1)
}