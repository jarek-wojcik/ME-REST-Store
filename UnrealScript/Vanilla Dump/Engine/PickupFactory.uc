Class PickupFactory extends NavigationPoint
    native
    placeable
    nativereplication
    abstract;

var repnotify Class<Inventory> InventoryType;
var float RespawnEffectTime;
var float MaxDesireability;
var editinline transient export PrimitiveComponent PickupMesh;
var PickupFactory ReplacementFactory;
var PickupFactory OriginalFactory;
var bool bOnlyReplicateHidden;
var repnotify bool bPickupHidden;
var bool bPredictRespawns;
var bool bIsSuperItem;
var bool bRespawnPaused;

public event function Destroyed()
{
    if (OriginalFactory != None)
    {
        OriginalFactory.ReplacementFactory = ReplacementFactory;
    }
    if (ReplacementFactory != None)
    {
        ReplacementFactory.OriginalFactory = OriginalFactory;
    }
}
public event function float DetourWeight(Pawn Other, float PathWeight)
{
    return ReplacementFactory != None ? ReplacementFactory.DetourWeight(Other, PathWeight) : 0.0;
}
public event simulated function PreBeginPlay()
{
    InitializePickup();
    Super(Actor).PreBeginPlay();
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bPickupHidden')
    {
        if (bPickupHidden)
        {
            SetPickupHidden();
        }
        else
        {
            SetPickupVisible();
        }
    }
    else if (VarName == 'InventoryType')
    {
        InitializePickup();
    }
}
public function Reset()
{
    if (bIsSuperItem)
    {
        GotoState('Sleeping', , , );
    }
    else
    {
        GotoState('Pickup', , , );
    }
    Super(Actor).Reset();
}
public event simulated function SetInitialState()
{
    bScriptInitialized = TRUE;
    if (InventoryType == None)
    {
        GotoState('Disabled', , , );
    }
    else if (bIsSuperItem)
    {
        GotoState('WaitingForMatch', , , );
    }
    else
    {
        Super(Actor).SetInitialState();
    }
}
public simulated function SetPickupMesh()
{
    if (InventoryType.default.PickupFactoryMesh != None)
    {
        if (PickupMesh != None)
        {
            DetachComponent(PickupMesh);
            PickupMesh = None;
        }
        PickupMesh = new (Self) InventoryType.default.PickupFactoryMesh.Class (InventoryType.default.PickupFactoryMesh);
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
public simulated function ShutDown()
{
    GotoState('Disabled', , , );
}
public function bool CheckForErrors()
{
    local Actor HitActor;
    local Vector HitLocation;
    local Vector HitNormal;
    
    HitActor = Trace(HitLocation, HitNormal, location - vect(0.0, 0.0, 10.0), location, FALSE, , , );
    if (HitActor == None)
    {
        return TRUE;
    }
    return Super(Actor).CheckForErrors();
}
public function PickedUpBy(Pawn P)
{
    SetRespawn();
    TriggerEventClass(Class'SeqEvent_PickupStatusChange', P, 1);
    if (P.Controller != None && P.Controller.MoveTarget == Self)
    {
        P.SetAnchor(Self);
        P.Controller.MoveTimer = -1.0;
    }
}
public function bool DelayRespawn()
{
    return FALSE;
}
public function float GetRespawnTime()
{
    return InventoryType.default.RespawnTime;
}
public function GiveTo(Pawn P)
{
    SpawnCopyFor(P);
    PickedUpBy(P);
}
public simulated function InitializePickup()
{
    if (InventoryType == None)
    {
        return;
    }
    bPredictRespawns = InventoryType.default.bPredictRespawns;
    MaxDesireability = InventoryType.default.MaxDesireability;
    SetPickupMesh();
    bIsSuperItem = InventoryType.default.bDelayedSpawn;
}
public function bool ReadyToPickup(float MaxWait)
{
    return FALSE;
}
public function RecheckValidTouch();

public function RespawnEffect();

public simulated function SetPickupHidden()
{
    bForceNetUpdate = TRUE;
    bPickupHidden = TRUE;
    if (PickupMesh != None)
    {
        PickupMesh.SetHidden(TRUE);
    }
}
public simulated function SetPickupVisible()
{
    bForceNetUpdate = TRUE;
    bPickupHidden = FALSE;
    if (PickupMesh != None)
    {
        PickupMesh.SetHidden(FALSE);
    }
}
public function SetRespawn()
{
    if (InventoryType.default.RespawnTime != float(0) && WorldInfo.Game.ShouldRespawn(Self))
    {
        StartSleeping();
    }
    else
    {
        GotoState('Disabled', , , );
    }
}
public function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;
    
    Inv = Spawn(InventoryType);
    if (Inv != None)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
    }
}
public function StartSleeping()
{
    GotoState('Sleeping', , , );
}
public static function StaticPrecache(WorldInfo W);


state Disabled 
{
    public event simulated function EndState(Name NextStateName)
    {
        SetPickupVisible();
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        SetPickupHidden();
        SetCollision(FALSE, FALSE, );
    }
    public event simulated function SetInitialState()
    {
        bScriptInitialized = TRUE;
    }
    public function StartSleeping();
    
    public function Reset();
    
    public function bool ReadyToPickup(float MaxWait)
    {
        return FALSE;
    }
    
    stop;
};
state Sleeping 
{
    ignores Touch
    ;
    public event function EndState(Name NextStateName)
    {
        SetPickupVisible();
    }
    public event function BeginState(Name PreviousStateName)
    {
        SetPickupHidden();
    }
    public function StartSleeping();
    
    public function bool ReadyToPickup(float MaxWait)
    {
        return bPredictRespawns && !bRespawnPaused && LatentFloat <= MaxWait && LatentFloat > 0.0;
    }
    
Begin:
    bRespawnPaused = TRUE;
    while (DelayRespawn())
    {
        Sleep(1.0);
    }
    bRespawnPaused = FALSE;
    Sleep(GetRespawnTime() - RespawnEffectTime);
Respawn:
    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('Pickup', , , );
    stop;
};
state WaitingForMatch 
{
    ignores Touch
    ;
    public event function BeginState(Name PreviousStateName)
    {
        SetPickupHidden();
    }
    public function MatchStarting()
    {
        GotoState('Sleeping', , , );
    }
    
    stop;
};
auto state Pickup 
{
    public event function BeginState(Name PreviousStateName)
    {
        TriggerEventClass(Class'SeqEvent_PickupStatusChange', None, 0);
    }
    public function CheckTouching()
    {
        local Pawn P;
        
        foreach TouchingActors(Class'Pawn', P, )
        {
            Touch(P, None, location, Normal(location - P.location));
        }
    }
    public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;
        
        P = Pawn(Other);
        if (P != None && ValidTouch(P))
        {
            GiveTo(P);
        }
    }
    public function RecheckValidTouch()
    {
        CheckTouching();
    }
    public function bool ValidTouch(Pawn Other)
    {
        if (Other == None || !Other.bCanPickupInventory)
        {
            return FALSE;
        }
        else if (Other.Controller == None)
        {
            SetTimer(0.200000003, FALSE, 'RecheckValidTouch', );
            return FALSE;
        }
        else if (!FastTrace(Other.location, location, , ))
        {
            SetTimer(0.5, FALSE, 'RecheckValidTouch', );
            return FALSE;
        }
        if (WorldInfo.Game.PickupQuery(Other, InventoryType, Self))
        {
            return TRUE;
        }
        return FALSE;
    }
    public function bool ReadyToPickup(float MaxWait)
    {
        return TRUE;
    }
    public event function float DetourWeight(Pawn Other, float PathWeight)
    {
        return InventoryType.static.DetourWeight(Other, PathWeight);
    }
    
Begin:
    CheckTouching();
    stop;
};

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        bPickupHidden;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        InventoryType;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 80.0
        CollisionRadius = 40.0
        ReplacementPrimitive = None
        CollideActors = TRUE
    End Template
    bOnlyReplicateHidden = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    NetUpdateFrequency = 1.0
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
    bIgnoreEncroachers = TRUE
    bAlwaysRelevant = TRUE
    bCollideWhenPlacing = FALSE
    bCollideActors = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}