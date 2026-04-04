Class SFXObjective_Retrieve_DropOffLocation extends SFXOperationObjective
    placeable
    config(Game);

var Vector DropZoneEmitterTranslation;
var ParticleSystem PS_DropZoneTemplate;
var SFXEmitter DropZoneEmitter;
var float DropZoneTemplateScale;
var const stringref SrDropOffObjectiveMarker;
var SFXEngagement_Retrieve RetrieveWave;

public event simulated function Destroyed()
{
    if (DropZoneEmitter != None)
    {
        DropZoneEmitter.SetLifetime(0.100000001);
        DropZoneEmitter.ParticleSystemComponent.SetActive(FALSE);
        DropZoneEmitter.Destroy();
        DropZoneEmitter = None;
    }
    Super.Destroyed();
}
public simulated function PostBeginPlay()
{
    local SFXModule_MarkerObjective ObjectiveModule;
    
    Super.PostBeginPlay();
    ObjectiveModule = GetModule(Class'SFXModule_MarkerObjective');
    ObjectiveModule.MarkerType = "RetrieveDropOff";
    ObjectiveModule.MarkerLabel = SrDropOffObjectiveMarker;
    DropZoneEmitter = Spawn(Class'SFXEmitter', Self, 'RetrieveEmitter', location + DropZoneEmitterTranslation, Rotation, , TRUE);
    if (DropZoneEmitter != None)
    {
        DropZoneEmitter.SetTemplate(PS_DropZoneTemplate);
        DropZoneEmitter.SetLifetime(0.0);
        DropZoneEmitter.ParticleSystemComponent.SetScale(DropZoneTemplateScale);
        DropZoneEmitter.ParticleSystemComponent.SetActive(TRUE);
    }
}
public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn_Player Player;
    local SFXObjective_Retrieve_PickupObject PickUpObject;
    local Actor ObjectiveActor;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        Player = SFXPawn_Player(Other);
        if (Player == None)
        {
            return;
        }
        if (RetrieveWave != None)
        {
            if (RetrieveWave.IsCarryingPickup(Player))
            {
                foreach RetrieveWave.ObjectiveActors(ObjectiveActor, )
                {
                    PickUpObject = SFXObjective_Retrieve_PickupObject(ObjectiveActor);
                    if (PickUpObject != None && PickUpObject.PickedUpBy == Player)
                    {
                        PickUpObject.ReplicatePickupObjectEvent(2, Player);
                        ObjectDroppedOff(PickUpObject);
                        Deactivate();
                        break;
                    }
                }
            }
        }
    }
}
public simulated function ObjectDroppedOff(SFXObjective_Retrieve_PickupObject PickUpObject)
{
    if (RetrieveWave != None)
    {
        RetrieveWave.PickupDroppedOff(PickUpObject.PickedUpBy, PickUpObject);
        PickUpObject.ObjectDroppedOff();
    }
}
public function ObjectPickedUp(SFXPawn_Player Player)
{
    local SFXModule_MarkerObjective ObjModule;
    
    if (Player != None)
    {
        ObjModule = GetModule(Class'SFXModule_MarkerObjective');
        if (ObjModule != None)
        {
            ObjModule.PawnWithExclusiveVisibility = Player;
        }
        ActivateObjective();
    }
}
public simulated function SetOwningWave(SFXWave_Operation NewOwner)
{
    Super.SetOwningWave(NewOwner);
    RetrieveWave = SFXEngagement_Retrieve(NewOwner);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=MeshComp0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    Begin Object Class=CylinderComponent Name=CollisionCylinder0
        CollisionHeight = 80.0
        CollisionRadius = 300.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockZeroExtent = FALSE
        CanBlockCamera = FALSE
    End Object
    Begin Object Class=SFXModule_MarkerObjective Name=ObjectiveModule0
        MarkerOffset = {X = 0.0, Y = 0.0, Z = 50.0}
    End Object
    DropZoneEmitterTranslation = {X = 0.0, Y = 0.0, Z = -100.0}
    PS_DropZoneTemplate = ParticleSystem'BioVFX_MP_Annex.Particles.Hill'
    DropZoneTemplateScale = 1.55999994
    SrDropOffObjectiveMarker = $599452
    OwnerWaveClassName = 'SFXEngagement_Retrieve'
    Mesh = MeshComp0
    LightEnvironment = MyLightEnvironment
    Components = (None, MyLightEnvironment, MeshComp0, CollisionCylinder0)
    Modules = (ObjectiveModule0)
    CollisionComponent = CollisionCylinder0
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}