Class SFXPlayerInventoryManager extends SFXInventoryManager
    config(Weapon);

var transient Rotator AccuracyLastViewRot;
var(SFXPlayerInventoryManager) config Vector2D InterpRange;
var(SFXPlayerInventoryManager) config float Base_Acc_Standing;
var(SFXPlayerInventoryManager) config float Base_Acc_Zoom;
var(SFXPlayerInventoryManager) config float AccMod_Move;
var(SFXPlayerInventoryManager) config float AccMod_ViewTurn;
var(SFXPlayerInventoryManager) config float AccMod_Crouched;
var(SFXPlayerInventoryManager) config float AccMod_MouseMultiplier;
var(SFXPlayerInventoryManager) config float AccMod_MaxCameraLoss;
var(SFXPlayerInventoryManager) config float Base_Interp_Speed;
var(SFXPlayerInventoryManager) config float InterpMod_Move;
var(SFXPlayerInventoryManager) config float InterpMul_ViewTurn;
var protectedwrite float Accuracy;
var transient float AccMod_WeaponFired;
var transient float TimeSinceLastFire;

public simulated function Tick(float DeltaTime)
{
    local BioPawn Pawn;
    
    Super(Actor).Tick(DeltaTime);
    if (Instigator != None && Instigator.IsLocallyControlled())
    {
        UpdatePlayerAccuracy(DeltaTime);
        Pawn = BioPawn(Instigator);
        if (Pawn != None && Pawn.bWeaponDebug_Accuracy)
        {
            DebugDrawWeaponAccuracy();
        }
    }
}
public simulated function DebugDrawWeaponAccuracy()
{
    local float AngleRad;
    local SFXWeapon Weapon;
    local Vector StartTrace;
    local Vector EndTrace;
    local Vector Dir;
    
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon != None)
    {
        AngleRad = Sin(Accuracy * 0.0174532924) * 0.75;
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        EndTrace = StartTrace + Vector(Instigator.GetAdjustedAimFor(Weapon, StartTrace)) * Weapon.GetTraceRange();
        Dir = Normal(EndTrace - StartTrace);
        StartTrace += Dir * float(20);
        DrawDebugCone(StartTrace, Dir, Weapon.GetTraceRange(), AngleRad, AngleRad, 16, MakeColor(255, 128, 64, 255), FALSE);
    }
}
public final simulated function float GetPlayerCrosshairValue()
{
    local SFXWeapon Weapon;
    local float CrosshairScale;
    local SFXPawn PlayerPawn;
    
    PlayerPawn = SFXPawn(Instigator);
    if (PlayerPawn != None && PlayerPawn.DrivenAtlas != None)
    {
        Weapon = SFXWeapon(PlayerPawn.DrivenAtlas.Weapon);
    }
    else if (PlayerPawn != None && PlayerPawn.DrivenVehicle != None)
    {
        Weapon = SFXWeapon(PlayerPawn.DrivenVehicle.Weapon);
    }
    else
    {
        Weapon = SFXWeapon(Instigator.Weapon);
    }
    if (Weapon == None)
    {
        return 0.0;
    }
    if (Weapon.IsZoomed())
    {
        CrosshairScale = Lerp(Weapon.MinZoomCrosshairRange.Value, Weapon.MaxZoomCrosshairRange.Value, Accuracy);
    }
    else
    {
        CrosshairScale = Lerp(Weapon.MinCrosshairRange.Value, Weapon.MaxCrosshairRange.Value, Accuracy);
    }
    if (!BioPawn(Instigator).IsInCover() && SFXWeapon_Shotgun_Base(BioPawn(Instigator).Weapon) == None && !BioPawn(Instigator).bInjuredPawn)
    {
        CrosshairScale *= 1.5;
    }
    if (Instigator.bIsCrouched)
    {
        CrosshairScale = CrosshairScale * AccMod_Crouched;
    }
    return CrosshairScale;
}
public simulated function UpdatePlayerAccuracy(float DeltaTime)
{
    local float InaccuracyPct;
    local float InterpSpeed;
    local float RotRateRatio;
    local float SpeedRatio;
    local BioPawn Pawn;
    local Rotator DeltaRot;
    local Rotator ViewRot;
    local Vector ViewLoc;
    local SFXWeapon Weapon;
    local PlayerInput Input;
    local float fAccuracyBonus;
    local float AccFireTimeMultiplier;
    
    if (DeltaTime == 0.0)
    {
        return;
    }
    InterpSpeed = Base_Interp_Speed;
    Pawn = BioPawn(Instigator);
    if (Pawn == None || PlayerController(Pawn.Controller) == None)
    {
        return;
    }
    Weapon = SFXWeapon(Pawn.Weapon);
    if (Weapon != None && Weapon.IsZoomed())
    {
        InaccuracyPct = Base_Acc_Zoom;
    }
    else
    {
        InaccuracyPct = Base_Acc_Standing;
    }
    fAccuracyBonus = 1.0;
    if (Pawn.bIsCrouched)
    {
        fAccuracyBonus = AccMod_Crouched;
    }
    if (Weapon != None)
    {
        if (bWeaponFired)
        {
            bWeaponFired = FALSE;
            AccFireTimeMultiplier = WorldInfo.GameTimeSeconds - TimeSinceLastFire;
            if (AccFireTimeMultiplier < 0.100000001)
            {
                AccFireTimeMultiplier *= Weapon.GetRateOfFire() / float(60);
            }
            else
            {
                AccFireTimeMultiplier = 1.0;
            }
            TimeSinceLastFire = WorldInfo.GameTimeSeconds;
            if (Weapon.IsZoomed())
            {
                AccMod_WeaponFired += AccFireTimeMultiplier * Weapon.ZoomAccFirePenalty.Value * 60.0 * fAccuracyBonus / Weapon.GetRateOfFire();
            }
            else
            {
                AccMod_WeaponFired += AccFireTimeMultiplier * Weapon.AccFirePenalty.Value * 60.0 * fAccuracyBonus / Weapon.GetRateOfFire();
            }
        }
        if (AccMod_WeaponFired > float(0))
        {
            if (Weapon.IsZoomed())
            {
                AccMod_WeaponFired = AccMod_WeaponFired - DeltaTime * Weapon.ZoomAccFireInterpSpeed.Value;
            }
            else
            {
                AccMod_WeaponFired = AccMod_WeaponFired - DeltaTime * Weapon.AccFireInterpSpeed.Value;
            }
        }
        if (AccMod_WeaponFired < 0.0)
        {
            AccMod_WeaponFired = 0.0;
        }
    }
    InaccuracyPct += AccMod_WeaponFired;
    SpeedRatio = VSize(Pawn.Velocity) / Pawn.CombatGroundSpeed;
    if (SpeedRatio > float(0))
    {
        Input = PlayerController(Pawn.Controller).PlayerInput;
        if (Input != None)
        {
            if (Abs(Input.RawJoyRight) > 0.00999999978 || Abs(Input.RawJoyUp) > 0.00999999978)
            {
                InaccuracyPct += SpeedRatio * AccMod_Move;
                InterpSpeed += SpeedRatio * InterpMod_Move;
            }
        }
    }
    Pawn.Controller.GetPlayerViewPoint(ViewLoc, ViewRot);
    DeltaRot = ViewRot - AccuracyLastViewRot;
    AccuracyLastViewRot = ViewRot;
    if (AccuracyLastViewRot == rot(0, 0, 0))
    {
        AccuracyLastViewRot = ViewRot;
    }
    if (DeltaRot != rot(0, 0, 0))
    {
        RotRateRatio = RSize(DeltaRot) / (DeltaTime * float(10950));
        if (!WorldInfo.IsConsoleBuild())
        {
            RotRateRatio *= AccMod_MouseMultiplier;
        }
        InaccuracyPct += FMin(AccMod_MaxCameraLoss, RotRateRatio * AccMod_ViewTurn);
        InterpSpeed += RotRateRatio * RotRateRatio * InterpMul_ViewTurn;
    }
    InterpSpeed = FClamp(InterpSpeed, InterpRange.X, InterpRange.Y);
    Accuracy = FClamp(FInterpTo(Accuracy, InaccuracyPct, DeltaTime, InterpSpeed), 0.0, 1.0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InterpRange = {X = 0.100000001, Y = 1000.0}
    AccMod_Move = 0.200000003
    AccMod_ViewTurn = 0.200000003
    AccMod_Crouched = 1.0
    AccMod_MouseMultiplier = 0.75
    AccMod_MaxCameraLoss = 0.850000024
    Base_Interp_Speed = 8.0
    InterpMod_Move = 4.0
    InterpMul_ViewTurn = 1.0
}