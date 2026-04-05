Class DynamicSMActor extends Actor
    native
    abstract;

var repnotify Vector ReplicatedMeshTranslation;
var repnotify Rotator ReplicatedMeshRotation;
var repnotify Vector ReplicatedMeshScale3D;
var(DynamicSMActor) const editinline editconst export StaticMeshComponent StaticMeshComponent;
var(DynamicSMActor) const editinline editconst export DynamicLightEnvironmentComponent LightEnvironment;
var transient repnotify StaticMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial;
var repnotify bool bForceStaticDecals;
var(DynamicSMActor) bool bPawnCanBaseOn;
var(DynamicSMActor) bool bSafeBaseIfAsleep;

public event function Attach(Actor Other)
{
    local Pawn P;
    
    Super.Attach(Other);
    if (bSafeBaseIfAsleep)
    {
        P = Pawn(Other);
        if (P != None)
        {
            SetPhysics(0);
        }
    }
}
public event function Detach(Actor Other)
{
    local int idx;
    local Pawn P;
    local Pawn Test;
    local bool bResetPhysics;
    
    Super.Detach(Other);
    P = Pawn(Other);
    if (P != None)
    {
        bResetPhysics = TRUE;
        for (idx = 0; idx < Attached.Length; idx++)
        {
            Test = Pawn(Attached[idx]);
            if (Test != None && Test != P)
            {
                bResetPhysics = FALSE;
                break;
            }
        }
        if (bResetPhysics)
        {
            SetPhysics(10);
        }
    }
}
public function OnSetMesh(SeqAct_SetMesh Action)
{
    local bool bForce;
    
    if (Action.MeshType == EMeshType.MeshType_StaticMesh)
    {
        bForce = Action.bIsAllowedToMove == StaticMeshComponent.bForceStaticDecals || Action.bAllowDecalsToReattach;
        if (Action.NewStaticMesh != None && (Action.NewStaticMesh != StaticMeshComponent.StaticMesh || bForce))
        {
            LightEnvironment.bCastShadows = FALSE;
            LightEnvironment.SetEnabled(TRUE);
            bForceStaticDecals = !Action.bIsAllowedToMove;
            StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);
            StaticMeshComponent.bAllowDecalAutomaticReAttach = Action.bAllowDecalsToReattach;
            StaticMeshComponent.SetStaticMesh(Action.NewStaticMesh, Action.bAllowDecalsToReattach);
            StaticMeshComponent.bAllowDecalAutomaticReAttach = TRUE;
            ReplicatedMesh = Action.NewStaticMesh;
            ForceNetRelevant();
        }
    }
}
public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (StaticMeshComponent != None)
    {
        ReplicatedMesh = StaticMeshComponent.StaticMesh;
        bForceStaticDecals = StaticMeshComponent.bForceStaticDecals;
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        LightEnvironment.bCastShadows = FALSE;
        LightEnvironment.SetEnabled(TRUE);
        StaticMeshComponent.SetStaticMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedMaterial')
    {
        StaticMeshComponent.SetMaterial(0, ReplicatedMaterial);
    }
    else if (VarName == 'ReplicatedMeshTranslation')
    {
        StaticMeshComponent.SetTranslation(ReplicatedMeshTranslation);
    }
    else if (VarName == 'ReplicatedMeshRotation')
    {
        StaticMeshComponent.SetRotation(ReplicatedMeshRotation);
    }
    else if (VarName == 'ReplicatedMeshScale3D')
    {
        StaticMeshComponent.SetScale3D(ReplicatedMeshScale3D);
    }
    else if (VarName == 'bForceStaticDecals')
    {
        StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public function SetStaticMesh(StaticMesh NewMesh, optional Vector NewTranslation, optional Rotator NewRotation, optional Vector NewScale3D)
{
    StaticMeshComponent.SetStaticMesh(NewMesh);
    StaticMeshComponent.SetTranslation(NewTranslation);
    StaticMeshComponent.SetRotation(NewRotation);
    if (!IsZero(NewScale3D))
    {
        StaticMeshComponent.SetScale3D(NewScale3D);
        ReplicatedMeshScale3D = NewScale3D;
    }
    ReplicatedMesh = NewMesh;
    ReplicatedMeshTranslation = NewTranslation;
    ReplicatedMeshRotation = NewRotation;
    ForceNetRelevant();
}
public simulated function bool CanBasePawn(Pawn P)
{
    if (bPawnCanBaseOn || bSafeBaseIfAsleep && StaticMeshComponent != None && !StaticMeshComponent.RigidBodyIsAwake())
    {
        return TRUE;
    }
    return FALSE;
}
public function OnSetMaterial(SeqAct_SetMaterial Action)
{
    StaticMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    if (Action.MaterialIndex == 0)
    {
        ReplicatedMaterial = Action.NewMaterial;
        ForceNetRelevant();
    }
}
public final simulated function SetLightEnvironmentToNotBeDynamic()
{
    if (LightEnvironment != None)
    {
        LightEnvironment.bDynamic = FALSE;
    }
}

replication
{
    if (bNetDirty)
        ReplicatedMeshTranslation, ReplicatedMeshRotation, ReplicatedMeshScale3D, ReplicatedMesh, ReplicatedMaterial, bForceStaticDecals;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        BlockRigidBody = FALSE
    End Object
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    bPawnCanBaseOn = TRUE
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bShadowParented = TRUE
    bGameRelevant = TRUE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
    bPathColliding = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}