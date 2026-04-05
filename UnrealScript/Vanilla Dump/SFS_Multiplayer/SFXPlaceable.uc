Class SFXPlaceable extends SFXPlaceableBase
    placeable
    abstract;

var repnotify bool bReplicatedIsDestroyed;
var repnotify bool bReplicatedIsDeactivated;

public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'bReplicatedIsDestroyed':
            if (bReplicatedIsDestroyed)
            {
                PlaceableDestroyed();
            }
            else
            {
                ResetPlaceable();
            }
            break;
        case 'bReplicatedIsDeactivated':
            if (bReplicatedIsDeactivated)
            {
                DeactivatePlaceable();
            }
            else
            {
                ActivatePlaceable();
            }
            break;
        default:
            Super(DynamicSMActor).ReplicatedEvent(VarName);
            break;
    }
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    if (Damage > float(0) && Caster != None)
    {
        TakeDamage(Damage, Caster.Controller, HitLocation, vect(0.0, 0.0, 0.0), DamageType, , Caster);
    }
    return FALSE;
}
public simulated function ActivatePlaceable()
{
    Super.ActivatePlaceable();
    bReplicatedIsDeactivated = FALSE;
    TriggerEventClass(Class'SFXSeqEvt_PlaceableActivated', Self);
}
public simulated function DeactivatePlaceable()
{
    Super.DeactivatePlaceable();
    bReplicatedIsDeactivated = TRUE;
    TriggerEventClass(Class'SFXSeqEvt_PlaceableDeactivated', Self);
}
public simulated function PlaceableDestroyed()
{
    Super.PlaceableDestroyed();
    TriggerEventClass(Class'SFXSeqEvt_PlaceableDestroyed', Self);
    bReplicatedIsDestroyed = TRUE;
}
public simulated function ResetPlaceable()
{
    Super.ResetPlaceable();
    TriggerEventClass(Class'SFXSeqEvt_PlaceableReset', Self);
    bReplicatedIsDestroyed = FALSE;
    bReplicatedIsDeactivated = FALSE;
}
public function bool AllowPlaceableDamageEvents(Controller EventInstigator)
{
    if (EventInstigator != None && EventInstigator.Pawn != None && int(EventInstigator.Pawn.GetTeamNum()) == 1)
    {
        return FALSE;
    }
    if (bIsDestroyed)
    {
        return FALSE;
    }
    return TRUE;
}
public function AreaDamage(float Damage, float Force, Class<SFXDamageType> DamageType, float ImpactRadius)
{
    local Actor NearbyActor;
    local Vector HitNormal;
    local Actor TargetOverride;
    local EPowerResistance Resistance;
    local Vector vForce;
    
    foreach CollidingActors(Class'Actor', NearbyActor, ImpactRadius, , , , )
    {
        HitNormal = Normal(location - NearbyActor.location);
        vForce = -HitNormal * Force;
        Resistance = NearbyActor.GetPowerResistance(None, location, HitNormal, Damage, vForce, DamageType, TargetOverride);
        if (TargetOverride != None)
        {
            NearbyActor = TargetOverride;
        }
        NearbyActor.ImpactWithPower(Resistance, None, location, HitNormal, Damage, vForce, DamageType);
        AreaDamageForActor(NearbyActor);
    }
}
public function AreaDamageForActor(Actor HitActor);


replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        bReplicatedIsDestroyed, bReplicatedIsDeactivated;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        WireframeColor = {B = 0, G = 128, R = 255, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        bUsePrecomputedShadows = TRUE
        BlockRigidBody = TRUE
        RBCollideWithChannels = {GameplayPhysics = TRUE, EffectPhysics = TRUE}
    End Template
    Begin Object Class=SFXModule_Damage Name=DamageModule0
        MaxHealth = {X = 200.0, Y = 200.0}
    End Object
    Begin Object Class=SFXModule_AimAssistTarget Name=SelectionModule0
        m_fMaxSelectionRangeSqr = 16000000.0
    End Object
    Begin Object Class=SFXModule_GameEffectManager Name=GEMod0
    End Object
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    Modules = (DamageModule0, SelectionModule0, GEMod0)
    CollisionComponent = StaticMeshComponent0
    bCanStepUpOn = FALSE
    bMovable = FALSE
    bCanBeDamaged = TRUE
}