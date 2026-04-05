Class SFXSFHandler_HUD extends SFXGUIMovieLegacyAdapter
    native
    transient
    config(UI);

struct native SFXMPTargetUIState 
{
    var const native array<Pointer> aBarPips;
    var GFxValue oResistBar;
    var int nNumVisible;
};
struct native SFXHUDMiniNotification extends SFXHUDNotification 
{
    var string sText;
    var Name nmIcon;
    var float fAnimTime;
};
struct native SFXHUDNotification 
{
    var GFxValue oMovieClip;
    var int nID;
    var float fTimeToLive;
    var bool bVisible;
};
struct native SFXHUDTargetInfo 
{
    var string sName;
    var string sStatus;
    var SFXHUDResistances Resistances;
    var int nStatusFlags;
    var bool bInteractive;
    var bool bHostile;
    var bool bInRange;
};
struct native SFXHUDSquadMemberInfo 
{
    var string sPath;
    var string sIconImagePath;
    var string sShieldPath;
    var string sBioticPath;
    var string sArmourPath;
    var string sHealthPath;
    var string sPowerPath;
    var SFXHUDResistances Resistances;
    var SFXHUDResistances DisplayedResistances;
    var BioPawn pPawn;
    var Texture2D pIcon;
    var float fCooldown;
    var float fElapsedFullResistTime;
    var SFXGUIValue_HUDPowerIcon pPowerIcon;
    var bool bCooldownVisible;
    var bool bShieldVisible;
    var bool bBioticVisible;
    var bool bArmourVisible;
    var bool bHealthVisible;
    var bool bShieldDamage;
    var bool bBioticDamage;
    var bool bArmourDamage;
    var bool bHealthDamage;
    var bool bInvalidated;
    var bool bVisible;
    var bool bUpdateResistance;
    var bool bUpdateHealth;
    var bool bUpdatePower;
    var bool bUpdateIcon;
    var bool bDisplayVisible;
    var ESFXPortraitState ePortraitState;
};
struct native SFXHUDResistances 
{
    var float fHealthPct;
    var float fArmourPct;
    var float fBioticPct;
    var float fShieldPct;
    var bool bHasShield;
    var bool bHasArmour;
    var bool bHasBiotic;
    var bool bHasHealth;
};
struct native SFXHudDmgIndicatorPaths 
{
    var string _alpha;
    var string _visible;
};
const SF_9SLICE_SCALE_ERROR = 0.05336;
enum ESFXPortraitState
{
    PORTRAIT_STATE_NORMAL,
    PORTRAIT_STATE_DEAD,
    PORTRAIT_STATE_BUSY,
};
const NumMPTargetResistPips = 10;
const NumMPTargetResistBars = 4;
const STATUS_SuperRegen = 64;
const STATUS_ActivePower = 32;
const STATUS_MinimalDamage = 16;
const STATUS_HeavyArmour = 8;
const STATUS_HardenedShields = 4;
const STATUS_Bleedout = 2;
const STATUS_Barrier = 1;

var SFXHUDSquadMemberInfo m_oShepardInfo;
var SFXHUDSquadMemberInfo m_oHench1Info;
var SFXHUDSquadMemberInfo m_oHench2Info;
var SFXMPTargetUIState MPTargetUIState[4];
var string m_sStatusText;
var string m_sResistanceText;
var array<SFXHudDmgIndicatorPaths> m_aDamageIndicatorPaths;
var array<float> m_aDamageIndicatorAlphas;
var string m_nCurrentWeaponResource;
var array<ESFXHUDPOIIconState> m_lstQueuedPOIStates;
var array<SFXHUDMiniNotification> MiniNotifications;
var string m_sShields;
var string m_sArmour;
var string m_sBarrier;
var string m_sHealth;
var string m_sOverheat;
var string m_sNoAmmo;
var delegate<OnNotificationCompleted> __OnNotificationCompleted__Delegate;
var SFXHUDResistances m_CurrentResistances;
var SFXHUDResistances m_ResistanceBarDisplayValues;
var SFXHUDNotification Notification;
var transient float LastAmmoPulseTime;
var Actor m_pCurrentTarget;
var int m_nCurrentBarCount;
var float m_fCurrentBarBackgroundX;
var int m_nNumMiniNotifications;
var BioPlayerController m_pPlayerController;
var BioBaseSquad m_pPlayerSquad;
var float m_fEffectivelyZero;
var int m_nCurrentWeaponIcon;
var int m_nCurrentWeaponSpareAmmo;
var int m_nCurrentClipAmmo;
var float m_fTimeSinceLastWeaponUpdate;
var Actor m_pCurrentDisplayTarget;
var float m_fCurrentOverheatValue;
var float m_fMiniClipHeight;
var float m_fMiniClipBaselineY;
var int m_nCurrentGrenadeCount;
var config float m_fSuperRegenThreshold;
var config float m_fHealthShieldUpdateDelta;
var config float m_fDamageIndicatorAlphaUpdateDelta;
var config float m_fLowHealthWarning;
var config float m_fWeaponUpdateInterval;
var config float m_fBarAnimRate;
var config float m_fFullStatFadeTime;
var config float m_fMiniNotificationAnimTime;
var config float m_fMiniNotificationPadding;
var GFxValue WeaponIcon;
var GFxValue WeaponAmmo;
var GFxValue WeaponClip;
var GFxValue GrenadeAmmo;
var GFxValue TargetName;
var GFxValue TargetStatus;
var GFxValue ButtonA;
var GFxValue TargetBackground;
var GFxValue HealthBar;
var GFxValue ArmourBar;
var GFxValue BioticBar;
var GFxValue ShieldBar;
var GFxValue ResistanceText;
var GFxValue ResistanceBar;
var GFxValue CenterStatus;
var GFxValue CenterStatusText;
var GFxValue OverheatIndicator;
var GFxValue OverheatIndicatorTextAnim;
var GFxValue OverheatIndicatorTextAnimText;
var GFxValue PlayerPowerLeft;
var GFxValue PlayerPowerRight;
var GFxValue AmmoFull;
var GFxValue ActionIcon;
var GFxValue POI;
var GFxValue MPTargetBarMain;
var GFxValue MPTargetHitDisplay;
var config stringref m_srStatusBarrierText;
var config stringref m_srStatusBleedoutText;
var config stringref m_srStatusHardenedShieldsText;
var config stringref m_srStatusHeavyArmourText;
var config stringref m_srStatusMinimalDamageText;
var config stringref m_srStatusSuperRegenText;
var config stringref m_srShields;
var config stringref m_srArmour;
var config stringref m_srBarrier;
var config stringref m_srHealth;
var config stringref m_srOverheat;
var config stringref m_srNoAmmo;
var config stringref m_srAmmoFull;
var config stringref m_srCoverEnterAction;
var config stringref m_srCoverClimbAction;
var config stringref m_srCoverMantleAction;
var config stringref m_srCover90RightAction;
var config stringref m_srCover90LeftAction;
var config stringref m_srCoverSlipRightAction;
var config stringref m_srCoverSlipLeftAction;
var config stringref m_srCoverSwatRightAction;
var config stringref m_srCoverSwatLeftAction;
var config stringref m_srCoverGrabAction;
var config stringref m_srLadderUpAction;
var config stringref m_srLadderDownAction;
var config stringref m_srGapJumpAction;
var config stringref m_srAtlasSuitAction;
var config int m_nNotificationBodyLength;
var bool m_bInteractive;
var bool m_bInRange;
var bool m_bTargetStatusVisible;
var bool m_bProcessSquadHenchmen;
var bool m_bInSquadCommandMode;
var bool m_bInitializedPlayerResistance;
var bool m_bWeaponVisible;
var bool m_bWeaponOverheatBarVisible;
var bool m_bHealthDisplayVisible;
var bool m_bForceUpdateDisplayNextTick;
var transient bool m_bHadNoAmmo;
var bool m_bGrenadesVisible;
var bool m_bDisplayWeaponOverride;
var config bool m_bHideShieldBarWhenFull;
var config bool m_bDisablePlayerHealth;
var config bool m_bUseMPHealthDisplay;
var ESFXHUDActionIcon m_eCurrentActionIcon;
var ESFXHUDPOIIconState m_eCurrentPOIState;

public final event function AS_SetNotificationImage(string sResourcePath)
{
    ActionScriptVoid("SetNotificationImage");
}
public final native function CleanupNativeReferences();

public final native function ClearMiniNotification(int nIndex);

public final native function ClearNotification();

public function GameSessionEnded()
{
    CleanupReferences();
    Super.GameSessionEnded();
}
public static final event function GetResistances(Actor pTarget, out SFXHUDResistances oResistances)
{
    local BioPawn pBioPawnTarget;
    local SFXShield_Base pShield;
    local SFXModule_Damage pDamageMod;
    local float FMax;
    local float fCurrent;
    local float fShieldMax;
    local float fBioticMax;
    local float fArmourMax;
    local float fShieldCurrent;
    local float fBioticCurrent;
    local float fArmourCurrent;
    
    pBioPawnTarget = BioPawn(pTarget);
    oResistances.fShieldPct = 0.0;
    oResistances.fBioticPct = 0.0;
    oResistances.fArmourPct = 0.0;
    oResistances.fHealthPct = 0.0;
    oResistances.bHasShield = FALSE;
    oResistances.bHasBiotic = FALSE;
    oResistances.bHasArmour = FALSE;
    oResistances.bHasHealth = FALSE;
    if (pTarget == None)
    {
        return;
    }
    if (pBioPawnTarget != None && pBioPawnTarget.InvManager != None)
    {
        foreach pBioPawnTarget.InvManager.InventoryActors(Class'SFXShield_Base', pShield)
        {
            switch (pShield.Resistance)
            {
                case EResistanceType.ResistanceType_Shield:
                    fShieldMax += pShield.GetMaxShields();
                    fShieldCurrent += FMin(pShield.GetCurrentShields(), pShield.GetMaxShields());
                    oResistances.bHasShield = TRUE;
                    break;
                case EResistanceType.ResistanceType_Biotic:
                    fBioticMax += pShield.GetMaxShields();
                    fBioticCurrent += FMin(pShield.GetCurrentShields(), pShield.GetMaxShields());
                    oResistances.bHasBiotic = TRUE;
                    break;
                case EResistanceType.ResistanceType_Armour:
                    fArmourMax += pShield.GetMaxShields();
                    fArmourCurrent += FMin(pShield.GetCurrentShields(), pShield.GetMaxShields());
                    oResistances.bHasArmour = TRUE;
                    break;
                default:
            }
        }
    }
    oResistances.fShieldPct = fShieldMax > 0.0 ? fShieldCurrent / fShieldMax : 0.0;
    oResistances.fBioticPct = fBioticMax > 0.0 ? fBioticCurrent / fBioticMax : 0.0;
    oResistances.fArmourPct = fArmourMax > 0.0 ? fArmourCurrent / fArmourMax : 0.0;
    pDamageMod = pTarget.GetModule(Class'SFXModule_Damage');
    if (pDamageMod != None)
    {
        FMax = pDamageMod.GetMaxHealth();
        fCurrent = FMin(pDamageMod.GetCurrentHealth(), FMax);
        switch (pDamageMod.HealthType)
        {
            case EHealthType.HealthType_Default:
                oResistances.fHealthPct = fCurrent / FMax;
                oResistances.bHasHealth = TRUE;
                break;
            case EHealthType.HealthType_Shields:
                oResistances.fShieldPct = fCurrent / FMax;
                oResistances.bHasShield = TRUE;
                break;
            case EHealthType.HealthType_Barrier:
                oResistances.fBioticPct = fCurrent / FMax;
                oResistances.bHasBiotic = TRUE;
                break;
            case EHealthType.HealthType_Armour:
                oResistances.fArmourPct = fCurrent / FMax;
                oResistances.bHasArmour = TRUE;
                break;
            default:
        }
    }
    oResistances.fHealthPct = FClamp(oResistances.fHealthPct, 0.0, 1.0);
    oResistances.fArmourPct = FClamp(oResistances.fArmourPct, 0.0, 1.0);
    oResistances.fBioticPct = FClamp(oResistances.fBioticPct, 0.0, 1.0);
    oResistances.fShieldPct = FClamp(oResistances.fShieldPct, 0.0, 1.0);
}
public static final event function string GetStatusText(BioPawn pTarget, int nStatusFlags)
{
    local string sStatus;
    
    if ((nStatusFlags & 4) != 0)
    {
        sStatus = UIStrRef(default.m_srStatusHardenedShieldsText);
    }
    else if ((nStatusFlags & 8) != 0)
    {
        sStatus = UIStrRef(default.m_srStatusHeavyArmourText);
    }
    else if ((nStatusFlags & 64) != 0)
    {
        sStatus = UIStrRef(default.m_srStatusSuperRegenText);
    }
    else if ((nStatusFlags & 16) != 0)
    {
        sStatus = UIStrRef(default.m_srStatusMinimalDamageText);
    }
    else if ((nStatusFlags & 2) != 0)
    {
        sStatus = UIStrRef(default.m_srStatusBleedoutText);
    }
    return sStatus;
}
public static final event function int GetTargetStatusFlags(Actor pTarget)
{
    local BioPawn pBioPawnTarget;
    
    pBioPawnTarget = BioPawn(pTarget);
    if (pBioPawnTarget != None)
    {
        if (pBioPawnTarget.InvManager != None)
        {
        }
    }
    return 0;
}
public final event function InitDisplay()
{
    local int N;
    local float fX;
    
    WeaponIcon = GetVariableObject("Weapon");
    WeaponAmmo = GetVariableObject("SpareAmmo");
    WeaponClip = GetVariableObject("MagazineAmmo");
    GrenadeAmmo = GetVariableObject("WeaponGrenades");
    TargetName = GetVariableObject("TargetName");
    TargetStatus = GetVariableObject("TargetStatus");
    ButtonA = GetVariableObject("ButtonA");
    TargetBackground = GetVariableObject("TargetBackground");
    if (!m_bUseMPHealthDisplay && IsMPGame() == FALSE)
    {
        HealthBar = GetVariableObject("targetHealth");
        ArmourBar = GetVariableObject("targetArmour");
        BioticBar = GetVariableObject("targetBarrier");
        ShieldBar = GetVariableObject("targetShield");
    }
    else
    {
        MPTargetBarMain = GetVariableObject("MPTargetPips");
        HealthBar = MPTargetBarMain.GetObject("healthBar");
        ArmourBar = MPTargetBarMain.GetObject("armourBar");
        BioticBar = MPTargetBarMain.GetObject("barrierbar");
        ShieldBar = MPTargetBarMain.GetObject("shieldBar");
    }
    ResistanceText = GetVariableObject("resistanceBar.resistanceText");
    Notification.oMovieClip = GetVariableObject("mcNotification");
    MiniNotifications.Length = m_nNumMiniNotifications;
    for (N = 0; N < m_nNumMiniNotifications; ++N)
    {
        MiniNotifications[N].oMovieClip = GetVariableObject("miniNotification" $ N + 1);
        if (MiniNotifications[N].oMovieClip != None)
        {
            MiniNotifications[N].oMovieClip.GotoAndStop("on");
        }
    }
    if (MiniNotifications[0].oMovieClip != None)
    {
        m_fMiniClipHeight = MiniNotifications[0].oMovieClip.GetNumber("_height");
        MiniNotifications[0].oMovieClip.GetPosition(fX, m_fMiniClipBaselineY);
    }
    CenterStatus = GetVariableObject("CenterStatus");
    CenterStatusText = CenterStatus.GetObject("CenterStatusText");
    OverheatIndicator = GetVariableObject("WeaponOverheat");
    OverheatIndicatorTextAnim = OverheatIndicator.GetObject("TextAnim");
    OverheatIndicatorTextAnimText = OverheatIndicatorTextAnim.GetObject("text");
    PlayerPowerLeft = GetVariableObject("PlayerPower1");
    PlayerPowerRight = GetVariableObject("PlayerPower2");
    AmmoFull = GetVariableObject("AmmoFull");
    ActionIcon = GetVariableObject("ActionIcon");
    POI = GetVariableObject("POI");
    Class'SFXSFHandler_PowerWheel'.static.HideWeaponIcon(oPanel, WeaponIcon);
    m_sShields = GetUIString(m_srShields);
    m_sArmour = GetUIString(m_srArmour);
    m_sBarrier = GetUIString(m_srBarrier);
    m_sHealth = GetUIString(m_srHealth);
    m_sOverheat = GetUIString(m_srOverheat);
    m_sNoAmmo = GetUIString(m_srNoAmmo);
    SetOverheat(0.0, "", TRUE);
    UpdateWeaponDisplay(FALSE, None);
    SetupHenchPowers();
}
public event function OnAspectRatioChanged(float fNewAspectRatio);

public final event function OnMiniNotificationComplete(int nID)
{
    if (__OnNotificationCompleted__Delegate != None)
    {
        __OnNotificationCompleted__Delegate(nID);
    }
}
public delegate function OnNotificationCompleted(int nID);

public event function OnPanelRemoved()
{
    CleanupReferences();
    Super.OnPanelRemoved();
}
public final event function PlayNuiSpeech_CombatFeedback(bool Successful, string TargetPawn, stringref Rule)
{
    AS_PlayNuiSpeech_GenericFeedback(Successful, GetNuiPawnCommandString(TargetPawn, GetUIString(Rule)));
}
public final event function PlayNuiSpeech_ExploreFeedback(bool Successful)
{
    if (m_bInRange)
    {
        AS_PlayNuiSpeech_ExploreFeedback(Successful);
    }
}
public final event function PlayNuiSpeech_GenericFeedback(bool Successful, stringref Rule)
{
    AS_PlayNuiSpeech_GenericFeedback(Successful, GetUIString(Rule));
}
public final event function RegisterToPowerManager(BioPawn pPawn)
{
    if (pPawn == None || pPawn.PowerManager == None)
    {
        return;
    }
    pPawn.PowerManager.RegisterPowerReleasedCallback(OnPawnPowerUsed);
}
public final function RemoveHenchman(BioPawn pPawn)
{
    if (m_oHench1Info.pPawn == pPawn)
    {
        m_oHench1Info.pPowerIcon.SetPower(None);
    }
    if (m_oHench2Info.pPawn == pPawn)
    {
        m_oHench2Info.pPowerIcon.SetPower(None);
    }
}
public final event function SetTargetNuiSpeechEnabled(bool bEnabled)
{
    AS_SetTargetNuiSpeechEnabled(bEnabled);
}
public final event function SetupHenchPowers()
{
    if (m_oHench1Info.pPowerIcon == None)
    {
        m_oHench1Info.pPowerIcon = SFXGUIValue_HUDPowerIcon(GetVariableObject(m_oHench1Info.sPowerPath, Class'SFXGUIValue_HUDPowerIcon'));
    }
    if (m_oHench2Info.pPowerIcon == None)
    {
        m_oHench2Info.pPowerIcon = SFXGUIValue_HUDPowerIcon(GetVariableObject(m_oHench2Info.sPowerPath, Class'SFXGUIValue_HUDPowerIcon'));
    }
    if (m_oHench1Info.pPowerIcon != None)
    {
        m_oHench1Info.pPowerIcon.sPath = m_oHench1Info.sPowerPath;
        m_oHench1Info.pPowerIcon.SetToDefaultHenchIcon(m_oHench1Info.pPawn);
    }
    if (m_oHench2Info.pPowerIcon != None)
    {
        m_oHench2Info.pPowerIcon.sPath = m_oHench2Info.sPowerPath;
        m_oHench2Info.pPowerIcon.SetToDefaultHenchIcon(m_oHench2Info.pPawn);
    }
}
public final event function bool ShouldDisplayWeaponIcon()
{
    local bool bDisplayWeaponIcon;
    
    if (m_pPlayerController.Pawn == None)
    {
        return FALSE;
    }
    bDisplayWeaponIcon = TRUE;
    if (SFXHeavyWeapon(m_pPlayerController.Pawn.Weapon) != None)
    {
        bDisplayWeaponIcon = FALSE;
    }
    bDisplayWeaponIcon = bDisplayWeaponIcon && m_bInSquadCommandMode == FALSE;
    return bDisplayWeaponIcon;
}
public final native function ShowMiniNotification(const out SFXNotification oNotifyParams);

public final native function ShowNotification(const out SFXNotification oNotifyParams, int nNumRemainingNotifications);

public final event function TargetChanged(Actor pOldTarget, Actor pNewTarget)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(pOldTarget);
    if (oPawn != None && oPawn.__DamageCallback__Delegate == PlayTargetHitIndication)
    {
        oPawn.__DamageCallback__Delegate = None;
    }
    oPawn = BioPawn(pNewTarget);
    if (oPawn != None)
    {
        oPawn.__DamageCallback__Delegate = PlayTargetHitIndication;
    }
}
public final event function UnregisterFromPowerManager(BioPawn pPawn)
{
    if (pPawn == None || pPawn.PowerManager == None)
    {
        return;
    }
    pPawn.PowerManager.UnregisterPowerReleasedCallback(OnPawnPowerUsed);
}
public final native function UpdateMPResistanceBarDisplay(float fPips, GFxValue oBarClip);

public final event function UpdatePOIState()
{
    local ESFXHUDPOIIconState eState;
    
    eState = m_lstQueuedPOIStates[0];
    m_lstQueuedPOIStates.Remove(0, 1);
    if (int(m_eCurrentPOIState) == int(eState))
    {
        if (eState == ESFXHUDPOIIconState.SFXHUD_POI_Off)
        {
            POI.SetVisible(FALSE);
        }
        return;
    }
    switch (eState)
    {
        case ESFXHUDPOIIconState.SFXHUD_POI_On:
            if (m_eCurrentPOIState == ESFXHUDPOIIconState.SFXHUD_POI_Off)
            {
                POI.SetVisible(TRUE);
                POI.GotoAndPlay("on");
            }
            else if (m_eCurrentPOIState == ESFXHUDPOIIconState.SFXHUD_POI_Activated)
            {
                POI.GotoAndStop("enabled");
            }
            SetPOIHintDisplay();
            break;
        case ESFXHUDPOIIconState.SFXHUD_POI_Activated:
            if (m_eCurrentPOIState == ESFXHUDPOIIconState.SFXHUD_POI_Off)
            {
                POI.SetVisible(TRUE);
            }
            POI.GotoAndStop("active");
            break;
        case ESFXHUDPOIIconState.SFXHUD_POI_Off:
            POI.GotoAndPlay("off");
            break;
        default:
    }
    m_eCurrentPOIState = eState;
}
public final event function UpdateResistanceDisplay(SFXHUDResistances oResistValues)
{
    local bool bBarsVisible;
    local string NewResistanceText;
    
    if (oResistValues.fHealthPct > m_fEffectivelyZero || oResistValues.fArmourPct > m_fEffectivelyZero || oResistValues.fBioticPct > m_fEffectivelyZero || oResistValues.fShieldPct > m_fEffectivelyZero)
    {
        bBarsVisible = TRUE;
    }
    if (bBarsVisible)
    {
        UpdateResistanceBarDisplay(oResistValues.fHealthPct, HealthBar);
        UpdateResistanceBarDisplay(oResistValues.fArmourPct, ArmourBar);
        UpdateResistanceBarDisplay(oResistValues.fBioticPct, BioticBar);
        UpdateResistanceBarDisplay(oResistValues.fShieldPct, ShieldBar);
        m_ResistanceBarDisplayValues = oResistValues;
        if (MPTargetBarMain != None)
        {
            MPTargetBarMain.SetVisible(TRUE);
        }
        if (oResistValues.fShieldPct > m_fEffectivelyZero)
        {
            NewResistanceText = m_sShields;
        }
        else if (oResistValues.fBioticPct > m_fEffectivelyZero)
        {
            NewResistanceText = m_sBarrier;
        }
        else if (oResistValues.fArmourPct > m_fEffectivelyZero)
        {
            NewResistanceText = m_sArmour;
        }
        else if (oResistValues.fHealthPct > m_fEffectivelyZero)
        {
            NewResistanceText = m_sHealth;
        }
    }
    else
    {
        HealthBar.SetVisible(FALSE);
        ArmourBar.SetVisible(FALSE);
        BioticBar.SetVisible(FALSE);
        ShieldBar.SetVisible(FALSE);
        if (MPTargetBarMain != None)
        {
            MPTargetBarMain.SetVisible(FALSE);
        }
        NewResistanceText = "";
    }
    UpdateResistanceTextDisplay(NewResistanceText);
    Invoke0("UpdateTargetDisplay");
}
public final event function UpdateTargetStatusDisplay(const out SFXHUDTargetInfo oTargetInfo)
{
    local bool bBarsVisible;
    
    if (oTargetInfo.Resistances.fHealthPct > m_fEffectivelyZero || oTargetInfo.Resistances.fArmourPct > m_fEffectivelyZero || oTargetInfo.Resistances.fBioticPct > m_fEffectivelyZero || oTargetInfo.Resistances.fShieldPct > m_fEffectivelyZero)
    {
        bBarsVisible = TRUE;
    }
    UpdateTargetStatusVisibility(oTargetInfo);
    SetTargetName(oTargetInfo.sName, oTargetInfo.bHostile);
    SetTargetStatus(oTargetInfo.sStatus, oTargetInfo.bInteractive, bBarsVisible || oTargetInfo.bInRange);
    m_ResistanceBarDisplayValues = oTargetInfo.Resistances;
    UpdateResistanceDisplay(oTargetInfo.Resistances);
}
public final event function UpdateWeaponDisplay(bool bVisible, Weapon pWeap)
{
    local bool bCheckWeaponOverheat;
    local SFXWeapon pSFXWeap;
    local int nAmmoInMagazine;
    local int nAmmoSpare;
    local int nOverheatPercent;
    local float fOverheatPct;
    local bool bShowOverheat;
    local bool bShowOverheatText;
    local bool bForceOverheatUpdate;
    local bool bDisplayInvalidated;
    local int nGrenadeCount;
    local bool bGrenadesVisible;
    local SFXPawn_Player pWeapOwner;
    local string sCenterText;
    
    pSFXWeap = SFXWeapon(pWeap);
    if (pSFXWeap == None)
    {
        bVisible = FALSE;
    }
    else
    {
        pWeapOwner = SFXPawn_Player(pSFXWeap.Owner);
    }
    bShowOverheat = bVisible;
    if (m_bWeaponVisible != bVisible)
    {
        WeaponIcon.SetVisible(bVisible);
        WeaponAmmo.SetVisible(bVisible);
        WeaponClip.SetVisible(bVisible);
        m_bWeaponVisible = bVisible;
        if (bVisible)
        {
            bDisplayInvalidated = TRUE;
        }
    }
    if (bShowOverheat != m_bWeaponOverheatBarVisible || bDisplayInvalidated != FALSE)
    {
        OverheatIndicator.SetVisible(bShowOverheat);
        m_bWeaponOverheatBarVisible = bShowOverheat;
        if (!bVisible)
        {
            SetOverheat(0.0, "");
        }
    }
    if (bVisible && pWeapOwner != None)
    {
        bGrenadesVisible = pWeapOwner.ShouldShowHUDGrenadeCounter();
    }
    if (m_bGrenadesVisible != bGrenadesVisible)
    {
        GrenadeAmmo.SetVisible(bGrenadesVisible);
        SetTextFieldText("SpareGrenades", "");
        m_bGrenadesVisible = bGrenadesVisible;
        m_nCurrentGrenadeCount = -1;
    }
    if (!bVisible)
    {
        return;
    }
    bShowOverheatText = TRUE;
    if (float(pSFXWeap.GetMagazineSize()) <= pSFXWeap.AmmoPerShot)
    {
        bShowOverheatText = FALSE;
    }
    sCenterText = m_sOverheat;
    nAmmoInMagazine = pSFXWeap.GetAmmoCountInMagazine();
    nAmmoSpare = pSFXWeap.GetCurrentSpareAmmo();
    bForceOverheatUpdate = FALSE;
    if (nAmmoInMagazine == 0 && nAmmoSpare == 0)
    {
        sCenterText = m_sNoAmmo;
        m_bHadNoAmmo = TRUE;
    }
    else if (m_bHadNoAmmo)
    {
        m_bHadNoAmmo = FALSE;
        bDisplayInvalidated = TRUE;
        bShowOverheatText = TRUE;
        bForceOverheatUpdate = TRUE;
    }
    if (nAmmoSpare != m_nCurrentWeaponSpareAmmo || bDisplayInvalidated != FALSE)
    {
        if (pSFXWeap.bInfiniteAmmo)
        {
            WeaponAmmo.SetText("");
        }
        else
        {
            WeaponAmmo.SetText(string(nAmmoSpare));
        }
        bCheckWeaponOverheat = TRUE;
        m_nCurrentWeaponSpareAmmo = nAmmoSpare;
    }
    if (nAmmoInMagazine != m_nCurrentClipAmmo || bDisplayInvalidated != FALSE)
    {
        WeaponClip.SetText(string(nAmmoInMagazine));
        bCheckWeaponOverheat = TRUE;
        m_nCurrentClipAmmo = nAmmoInMagazine;
    }
    if (m_bGrenadesVisible && pWeapOwner != None)
    {
        nGrenadeCount = SFXInventoryManager(pWeapOwner.InvManager).GetResource(3);
        if (nGrenadeCount != m_nCurrentGrenadeCount)
        {
            SetTextFieldText("SpareGrenades", string(nGrenadeCount));
            m_nCurrentGrenadeCount = nGrenadeCount;
        }
    }
    if (bCheckWeaponOverheat != FALSE && bShowOverheat != FALSE)
    {
        if (float(nAmmoInMagazine) <= pSFXWeap.LowAmmoSoundThreshold)
        {
            if (pSFXWeap.LowAmmoSoundThreshold > float(0))
            {
                fOverheatPct = 1.0 - float(nAmmoInMagazine) / pSFXWeap.LowAmmoSoundThreshold;
            }
            else if (nAmmoInMagazine == 0)
            {
                fOverheatPct = 1.0;
            }
            else
            {
                fOverheatPct = 0.0;
            }
        }
        else
        {
            fOverheatPct = 0.0;
        }
        if (fOverheatPct == 0.0 || fOverheatPct > 0.0 && bShowOverheatText != FALSE)
        {
            SetOverheat(fOverheatPct, sCenterText, bForceOverheatUpdate);
        }
        nOverheatPercent = Max(1, int(float(nAmmoInMagazine) / float(pSFXWeap.GetMagazineSize()) * float(100)));
        OverheatIndicator.GotoAndStopI(101 - nOverheatPercent);
    }
    if (pSFXWeap.IconRef != m_nCurrentWeaponIcon || PathName(pSFXWeap.IconResource) != m_nCurrentWeaponResource || bDisplayInvalidated != FALSE)
    {
        Class'SFXSFHandler_PowerWheel'.static.SetWeaponTypeDisplay(oPanel, WeaponIcon, PathName(pSFXWeap.IconResource), pSFXWeap.IconRef);
        m_nCurrentWeaponIcon = pSFXWeap.IconRef;
        m_nCurrentWeaponResource = PathName(pSFXWeap.IconResource);
    }
}
private final function AS_PlayNuiSpeech_ExploreFeedback(bool bSuccessful)
{
    ActionScriptVoid("PlayNuiSpeech_ExploreFeedback");
}
private final function AS_PlayNuiSpeech_GenericFeedback(bool bSuccessful, string Text)
{
    ActionScriptVoid("PlayNuiSpeech_GenericFeedback");
}
public final function AS_SetTargetName(string sTargetName, bool bHostile)
{
    ActionScriptVoid("SetTargetName");
}
private final function AS_SetTargetNuiSpeechEnabled(bool bEnabled)
{
    ActionScriptVoid("SetTargetNuiSpeechEnabled");
}
public final function AS_SetTargetStatus(string sStatus, bool bInteractive, bool bInRange)
{
    ActionScriptVoid("SetTargetStatus");
}
public function CleanupReferences()
{
    UnregisterFromPowerManager(SFXPawn(m_oHench1Info.pPawn));
    UnregisterFromPowerManager(SFXPawn(m_oHench2Info.pPawn));
    m_pPlayerController = None;
    m_pPlayerSquad = None;
    m_oShepardInfo.pPawn = None;
    m_oShepardInfo.pIcon = None;
    m_oHench1Info.pPawn = None;
    m_oHench1Info.pIcon = None;
    m_oHench1Info.pPowerIcon.Cleanup();
    m_oHench1Info.pPowerIcon = None;
    m_oHench2Info.pPawn = None;
    m_oHench2Info.pIcon = None;
    m_oHench2Info.pPowerIcon.Cleanup();
    m_oHench2Info.pPowerIcon = None;
    m_pCurrentDisplayTarget = None;
    m_pCurrentTarget = None;
    __OnNotificationCompleted__Delegate = None;
    CleanupNativeReferences();
}
public function string GetActionIconString(ESFXHUDActionIcon eActionIcon)
{
    local stringref sr;
    local string sAction;
    
    ClearCustomTokens();
    switch (eActionIcon)
    {
        case ESFXHUDActionIcon.SFXHUD_Cover_Enter:
            sr = m_srCoverEnterAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Mantle:
            sr = m_srCoverMantleAction;
            SetCustomToken(0, "[XBoxB_Btn_LSUp]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Climb:
            sr = m_srCoverClimbAction;
            SetCustomToken(0, "[XBoxB_Btn_LSUp]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_90DegreeRight:
            sr = m_srCover90RightAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_90DegreeLeft:
            sr = m_srCover90LeftAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipRight:
            sr = m_srCoverSlipRightAction;
            SetCustomToken(0, "[XBoxB_Btn_LSUp]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipLeft:
            sr = m_srCoverSlipLeftAction;
            SetCustomToken(0, "[XBoxB_Btn_LSUp]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnRight:
            sr = m_srCoverSwatRightAction;
            SetCustomToken(0, "[XBoxB_Btn_LSRight]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnLeft:
            sr = m_srCoverSwatLeftAction;
            SetCustomToken(0, "[XBoxB_Btn_LSLeft]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Grab:
            sr = m_srCoverGrabAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Melee"));
            break;
        case ESFXHUDActionIcon.SFXHUD_LadderUp:
            sr = m_srLadderUpAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_LadderDown:
            sr = m_srLadderDownAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_GapJump:
            sr = m_srGapJumpAction;
            SetCustomToken(0, "[XBoxB_Btn_LSUp]");
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_AtlasSuit:
            sr = m_srAtlasSuitAction;
            SetCustomToken(0, GetBoundKeyString("Shared_Action"));
            break;
        default:
    }
    sAction = GetUIString(sr, TRUE);
    return sAction;
}
public final function HideActionIndicator()
{
    if (m_eCurrentActionIcon == ESFXHUDActionIcon.SFXHUD_Action_NONE)
    {
        return;
    }
    m_eCurrentActionIcon = ESFXHUDActionIcon.SFXHUD_Action_NONE;
    ActionIcon.GotoAndPlay("out");
}
public final function OnNotificationComplete()
{
    if (__OnNotificationCompleted__Delegate != None)
    {
        __OnNotificationCompleted__Delegate(Notification.nID);
        Notification.nID = 0;
    }
}
public final function OnPawnPowerUsed(SFXPowerCustomAction oPower)
{
    if (oPower == None || oPower.m_oPawn == None)
    {
        return;
    }
    if (m_oHench1Info.pPawn == oPower.m_oPawn && m_oHench1Info.pPowerIcon != None)
    {
        m_oHench1Info.pPowerIcon.PowerUsed(oPower);
    }
    else if (m_oHench2Info.pPawn == oPower.m_oPawn && m_oHench2Info.pPowerIcon != None)
    {
        m_oHench2Info.pPowerIcon.PowerUsed(oPower);
    }
}
public final function PlayTargetHitIndication(Pawn pTargetPawn, float fDamage, Controller instigatedBy, Class<DamageType> DamageType, Actor DamageCauser)
{
    if (pTargetPawn == None || pTargetPawn != m_pCurrentTarget || MPTargetHitDisplay == None)
    {
        return;
    }
    if (fDamage <= 0.0)
    {
        return;
    }
    MPTargetHitDisplay.GotoAndPlay("flash");
}
public final function PowerIconCooldownDone(GFxValue oPowerIcon)
{
    if (oPowerIcon == None)
    {
        return;
    }
    if (m_oHench1Info.pPowerIcon == oPowerIcon)
    {
        m_oHench1Info.pPowerIcon.SetToDefaultHenchIcon(m_oHench1Info.pPawn);
    }
    else if (m_oHench2Info.pPowerIcon == oPowerIcon)
    {
        m_oHench2Info.pPowerIcon.SetToDefaultHenchIcon(m_oHench2Info.pPawn);
    }
}
public final function PulseFullAmmoMessage(bool bGrenade)
{
    local PlayerController PC;
    local GFxValue oAmmoFullSub;
    
    PC = GetPC();
    if (PC != None && PC.WorldInfo.TimeSeconds - LastAmmoPulseTime >= 2.0)
    {
        LastAmmoPulseTime = PC.WorldInfo.TimeSeconds;
        oAmmoFullSub = AmmoFull.GetObject("ammo");
        AmmoFull.SetVisible(TRUE);
        AmmoFull.GotoAndPlay("show");
        oAmmoFullSub.SetMemberObjectText("text", UIStrRef(m_srAmmoFull));
        oAmmoFullSub.GotoAndStopI(bGrenade ? 2 : 1);
        PlayGuiSound('FullAmmo');
    }
}
public final function SetActionIndicator(ESFXHUDActionIcon eActionIcon)
{
    local string sFrame;
    local string sAction;
    local GFxValue oActionIcons;
    local BioPlayerController oPC;
    
    if (int(m_eCurrentActionIcon) == int(eActionIcon))
    {
        return;
    }
    oPC = BioPlayerController(GetPC());
    if (oPC != None && oPC.ProfileSettings != None)
    {
        if (oPC.ProfileSettings.GetActionIconHintOption() == FALSE)
        {
            HideActionIndicator();
            return;
        }
    }
    switch (eActionIcon)
    {
        case ESFXHUDActionIcon.SFXHUD_Cover_Enter:
            sFrame = "Cover";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Mantle:
            sFrame = "Mantle";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Climb:
            sFrame = "Climb";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_90DegreeRight:
            sFrame = "90DegreeRight";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_90DegreeLeft:
            sFrame = "90DegreeLeft";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipRight:
            sFrame = "CoverSlipRight";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipLeft:
            sFrame = "CoverSlipLeft";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnRight:
            sFrame = "SwatTurnRight";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnLeft:
            sFrame = "SwatTurnLeft";
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Grab:
            sFrame = "CoverGrab";
            break;
        case ESFXHUDActionIcon.SFXHUD_LadderDown:
            sFrame = "LadderDown";
            break;
        case ESFXHUDActionIcon.SFXHUD_LadderUp:
            sFrame = "LadderUp";
            break;
        case ESFXHUDActionIcon.SFXHUD_GapJump:
            sFrame = "GapJump";
            break;
        case ESFXHUDActionIcon.SFXHUD_AtlasSuit:
            sFrame = "AtlasSuit";
            break;
        case ESFXHUDActionIcon.SFXHUD_Action_NONE:
        default:
            HideActionIndicator();
            return;
    }
    m_eCurrentActionIcon = eActionIcon;
    sAction = GetActionIconString(eActionIcon);
    oActionIcons = ActionIcon.GetObject("Icons");
    ActionIcon.GotoAndPlay("in");
    oActionIcons.SetMemberObjectText("txtCoverAction", sAction);
    oActionIcons.GotoAndStop(sFrame);
}
public final function SetCenterStatus(string sText)
{
    if (sText != "")
    {
        CenterStatus.SetVisible(TRUE);
        CenterStatusText.SetMemberObjectText("text", sText);
    }
    else
    {
        CenterStatus.SetVisible(FALSE);
    }
}
public final function SetOverheat(float fOverheatPct, string sCenterText, optional bool bForce = FALSE)
{
    local ASDisplayInfo oOverheatInfo;
    
    if (Abs(fOverheatPct - m_fCurrentOverheatValue) > 0.00999999978 || bForce != FALSE)
    {
        if (fOverheatPct > 0.0)
        {
            SetCenterStatus(sCenterText);
            OverheatIndicatorTextAnimText.SetMemberObjectText("text", sCenterText);
            if (OverheatIndicatorTextAnim != None)
            {
                OverheatIndicatorTextAnim.SetVisible(TRUE);
                oOverheatInfo = OverheatIndicatorTextAnim.GetDisplayInfo();
                oOverheatInfo.Alpha = 100.0 * Lerp(0.200000003, 1.0, fOverheatPct);
                OverheatIndicatorTextAnim.SetDisplayInfo(oOverheatInfo);
            }
        }
        else
        {
            SetCenterStatus("");
            OverheatIndicatorTextAnimText.SetMemberObjectText("text", "");
            OverheatIndicatorTextAnim.SetVisible(FALSE);
        }
        m_fCurrentOverheatValue = fOverheatPct;
    }
}
public function SetPOIHintDisplay()
{
    local GFxValue pHint;
    local string POIText;
    
    pHint = POI.GetObject("Text");
    if (pHint != None)
    {
        pHint.SetVisible(TRUE);
        if (oWorldInfo.IsConsoleBuild())
        {
            POIText = "[XBoxB_Btn_R3]";
        }
        else
        {
            POIText = GetBoundKeyString("Shared_ShowMap", TRUE);
        }
        pHint.SetMemberObjectText("Text", POIText);
    }
}
public final function SetPOIState(ESFXHUDPOIIconState eState)
{
    if (m_lstQueuedPOIStates.Length < 10)
    {
        m_lstQueuedPOIStates[m_lstQueuedPOIStates.Length] = eState;
    }
}
public final function SetTargetName(string sTargetName, optional bool bHostile = FALSE)
{
    if (sTargetName != "")
    {
        AS_SetTargetName(sTargetName, bHostile);
        TargetName.SetVisible(TRUE);
    }
    else
    {
        TargetName.SetVisible(FALSE);
    }
}
public function SetTargetStatus(string sStatus, optional bool bInteractive = FALSE, optional bool bInRange = TRUE)
{
    if (sStatus != "")
    {
        AS_SetTargetStatus(sStatus, bInteractive, bInRange);
        TargetStatus.SetVisible(TRUE);
    }
    else
    {
        TargetStatus.SetVisible(FALSE);
        ButtonA.SetVisible(FALSE);
    }
}
public final function UpdateResistanceBarDisplay(float fResistPercent, GFxValue oBarClip)
{
    local int nFrame;
    
    if (fResistPercent > 0.0)
    {
        oBarClip.SetVisible(TRUE);
        if (MPTargetBarMain == None)
        {
            nFrame = int((float(1) - fResistPercent) * float(100));
            if (nFrame == 0)
            {
                nFrame = 1;
            }
            oBarClip.GotoAndStopI(nFrame);
        }
        else
        {
            UpdateMPResistanceBarDisplay(fResistPercent, oBarClip);
        }
    }
    else
    {
        oBarClip.SetVisible(FALSE);
    }
}
public final function UpdateResistanceTextDisplay(string NewResistanceBarText)
{
    if (NewResistanceBarText != m_sResistanceText)
    {
        m_sResistanceText = NewResistanceBarText;
        ResistanceText.SetText(NewResistanceBarText);
    }
}
public final function UpdateTargetStatusVisibility(const out SFXHUDTargetInfo oTargetInfo)
{
    local bool bHaveHealth;
    local bool bHaveText;
    
    if (oTargetInfo.Resistances.fHealthPct > m_fEffectivelyZero || oTargetInfo.Resistances.fArmourPct > m_fEffectivelyZero || oTargetInfo.Resistances.fBioticPct > m_fEffectivelyZero || oTargetInfo.Resistances.fShieldPct > m_fEffectivelyZero)
    {
        bHaveHealth = TRUE;
    }
    if (oTargetInfo.sName != "" || oTargetInfo.sStatus != "")
    {
        bHaveText = TRUE;
    }
    if (m_pCurrentTarget == None)
    {
        bHaveHealth = FALSE;
        bHaveText = FALSE;
    }
    if (bHaveHealth == FALSE && bHaveText == FALSE)
    {
        if (m_bTargetStatusVisible)
        {
            SetTargetName("");
            SetTargetStatus("");
            TargetBackground.SetVisible(FALSE);
            m_bTargetStatusVisible = FALSE;
            if (MPTargetBarMain != None)
            {
                MPTargetBarMain.SetVisible(FALSE);
            }
        }
    }
    else if (m_bTargetStatusVisible == FALSE && m_pCurrentTarget != None)
    {
        TargetBackground.SetVisible(TRUE);
        m_bTargetStatusVisible = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_oShepardInfo = {
                      sPath = "Player", 
                      sIconImagePath = "g_PCImage.ImageResource", 
                      sShieldPath = "Player.Shields.Shields.Gauge.shield", 
                      sBioticPath = "Player.Shields.Shields.Gauge.barrier", 
                      sArmourPath = "", 
                      sHealthPath = "", 
                      sPowerPath = "", 
                      Resistances = {
                                     fHealthPct = 0.0, 
                                     fArmourPct = 0.0, 
                                     fBioticPct = 0.0, 
                                     fShieldPct = 0.0, 
                                     bHasShield = FALSE, 
                                     bHasArmour = FALSE, 
                                     bHasBiotic = FALSE, 
                                     bHasHealth = FALSE
                                    }, 
                      DisplayedResistances = {
                                              fHealthPct = 0.0, 
                                              fArmourPct = 0.0, 
                                              fBioticPct = 0.0, 
                                              fShieldPct = 0.0, 
                                              bHasShield = FALSE, 
                                              bHasArmour = FALSE, 
                                              bHasBiotic = FALSE, 
                                              bHasHealth = FALSE
                                             }, 
                      pPawn = None, 
                      pIcon = None, 
                      fCooldown = 0.0, 
                      fElapsedFullResistTime = 0.0, 
                      pPowerIcon = None, 
                      bCooldownVisible = FALSE, 
                      bShieldVisible = FALSE, 
                      bBioticVisible = FALSE, 
                      bArmourVisible = FALSE, 
                      bHealthVisible = FALSE, 
                      bShieldDamage = FALSE, 
                      bBioticDamage = FALSE, 
                      bArmourDamage = FALSE, 
                      bHealthDamage = FALSE, 
                      bInvalidated = FALSE, 
                      bVisible = FALSE, 
                      bUpdateResistance = FALSE, 
                      bUpdateHealth = FALSE, 
                      bUpdatePower = FALSE, 
                      bUpdateIcon = FALSE, 
                      bDisplayVisible = FALSE, 
                      ePortraitState = ESFXPortraitState.PORTRAIT_STATE_NORMAL
                     }
    m_oHench1Info = {
                     sPath = "Team.Team1", 
                     sIconImagePath = "g_Hench1Image.ImageResource", 
                     sShieldPath = "Team.Team1.Shields.Shields", 
                     sBioticPath = "Team.Team1.Shields.Biotic", 
                     sArmourPath = "Team.Team1.Shields.Armour", 
                     sHealthPath = "Team.Team1.Health", 
                     sPowerPath = "Team.Team1.Power", 
                     Resistances = {
                                    fHealthPct = 0.0, 
                                    fArmourPct = 0.0, 
                                    fBioticPct = 0.0, 
                                    fShieldPct = 0.0, 
                                    bHasShield = FALSE, 
                                    bHasArmour = FALSE, 
                                    bHasBiotic = FALSE, 
                                    bHasHealth = FALSE
                                   }, 
                     DisplayedResistances = {
                                             fHealthPct = 0.0, 
                                             fArmourPct = 0.0, 
                                             fBioticPct = 0.0, 
                                             fShieldPct = 0.0, 
                                             bHasShield = FALSE, 
                                             bHasArmour = FALSE, 
                                             bHasBiotic = FALSE, 
                                             bHasHealth = FALSE
                                            }, 
                     pPawn = None, 
                     pIcon = None, 
                     fCooldown = 0.0, 
                     fElapsedFullResistTime = 0.0, 
                     pPowerIcon = None, 
                     bCooldownVisible = FALSE, 
                     bShieldVisible = FALSE, 
                     bBioticVisible = FALSE, 
                     bArmourVisible = FALSE, 
                     bHealthVisible = FALSE, 
                     bShieldDamage = FALSE, 
                     bBioticDamage = FALSE, 
                     bArmourDamage = FALSE, 
                     bHealthDamage = FALSE, 
                     bInvalidated = FALSE, 
                     bVisible = FALSE, 
                     bUpdateResistance = FALSE, 
                     bUpdateHealth = FALSE, 
                     bUpdatePower = FALSE, 
                     bUpdateIcon = FALSE, 
                     bDisplayVisible = FALSE, 
                     ePortraitState = ESFXPortraitState.PORTRAIT_STATE_NORMAL
                    }
    m_oHench2Info = {
                     sPath = "Team.Team2", 
                     sIconImagePath = "g_Hench2Image.ImageResource", 
                     sShieldPath = "Team.Team2.Shields.Shields", 
                     sBioticPath = "Team.Team2.Shields.Biotic", 
                     sArmourPath = "Team.Team2.Shields.Armour", 
                     sHealthPath = "Team.Team2.Health", 
                     sPowerPath = "Team.Team2.Power", 
                     Resistances = {
                                    fHealthPct = 0.0, 
                                    fArmourPct = 0.0, 
                                    fBioticPct = 0.0, 
                                    fShieldPct = 0.0, 
                                    bHasShield = FALSE, 
                                    bHasArmour = FALSE, 
                                    bHasBiotic = FALSE, 
                                    bHasHealth = FALSE
                                   }, 
                     DisplayedResistances = {
                                             fHealthPct = 0.0, 
                                             fArmourPct = 0.0, 
                                             fBioticPct = 0.0, 
                                             fShieldPct = 0.0, 
                                             bHasShield = FALSE, 
                                             bHasArmour = FALSE, 
                                             bHasBiotic = FALSE, 
                                             bHasHealth = FALSE
                                            }, 
                     pPawn = None, 
                     pIcon = None, 
                     fCooldown = 0.0, 
                     fElapsedFullResistTime = 0.0, 
                     pPowerIcon = None, 
                     bCooldownVisible = FALSE, 
                     bShieldVisible = FALSE, 
                     bBioticVisible = FALSE, 
                     bArmourVisible = FALSE, 
                     bHealthVisible = FALSE, 
                     bShieldDamage = FALSE, 
                     bBioticDamage = FALSE, 
                     bArmourDamage = FALSE, 
                     bHealthDamage = FALSE, 
                     bInvalidated = FALSE, 
                     bVisible = FALSE, 
                     bUpdateResistance = FALSE, 
                     bUpdateHealth = FALSE, 
                     bUpdatePower = FALSE, 
                     bUpdateIcon = FALSE, 
                     bDisplayVisible = FALSE, 
                     ePortraitState = ESFXPortraitState.PORTRAIT_STATE_NORMAL
                    }
    m_nCurrentBarCount = -1
    m_nNumMiniNotifications = 4
    m_nCurrentGrenadeCount = -1
    m_fHealthShieldUpdateDelta = 0.00499999989
    m_fDamageIndicatorAlphaUpdateDelta = 1.0
    m_fLowHealthWarning = 0.100000001
    m_fWeaponUpdateInterval = 0.100000001
    m_fBarAnimRate = 10.0
    m_fFullStatFadeTime = 1.5
    m_fMiniNotificationAnimTime = 1.0
    m_srStatusBarrierText = $295112
    m_srStatusBleedoutText = $295114
    m_srStatusHardenedShieldsText = $295110
    m_srStatusHeavyArmourText = $295113
    m_srStatusMinimalDamageText = $295115
    m_srStatusSuperRegenText = $295111
    m_srShields = $315756
    m_srArmour = $315757
    m_srBarrier = $315758
    m_srHealth = $315759
    m_srOverheat = $339456
    m_srNoAmmo = $709680
    m_srAmmoFull = $348977
    m_srCoverEnterAction = $560698
    m_srCoverClimbAction = $560701
    m_srCoverMantleAction = $560701
    m_srCover90RightAction = $560695
    m_srCover90LeftAction = $560695
    m_srCoverSlipRightAction = $560696
    m_srCoverSlipLeftAction = $560696
    m_srCoverSwatRightAction = $560692
    m_srCoverSwatLeftAction = $560692
    m_srCoverGrabAction = $563699
    m_srLadderUpAction = $560698
    m_srLadderDownAction = $560698
    m_srGapJumpAction = $560696
    m_srAtlasSuitAction = $560698
    m_nNotificationBodyLength = 100
    m_bDisplayWeaponOverride = TRUE
    m_bDisablePlayerHealth = TRUE
    m_bUseMPHealthDisplay = TRUE
    bSetGameMode = FALSE
    MovieAlpha = 80.0
    bOnlyOwnerFocusable = TRUE
    bDiscardNonOwnerInput = TRUE
}