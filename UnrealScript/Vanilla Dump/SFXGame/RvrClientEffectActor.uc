Class RvrClientEffectActor extends Actor
    native
    placeable;

var(RvrClientEffectActor) editinline export RvrClientEffectComponent m_pCEffectComponent;
var transient RvrClientEffectPool m_pPool;
var transient bool m_bDestroyOnFinished;

public simulated native function Destroyed();

public simulated native function OnActivateClientEffect(RvrSeqAct_ActivateClientEffect pAct);

public simulated native function OnFinished(RvrClientEffectComponent pComponent);

public simulated native function OnSpawnOrLevelLoad(bool bCalledFromSpawn);

public simulated native function OnToggle(SeqAct_Toggle pAct);

public simulated native function PostBeginPlay();

public simulated native function Prime();

public simulated native function SetTemplate(RvrClientEffectInterface pTemplate);

public simulated native function StopEffect(optional bool bAllowCooldown = FALSE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=RvrClientEffectComponent Name=CEComp
    End Object
    Components = (None, CEComp)
    bNoDelete = TRUE
    bNetTemporary = TRUE
    bHardAttach = TRUE
    bGameRelevant = TRUE
    bNoEncroachCheck = TRUE
    bEdShouldSnap = TRUE
    CollisionType = ECollisionType.COLLIDE_NoCollision
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}