Class SFXSeqAct_DummyWeaponFire extends SeqAct_Latent
    native;

struct native DummyFireObjectListParams 
{
    var(DummyFireObjectListParams) const Vector2D SecondsPerObject;
    var(DummyFireObjectListParams) const Vector2D ObjectChangeDelay;
    var float TimeUntilObjectChange;
    var float DelayTimeRemaining;
    var int CurrentObjIdx;
    var bool bDelay;
    var(DummyFireObjectListParams) const DummyFireObjectCyclingMethod CyclingMethod;
    
    structdefaultproperties
    {
        SecondsPerObject = {X = 1.0, Y = 2.0}
        ObjectChangeDelay = {X = 0.5, Y = 1.5}
    }
};
enum DummyFireObjectCyclingMethod
{
    DFOCM_Sequential,
    DFOCM_Random,
};

var(SFXSeqAct_DummyWeaponFire) Class<SFXWeapon> WeaponClass;
var(SFXSeqAct_DummyWeaponFire) DummyFireObjectListParams MultipleTargetParams;
var(SFXSeqAct_DummyWeaponFire) DummyFireObjectListParams MultipleOriginParams;
var(SFXSeqAct_DummyWeaponFire) Name OriginSocketName;
var(SFXSeqAct_DummyWeaponFire) int ShotsToFire;
var(SFXSeqAct_DummyWeaponFire) float InaccuracyDegrees;
var SFXWeapon_NativeBase SpawnedWeapon;
var float RemainingFireTime;
var int ShotsFired;
var SFXDummyWeaponFireActor ReplicatedActor;
var(SFXSeqAct_DummyWeaponFire) bool bShootUntilStopped;
var bool bStopped;
var bool bFinished;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressMuzzleFlash;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressTracers;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressImpactFX;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressAudio;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressDamage;
var(SFXSeqAct_DummyWeaponFire) bool bDamagesFriends;
var(SFXSeqAct_DummyWeaponFire) bool bFiring;
var(SFXSeqAct_DummyWeaponFire) bool bAlignWeaponMeshToSocket;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressCameraShake;
var(SFXSeqAct_DummyWeaponFire) bool bSuppressLineCheck;
var(SFXSeqAct_DummyWeaponFire) byte FiringMode;
var(SFXSeqAct_DummyWeaponFire) byte TeamIndex;

public final native function AlignWeaponMuzzleToActor(Actor AlignTo, Actor AimAt, optional bool bForceComponentUpdate);

public event function Name GetMuzzleSocketName()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(SpawnedWeapon);
    if (Weapon != None)
    {
        return Weapon.MuzzleSocketName;
    }
    return 'None';
}
public event function SetRemainingTime(byte DummyFiringMode)
{
    if (SpawnedWeapon != None)
    {
        RemainingFireTime = SpawnedWeapon.GetFireInterval(DummyFiringMode);
    }
}
public event function SetupSpawnedDummyWeapon(Actor OriginActor, Actor TargetActor)
{
    local SFXWeapon Weapon;
    local SkeletalMeshComponent SkelMesh;
    
    Weapon = SFXWeapon(SpawnedWeapon);
    if (Weapon != None)
    {
        Weapon.Expand();
        if (Weapon.Mesh != None)
        {
            Weapon.AttachComponent(Weapon.Mesh);
            Weapon.SetWeaponHidden(TRUE);
        }
        else if (OriginActor != None)
        {
            SkelMesh = SkeletalMeshComponent(OriginActor.CollisionComponent);
            if (SkelMesh == None)
            {
                SkelMesh = Class'SFXModule_Gestures'.static.ScriptGetMainMeshComp(OriginActor);
            }
            if (SkelMesh != None)
            {
                Weapon.AttachMuzzleEffectsComponents(SkelMesh, OriginSocketName, OriginSocketName);
            }
        }
        Weapon.InitializeWeapon();
        Weapon.AttachMuzzleEffectsComponents(SkeletalMeshComponent(Weapon.Mesh), Weapon.MuzzleSocketName, Weapon.ShellCasingSocketName);
        AlignWeaponMuzzleToActor(OriginActor, TargetActor, TRUE);
        Weapon.bSuppressMuzzleFlash = bSuppressMuzzleFlash;
        Weapon.bSuppressTracers = bSuppressTracers;
        Weapon.bSuppressImpactFX = bSuppressImpactFX;
        Weapon.bSuppressAudio = bSuppressAudio;
        Weapon.bSuppressDamage = bSuppressDamage;
        Weapon.bDamagesFriends = bDamagesFriends;
        Weapon.DummyTeamIndex = TeamIndex;
        Weapon.bSuppressCameraShake = bSuppressCameraShake;
        Weapon.bSuppressDummyFireLineCheck = bSuppressLineCheck;
        Weapon.BeginDummyFire(FiringMode, OriginActor);
        RemainingFireTime = Weapon.GetInitialDummyFireDelay();
        ShotsFired = 0;
    }
}
public final native function SpawnDummyWeapon(Actor OriginActor, Actor TargetActor);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MultipleTargetParams = {
                            SecondsPerObject = {X = 1.0, Y = 2.0}, 
                            ObjectChangeDelay = {X = 0.5, Y = 1.5}, 
                            TimeUntilObjectChange = 0.0, 
                            DelayTimeRemaining = 0.0, 
                            CurrentObjIdx = 0, 
                            bDelay = FALSE, 
                            CyclingMethod = DummyFireObjectCyclingMethod.DFOCM_Sequential
                           }
    MultipleOriginParams = {
                            SecondsPerObject = {X = 1.0, Y = 2.0}, 
                            ObjectChangeDelay = {X = 0.5, Y = 1.5}, 
                            TimeUntilObjectChange = 0.0, 
                            DelayTimeRemaining = 0.0, 
                            CurrentObjIdx = 0, 
                            bDelay = FALSE, 
                            CyclingMethod = DummyFireObjectCyclingMethod.DFOCM_Sequential
                           }
    ShotsToFire = 1
    bDamagesFriends = TRUE
    TeamIndex = 1
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Start Firing", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop Firing", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stopped", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Origin", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Origin', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Target', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}