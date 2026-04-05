Class SFXGameModeDying extends SFXGameModeBase within BioPlayerController
    config(Input);

var config float ProlongLifeBoost;
var config float ProlongLifeDecay;
var config float StartBoostTime;
var(SFXGameModeDying) export BioCameraBehaviorFlourish DeathCam;

public function Activated()
{
    Super.Activated();
    ClearHints();
    Outer.HintSystem.HintEvent('Dying');
    ProlongLifeBoost = default.ProlongLifeBoost;
}
public function Deactivated()
{
    Outer.HintSystem.HintEvent('EndDying');
    ClearHints();
    Super.Deactivated();
}
public function ClearHints()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oGUI.CancelHint(Outer);
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.0;
    PreserveTarget = 0;
    if (Outer.Pawn != None && Outer.Pawn.IsDead())
    {
        return DeathCam;
    }
    return OldCameraMode;
}
public static function float GetTotalPossibleBoost()
{
    local float MaxBoosts;
    
    MaxBoosts = default.ProlongLifeBoost / default.ProlongLifeDecay;
    return (1.0 + MaxBoosts) * (MaxBoosts / 2.0) * default.ProlongLifeDecay;
}
public final exec function bool ProlongLife()
{
    if (WasInstaKilled() == FALSE && Outer.Pawn.IsTimerActive('PermaDeath'))
    {
        if (Outer.Pawn.GetRemainingTimeForTimer('PermaDeath') + ProlongLifeBoost < StartBoostTime)
        {
            Outer.Pawn.SetTimer(Outer.Pawn.GetRemainingTimeForTimer('PermaDeath') + ProlongLifeBoost, FALSE, 'PermaDeath', );
            ProlongLifeBoost -= ProlongLifeDecay;
        }
        Outer.HintSystem.HintEvent('ProlongLife');
    }
    return TRUE;
}
public final function bool ShouldShowTappingPrompt(float TimeLeft)
{
    if (WasInstaKilled() == FALSE)
    {
        return TimeLeft < StartBoostTime;
    }
    return FALSE;
}
public exec function UseRevivePower()
{
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(Outer.Pawn);
    if (PlayerPawn != None && WasInstaKilled() == FALSE && PlayerPawn.IsTimerActive('PermaDeath'))
    {
        PlayerPawn.UseReviveConsumablePower();
    }
}
private final function bool WasInstaKilled()
{
    local Class<SFXDamageType> DamageType;
    
    if (BioPawn(Outer.Pawn) != None)
    {
        DamageType = Class<SFXDamageType>(BioPawn(Outer.Pawn).KilledByDamageType);
        if (DamageType != None && DamageType.default.bMPKillDamage)
        {
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorFlourish Name=DeathCam0
        CameraName = 'DeathCam'
    End Object
    ProlongLifeBoost = 0.25
    ProlongLifeDecay = 0.00300000003
    StartBoostTime = 12.0
    DeathCam = DeathCam0
    Bindings = ({
                 Command = "PC_LookX", 
                 Name = 'MouseX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_LookY", 
                 Name = 'MouseY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Menu", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ProlongLife", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseRevivePower", 
                 Name = 'Seven', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_PushToTalk", 
                 Name = 'Tab', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bAllowRotationUpdate = TRUE
    bAllowMovement = TRUE
    bAllowCamera = TRUE
    bAllowPauseMenu = TRUE
    bAllowHints = TRUE
    bShowSubtitle = TRUE
    bHasMouseAuthority = TRUE
    bShowReticles = TRUE
    bPlayVocalizations = TRUE
    bAllowMessageUI = TRUE
    bAllowPowerWeaponUI = TRUE
}