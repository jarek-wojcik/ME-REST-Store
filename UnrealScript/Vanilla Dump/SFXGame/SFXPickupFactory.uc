Class SFXPickupFactory extends PickupFactory
    native
    placeable
    abstract;

var(SFXPickupFactory) editinline export LightEnvironmentComponent LightEnvironment;
var(SFXPickupFactory) LightingChannelContainer LightingChannels;

public event simulated function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    PickupMesh.SetLightingChannels(LightingChannels);
}
public event simulated function SetInitialState()
{
    bScriptInitialized = TRUE;
    if (GetModule(Class'SFXModule_SavedUse').HasBeenUsed())
    {
        InitialState = 'Disabled';
    }
    Super.SetInitialState();
}
public simulated function SetPickupMesh()
{
    Super.SetPickupMesh();
    PickupMesh.SetLightEnvironment(LightEnvironment);
}
public function PickedUpBy(Pawn P)
{
    Super.PickedUpBy(P);
    if (!WorldInfo.Game.ShouldRespawn(Self))
    {
        GetModule(Class'SFXModule_SavedUse').Used(P);
    }
}
public simulated function SetPickupHidden()
{
    Super.SetPickupHidden();
    GetModule(Class'SFXSimpleUseModule').m_bTargetable = FALSE;
}
public simulated function SetPickupVisible()
{
    Super.SetPickupVisible();
    GetModule(Class'SFXSimpleUseModule').m_bTargetable = TRUE;
}
public function SpawnCopyFor(Pawn Recipient);

public function Used(Actor User);


state Sleeping 
{
    
Begin:
    SetPickupHidden();
    bRespawnPaused = TRUE;
    while (DelayRespawn())
    {
        Sleep(1.0);
    }
    bRespawnPaused = FALSE;
    Sleep(GetRespawnTime() - RespawnEffectTime);
Respawn:
    SetPickupVisible();
    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('Pickup', , , );
    stop;
};
state Disabled 
{
    
Begin:
    GetModule(Class'SFXSimpleUseModule').m_bTargetable = FALSE;
    stop;
};
auto state Pickup 
{
    public event function BeginState(Name PreviousStateName);
    
    public function CheckTouching();
    
    public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal);
    
    public function RecheckValidTouch();
    
    public function bool ValidTouch(Pawn Other);
    
    public event function float DetourWeight(Pawn Other, float PathWeight);
    
    
Begin:
    GetModule(Class'SFXSimpleUseModule').m_bTargetable = TRUE;
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=PickupFactoryLightEnvironment
    End Object
    Begin Object Class=SFXModule_SavedUse Name=SavedSelMod1
        __OnUsed__Delegate = class'SFXPickupFactory'.Used
        fUseRange = 376.0
        m_fMaxSelectionRangeSqr = 640000.0
        m_bTargetable = TRUE
        bHighPriority = TRUE
    End Object
    LightEnvironment = PickupFactoryLightEnvironment
    CylinderComponent = None
    bNoPathWarnings = TRUE
    bBlocked = TRUE
    bNoAutoConnect = TRUE
    bNotBased = TRUE
    bDestinationOnly = TRUE
    Components = (None, None, None, None, PickupFactoryLightEnvironment)
    Modules = (SavedSelMod1)
    CollisionComponent = None
}