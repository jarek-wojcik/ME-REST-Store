Class SFXProjectile_PowerCustomAction_Shockwave extends SFXProjectile_PowerCustomAction
    config(Game);

var float TimeBetweenImpacts;
var float TimeToNextImpact;
var float FirstImpactDelay;
var int NumShockwaves;
var clearcrosslevel SFXPowerCustomAction_Shockwave ShockwavePower;
var WwiseEvent LastShockwaveSound;
var WwiseEvent HenchmanLastShockwaveSound;

public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
}
public simulated function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
    if (bClientPredictionTarget)
    {
        return;
    }
    if (NumShockwaves <= 0)
    {
        if (!IsShuttingDown())
        {
            if (SFXPawn_Player(Caster) != None)
            {
                PlaySound(LastShockwaveSound, TRUE);
            }
            else
            {
                PlaySound(HenchmanLastShockwaveSound, TRUE);
            }
            Explode(location, Vector(Rotation));
            ShutDown();
        }
        return;
    }
    TimeToNextImpact -= DeltaTime;
    if (TimeToNextImpact < float(0))
    {
        TimeToNextImpact = TimeBetweenImpacts;
        if (ShockwavePower != None)
        {
            ShockwavePower.DoImpact(location, Rotation);
            NumShockwaves--;
        }
    }
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
}
public simulated function bool InitializePowerProjectile(Actor oCaster, float fTravelSpeed, float fRadius, SFXPowerCustomAction oPower)
{
    local BioPlayerController PC;
    
    Super.InitializePowerProjectile(oCaster, fTravelSpeed, fRadius, oPower);
    if (!bClientPredictionTarget)
    {
        TimeToNextImpact = FirstImpactDelay;
        ShockwavePower = SFXPowerCustomAction_Shockwave(oPower);
        if (ShockwavePower != None)
        {
            TimeBetweenImpacts = ShockwavePower.TimeBetweenImpacts.CurrentValue;
            NumShockwaves = int(ShockwavePower.NumShockwaveImpacts.CurrentValue);
        }
    }
    PC = BioPlayerController(Caster.Controller);
    if (PC != None)
    {
        Init(Vector(PC.Rotation));
    }
    return TRUE;
}
public function ReplicateExplode(Vector HitLocation, Vector HitNormal);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    FirstImpactDelay = 0.100000001
    LastShockwaveSound = WwiseEvent'Wwise_Power_Biotic_Shockwave.Play_power_biotic_P_shockwave_ripple_last'
    HenchmanLastShockwaveSound = WwiseEvent'Wwise_Power_Biotic_Shockwave.Play_power_biotic_NP_shockwave_ripple_last'
    bClientPredictProjectile = TRUE
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bCollideActors = FALSE
    bCollideWorld = FALSE
}