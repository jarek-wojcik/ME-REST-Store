Class Volume extends Brush
    native
    nativereplication;

var(location) const localized string LocationName;
var Actor AssociatedActor;
var(location) int LocationPriority;
var(location) stringref LocationNameStrref;
var(Volume) bool bForcePawnWalk;
var(Volume) bool bProcessAllActors;
var bool bConsiderWhilePathBuilding;

public event simulated function CollisionChanged()
{
    CollisionComponent.SetBlockRigidBody(bCollideActors && bBlockActors);
}
public native function bool Encompasses(Actor Other);

public native function bool EncompassesPoint(Vector Loc);

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (!bCollideActors)
        {
            SetCollision(TRUE, bBlockActors, );
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (bCollideActors)
        {
            SetCollision(FALSE, bBlockActors, );
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        SetCollision(!bCollideActors, bBlockActors, );
    }
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'Actor.bCollideActors', bCollideActors == default.bCollideActors);
}
public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (AssociatedActor != None)
    {
        GotoState('AssociatedTouch', , , );
        InitialState = GetStateName();
    }
}
public event function ProcessActorSetVolume(Actor Other);

public native function bool ScriptLineCheck(const out Vector End, const out Vector Start, const out Vector Extent);

public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    Super(Actor).DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.DrawText("AssociatedActor " $ AssociatedActor, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
}
public simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return LocationName;
}

state AssociatedTouch 
{
    public event function BeginState(Name PreviousStateName)
    {
        local Actor A;
        
        foreach TouchingActors(Class'Actor', A, )
        {
            Touch(A, None, A.location, vect(0.0, 0.0, 1.0));
        }
    }
    public event function UnTouch(Actor Other)
    {
        AssociatedActor.UnTouch(Other);
    }
    public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        AssociatedActor.Touch(Other, OtherComp, HitLocation, HitNormal);
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        bAcceptsLights = TRUE
        CollideActors = TRUE
        BlockNonZeroExtent = TRUE
        bDisableAllRigidBody = TRUE
        AlwaysLoadOnClient = TRUE
        AlwaysLoadOnServer = TRUE
        LightingChannels = {bInitialized = TRUE, Dynamic = TRUE}
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bSkipActorPropertyReplication = TRUE
    bCollideActors = TRUE
}