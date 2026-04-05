Class SFXSFHandler_PowerWheel extends SFXGUIMovieLegacyAdapter
    native
    transient
    config(UI);

struct native SFXPowerIconData 
{
    var string Path;
    var string MappedIconPath;
    var string MappedIconBGPath;
    var string Id;
    var float Boundary;
    var bool IsHenchmanIcon;
    var bool IsQuickslotIcon;
};
struct native SFXRadarElementData 
{
    var Vector vActorLocation;
    var Vector vPosition;
    var int nSize;
    var int nRelativeZ;
    var int nID;
    var bool bLocked;
    var bool bUpdate;
    var bool bUpdateLock;
    var EBioRadarType eRadarType;
};
struct native SFXPowerWheelPawnIndices 
{
    var array<int> aPlayer;
    var array<int> aHench1;
    var array<int> aHench2;
};
struct native SFXPowerWheelIconWeapon extends SFXPowerWheelIcon 
{
    var string sName;
    var string sPawnName;
    var string sDescription;
    var string sIconResource;
    var Class<SFXWeapon> oWeaponClass;
    var int nWeaponIcon;
    var int nAmmo;
    var GFxValue oIconMC;
    var bool bEquipped;
    var SFXPowerWheelWeaponState eWeaponState;
};
enum SFXPowerWheelWeaponState
{
    PWWS_Normal,
    PWWS_Hover,
    PWWS_Disabled,
    PWWS_Selected,
    PWWS_WEAPSTATE_COUNT,
};
struct native SFXPowerWheelIcon 
{
    var string sPath;
    var string sID;
    var float fBoundary;
    var bool bHenchIcon;
};
enum SFXPowerWheelPawnID
{
    PWPID_Player,
    PWPID_Hench1,
    PWPID_Hench2,
};
enum SFXPowerWheelMode
{
    PWM_NONE,
    PWM_Powers,
    PWM_Weapons,
    PWM_PC,
};
const WEAPON_FAIL = 1;
const WEAPON_NONE = 0;

var string m_aMappingIconPaths[9];
var SFXPowerWheelPawnIndices m_oPowerIndices;
var SFXPowerWheelPawnIndices m_oWeaponIndices;
var SFXPowerWheelButtonIcon m_oMapTextIcon1;
var SFXPowerWheelButtonIcon m_oMapTextIcon2;
var array<SFXPowerIconData> m_aPowerIconInfo;
var array<SFXGUIValue_PowerIcon> m_aPowerIcons;
var array<SFXPowerWheelIconWeapon> m_aWeaponIcons;
var array<SFXRadarElementData> m_aRadarElementData;
var string m_sWheelPath;
var string m_sWheelInnerPath;
var string m_sTitleTextPath;
var string m_sNameTextPath;
var string m_sInfoTextPath;
var string m_sInfoTextBGPath;
var string m_sUseButtonPath;
var string m_sUseTextPath;
var string m_sMapButton1Path;
var string m_sMapText1Path;
var string m_sMapButton2Path;
var string m_sMapText2Path;
var string m_sMapText3Path;
var string m_sMapButton3Path;
var array<string> m_aRadarIconFramePaths;
var string m_sShepardBlockerPath;
var string m_sHench1BlockerPath;
var string m_sHench2BlockerPath;
var string m_sRadarPath;
var string m_sTeam1StatusTextPath;
var string m_sTeam1PowerTextPath;
var string m_sHench1PortraitImagePath;
var string m_sHench1PortraitMovieClipPath;
var string m_sTeam2StatusTextPath;
var string m_sTeam2PowerTextPath;
var string m_sHench2PortraitImagePath;
var string m_sHench2PortraitMovieClipPath;
var string m_sWheelArrowPath;
var string m_sNuiSpeechIconPath;
var config string m_sNotSuggestedPrefix;
var config string m_sNotSuggestedSuffix;
var config string m_sMap1Token;
var config string m_sMap2Token;
var config string m_sMap3Token;
var config string m_sMapHench1Token;
var config string m_sMapHench2Token;
var delegate<WeaponSort> __WeaponSort__Delegate;
var int m_aWeaponStateFrames[4];
var Vector m_vLStickInput;
var Vector2D m_vViewportOffsets;
var Vector2D m_vCacheRadarBoundaryTopLeft;
var Vector2D m_vCacheRadarBoundaryBottomRight;
var config Vector2D m_vBoundaryDimensions;
var BioPlayerController m_pPlayerController;
var BioBaseSquad m_pPlayerSquad;
var float m_fButtonTextPadding;
var float m_fMovieWidth;
var float m_fMovieHeight;
var float m_fRemainingRadarPulseTime;
var float m_fInfoTextChangeDelay;
var float m_fRemainingInfoTextChangeDelay;
var float m_fTimeToNextVehicleRadarUpdate;
var float m_fTimeToNextObjectiveUpdate;
var float m_fLastProcessedStickAngle;
var float m_fCurrentProcessedStickAngle;
var config float m_fThumbstickInterpSpeed;
var float m_fLastStickDeflection;
var config float m_fLStickAngleDeltaDeg;
var config float m_fLStickStickyIconAngle;
var int m_nCurrentPowerIconIndex;
var int m_nCurrentWeaponIconIndex;
var int m_nCurrentSelectedWeapon;
var BioPawn m_pShepardPawn;
var BioPawn m_pHench1Pawn;
var BioPawn m_pHench2Pawn;
var Actor m_pCurrentPlayerSelection;
var float m_fCacheTargetDirection;
var float m_fCacheNorthDirection;
var float m_fCachePathDirection;
var float m_fCacheRadarBoundaryRotation;
var config stringref m_srBlocked;
var config stringref m_srPawnIncapacitated;
var config stringref m_srWeaponSwitching;
var config stringref m_srWeaponOverheating;
var config stringref m_srWeaponReloading;
var config stringref m_srDisplayTitle;
var config stringref m_srWeaponWheelDisplayTitle;
var config stringref m_srPowerWheelDisplayTitle;
var config stringref m_srEquip;
var config stringref m_srUse;
var config stringref m_srMap;
var config stringref m_srOverheated;
var config stringref m_srRecharging;
var config stringref m_srUnavailable;
var config stringref m_srRadarRangeUnits;
var config stringref m_srNorthText;
var config stringref m_srObjective;
var config float m_fRadarDirectionChangeDelta;
var config float m_fRadarElementLocationChangeDelta;
var config float m_fRadarRadius;
var config float m_fBoundaryShrinkFactor;
var config float m_fVehicleRadarUpdateInterval;
var config float m_fRadarObjectiveUpdateInterval;
var bool m_bVisible;
var bool m_bRadarVisible;
var bool m_bRadarOn;
var bool m_bInOutTransition;
var bool m_bProcessSquadHenchmen;
var bool m_bCanMapPlayerPowers;
var bool m_bHavePathAssistGoal;
var bool m_bPingPathAssistArrow;
var bool m_bInfoTextBackgroundVisible;
var bool m_bDesiredInfoTextBackgroundVisibility;
var bool m_bWheelArrowVisible;
var bool m_bObjectiveRadarOn;
var bool m_bPulsingRadar;
var bool m_bShowUseMapText;
var bool m_bSquadChanged;
var SFXPowerWheelMode m_ePowerWheelMode;

public static final event function bool CanIssueImmediateOrder(Pawn pPawn)
{
    local SFXAI_Henchman pHenchman;
    local BioPlayerController pPlayer;
    
    if (pPawn != None)
    {
        pHenchman = SFXAI_Henchman(pPawn.Controller);
        pPlayer = BioPlayerController(pPawn.Controller);
    }
    if (pHenchman != None && pHenchman.IsEnabled())
    {
        return pHenchman.CanStartImmediateOrder();
    }
    else if (pPlayer != None)
    {
        return pPlayer.CanStartImmediateOrder();
    }
    return FALSE;
}
public static final event function bool CanIssueQueuedOrder(Pawn pPawn)
{
    local SFXAI_Henchman pHenchman;
    local BioPlayerController pPlayer;
    
    if (pPawn != None)
    {
        pHenchman = SFXAI_Henchman(pPawn.Controller);
        pPlayer = BioPlayerController(pPawn.Controller);
    }
    if (pHenchman != None)
    {
        return pHenchman.CanQueueOrder();
    }
    else if (pPlayer != None)
    {
        return pPlayer.CanQueueOrder();
    }
    return FALSE;
}
public final native function CollectRadarElementData(out array<SFXRadarElementData> aRadarData);

public event function doHotKey(int nIndex);

public function GameSessionEnded()
{
    CleanupReferences();
    Super.GameSessionEnded();
}
public final event function Name GetCurrentHenchmanOrder(BioPawn pPawn)
{
    local SFXAI_Henchman pHenchController;
    local HenchmanOrder oNextOrder;
    
    if (pPawn == None)
    {
        return 'None';
    }
    pHenchController = SFXAI_Henchman(pPawn.Controller);
    if (pHenchController == None)
    {
        return 'None';
    }
    oNextOrder = pHenchController.GetNextOrder(1);
    return oNextOrder.nmPower;
}
public final event function Name GetHenchmanMappedPower(BioPawn pPawn)
{
    if (SFXPawn_Henchman(pPawn) != None)
    {
        return SFXPawn_Henchman(pPawn).m_nmMappedPower;
    }
    return 'None';
}
public final native function bool GetMapBoundaryValues(out Vector2D vTopLeft, out Vector2D vBottomRight, out float fBoundaryRotation);

public final native function BioPawn GetPawnFromName(Name nmPawn);

public final native function GetRadarDirectionValues(out float fArrowDirection, out float fNorthDirection, out float fPathingArrowDirection);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            m_vLStickInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            m_vLStickInput.Y = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_A:
            SelectCurrentWheelItem(m_ePowerWheelMode);
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_X:
            if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers)
            {
                m_pPlayerController.GenerateTutorialEvent(11);
                MapCurrentPower(5);
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_B:
            if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers)
            {
                m_pPlayerController.GenerateTutorialEvent(11);
                MapCurrentPower(6);
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_Y:
            if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers)
            {
                m_pPlayerController.GenerateTutorialEvent(11);
                MapCurrentPower(1);
            }
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final native function bool HaveHenchmen();

public final event function HoverPowerIcon(int nIconIndex, bool bSkipTransition)
{
    local SFXGUIValue_PowerIcon oIcon;
    local Name nmPower;
    
    if (nIconIndex < 0 || nIconIndex >= m_aPowerIcons.Length)
    {
        return;
    }
    if (m_nCurrentPowerIconIndex == nIconIndex)
    {
        return;
    }
    LeavePowerIcon(m_nCurrentPowerIconIndex, bSkipTransition);
    oIcon = m_aPowerIcons[nIconIndex];
    oIcon.SetHover(TRUE, bSkipTransition);
    oIcon.SetSelected(TRUE);
    UpdateTextDisplayForIcon(nIconIndex);
    PlayGuiSound('HUDPowerWheelChangeHighlightedPower');
    m_nCurrentPowerIconIndex = nIconIndex;
    if (oIcon.pPower != None)
    {
        nmPower = oIcon.pPower.PowerName;
    }
    else
    {
        nmPower = oIcon.nmPowerName;
    }
    BioHintSystem(m_pPlayerController.HintSystem).UpdatePowerWheelTutorialHint(nmPower);
}
public final event function HoverWeaponIcon(int nIconIndex, optional bool bForceUpdate = FALSE)
{
    local string sWeaponName;
    local string sInfo;
    local bool bNuiSpeechEnabled;
    local string sDisplayText;
    
    bNuiSpeechEnabled = IsNuiSpeechEnabled();
    sWeaponName = "";
    sInfo = "";
    if (m_nCurrentWeaponIconIndex == nIconIndex && bForceUpdate == FALSE)
    {
        return;
    }
    LeaveWeaponIcon(m_nCurrentWeaponIconIndex);
    if (nIconIndex >= 0 && nIconIndex < m_aWeaponIcons.Length)
    {
        if (m_aWeaponIcons[nIconIndex].eWeaponState != SFXPowerWheelWeaponState.PWWS_Disabled && m_aWeaponIcons[nIconIndex].nWeaponIcon != 0)
        {
            SetWeaponState(nIconIndex, 1);
            sWeaponName = m_aWeaponIcons[nIconIndex].sName;
            sInfo = m_aWeaponIcons[nIconIndex].sDescription;
            PlayGuiSound('HUDWeaponPadNewHighlight');
            if (m_aWeaponIcons[nIconIndex].bEquipped == FALSE)
            {
                SetCustomToken(0, sWeaponName);
                SetUseText(GetUIString(m_srEquip, TRUE));
                ClearCustomTokens();
            }
            else
            {
                SetUseText("");
            }
            if (bNuiSpeechEnabled)
            {
                sInfo = sWeaponName $ "\n" $ sInfo;
                if (m_aWeaponIcons[nIconIndex].bHenchIcon)
                {
                    sDisplayText = GetNuiPawnCommandString(m_aWeaponIcons[nIconIndex].sPawnName, GetUIString(m_aWeaponIcons[nIconIndex].oWeaponClass.default.NuiSpeechName));
                }
                else
                {
                    sDisplayText = GetUIString(m_aWeaponIcons[nIconIndex].oWeaponClass.default.NuiSpeechName);
                }
            }
            else
            {
                sDisplayText = sWeaponName;
            }
            BioHintSystem(m_pPlayerController.HintSystem).UpdateWeaponWheelTutorialHint(m_aWeaponIcons[nIconIndex].nWeaponIcon);
        }
        SetInformationText(sDisplayText, sInfo, bNuiSpeechEnabled);
    }
    m_nCurrentWeaponIconIndex = nIconIndex;
}
public event function InitDisplay()
{
    local int nIcon;
    local float fTemp;
    
    oPanel.SetTextFieldText(m_sTitleTextPath, "");
    InitPowerIcons();
    for (nIcon = 0; nIcon < m_aWeaponIcons.Length; ++nIcon)
    {
        m_aWeaponIcons[nIcon].oIconMC = GetVariableObject(m_aWeaponIcons[nIcon].sPath);
        if (m_aWeaponIcons[nIcon].oIconMC == None)
        {
            continue;
        }
        HideWeaponIcon(oPanel, m_aWeaponIcons[nIcon].oIconMC);
    }
    if (m_bShowUseMapText)
    {
        fTemp = oPanel.GetVariableFloat(m_sUseButtonPath $ "._x");
        m_fButtonTextPadding = oPanel.GetVariableFloat(m_sUseTextPath $ "._x") - fTemp;
    }
    SetUseText("");
    SetMapText("", 0, "", 0, "", 0);
    oPanel.SetTextFieldText(m_sRadarPath $ ".NorthIndicator.CompassMC.text", "");
}
public final event function LeavePowerIcon(int nIconIndex, bool bSkipTransition)
{
    if (nIconIndex < 0 || nIconIndex >= m_aPowerIcons.Length)
    {
        return;
    }
    if (m_nCurrentPowerIconIndex != nIconIndex)
    {
        return;
    }
    m_aPowerIcons[nIconIndex].SetHover(FALSE, bSkipTransition);
    m_aPowerIcons[nIconIndex].SetSelected(FALSE);
    SetInformationText("", "", FALSE);
    m_nCurrentPowerIconIndex = -1;
}
public final event function LeaveWeaponIcon(int nIconIndex)
{
    if (m_nCurrentWeaponIconIndex != nIconIndex)
    {
        return;
    }
    if (nIconIndex >= 0 && nIconIndex < m_aWeaponIcons.Length)
    {
        if (m_aWeaponIcons[nIconIndex].eWeaponState != SFXPowerWheelWeaponState.PWWS_Disabled && m_aWeaponIcons[nIconIndex].nWeaponIcon != 0)
        {
            if (m_aWeaponIcons[nIconIndex].bEquipped == FALSE)
            {
                SetWeaponState(nIconIndex, 0);
            }
            else
            {
                SetWeaponState(nIconIndex, 3);
            }
        }
    }
    m_nCurrentWeaponIconIndex = -1;
}
public final native function MapCurrentPower(SFXPowerWheelMapButtonIcon eIcon);

public event function OnPanelRemoved()
{
    CleanupReferences();
    Super.OnPanelRemoved();
}
public final native function PulseRadar(float fPulseTime);

public final event function RadarVisibilityChanged(bool bVisible, optional bool bObjectiveMode = FALSE)
{
    if (m_bRadarVisible == bVisible)
    {
        return;
    }
    m_bRadarVisible = bVisible;
    if (!bVisible)
    {
        oPanel.InvokeMethod("ClearRadar");
        oPanel.GotoLabelAndPlay("Radar", "hide");
        return;
    }
    else
    {
        oPanel.GotoLabelAndPlay("Radar", "show");
    }
    UpdateRadarDisplay(bObjectiveMode);
}
public native function RemoveHenchman(BioPawn pPawn);

public final native function SelectCurrentPower();

public final event function bool SetHenchmanMappedPower(BioPawn pPawn, Name nmPower)
{
    if (SFXPawn_Henchman(pPawn) != None)
    {
        SFXPawn_Henchman(pPawn).m_nmMappedPower = nmPower;
        return TRUE;
    }
    return FALSE;
}
public final native function SetMappingIcon(out SFXPowerWheelButtonIcon oIcon, SFXPowerWheelMapButtonIcon eNewIcon, optional bool bClear = FALSE);

public event function SetMapText(string sText1, SFXPowerWheelMapButtonIcon eIcon1, optional string sText2 = "", optional SFXPowerWheelMapButtonIcon eIcon2 = 0, optional string sText3 = "", optional SFXPowerWheelMapButtonIcon eIcon3 = 0)
{
    if (!m_bShowUseMapText)
    {
        return;
    }
    oPanel.SetTextFieldText(m_sMapText1Path, sText1);
    if (sText1 != "")
    {
        oPanel.SetClipVisibility(m_sMapButton1Path, TRUE);
    }
    else
    {
        oPanel.SetClipVisibility(m_sMapButton1Path, FALSE);
    }
    oPanel.SetTextFieldText(m_sMapText2Path, sText2);
    if (sText2 != "")
    {
        oPanel.SetClipVisibility(m_sMapButton2Path, TRUE);
    }
    else
    {
        oPanel.SetClipVisibility(m_sMapButton2Path, FALSE);
    }
    oPanel.SetTextFieldText(m_sMapText3Path, sText3);
    if (sText3 != "")
    {
        oPanel.SetClipVisibility(m_sMapButton3Path, TRUE);
    }
    else
    {
        oPanel.SetClipVisibility(m_sMapButton3Path, FALSE);
    }
}
public final native function SetupPlayerPowers();

public final event function SetupWeaponDisplayForPawn(BioPawn pPawn, SFXPowerWheelPawnID ePawn)
{
    local SFXWeapon pWeap;
    local int nWeaponSlot;
    local array<int> aIconIndices;
    local int nSlotIndex;
    local string sBlockingLabel;
    local bool bImmediateOrder;
    local bool bQueuedOrder;
    local string sBlockerClipPath;
    local bool bNoWeapons;
    local array<SFXWeapon> aWeapons;
    local int nWeap;
    
    bNoWeapons = FALSE;
    if (pPawn == None || SFXInventoryManager(pPawn.InvManager) == None)
    {
        bNoWeapons = TRUE;
    }
    switch (ePawn)
    {
        case SFXPowerWheelPawnID.PWPID_Player:
            aIconIndices = m_oWeaponIndices.aPlayer;
            sBlockerClipPath = m_sShepardBlockerPath;
            break;
        case SFXPowerWheelPawnID.PWPID_Hench1:
            aIconIndices = m_oWeaponIndices.aHench1;
            sBlockerClipPath = m_sHench1BlockerPath;
            break;
        case SFXPowerWheelPawnID.PWPID_Hench2:
            aIconIndices = m_oWeaponIndices.aHench2;
            sBlockerClipPath = m_sHench2BlockerPath;
            break;
        default:
    }
    sBlockingLabel = "";
    nWeaponSlot = 0;
    if (!bNoWeapons)
    {
        foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pWeap)
        {
            if (SFXHeavyWeapon(pWeap) != None)
            {
                continue;
            }
            aWeapons[aWeapons.Length] = pWeap;
        }
        SortWeapons(pPawn, aWeapons);
        for (nWeap = 0; nWeap < aWeapons.Length; ++nWeap)
        {
            pWeap = aWeapons[nWeap];
            if (nWeaponSlot >= aIconIndices.Length)
            {
                break;
            }
            nSlotIndex = aIconIndices[nWeaponSlot];
            SetWeaponIcon(pWeap, nSlotIndex, pPawn);
            ++nWeaponSlot;
        }
        if (pPawn.Physics == EPhysics.PHYS_RigidBody)
        {
            sBlockingLabel = string(m_srPawnIncapacitated);
        }
        bImmediateOrder = CanIssueImmediateOrder(pPawn);
        bQueuedOrder = CanIssueQueuedOrder(pPawn);
        if (bImmediateOrder == FALSE && bQueuedOrder == FALSE)
        {
            for (sBlockingLabel = string(m_srBlocked); nWeaponSlot < aIconIndices.Length; ++nWeaponSlot)
            {
                nSlotIndex = aIconIndices[nWeaponSlot];
                SetWeaponType(nSlotIndex, "", 0);
            }
            if (sBlockingLabel != "")
            {
                for (nWeaponSlot = 0; nWeaponSlot < aIconIndices.Length; ++nWeaponSlot)
                {
                    SetWeaponState(aIconIndices[nWeaponSlot], 2);
                }
                if (m_bVisible)
                {
                    oPanel.SetClipVisibility(sBlockerClipPath, TRUE);
                    oPanel.SetTextFieldText(sBlockerClipPath $ ".txtBlocker", sBlockingLabel);
                }
            }
            else
            {
                oPanel.SetClipVisibility(sBlockerClipPath, FALSE);
                oPanel.SetTextFieldText(sBlockerClipPath $ ".txtBlocker", "");
            }
            return;
        }
    }
}
public event function SetUseText(string sText)
{
    if (!m_bShowUseMapText)
    {
        return;
    }
    oPanel.SetTextFieldText(m_sUseTextPath, sText);
    if (sText != "")
    {
        oPanel.SetClipVisibility(m_sUseButtonPath, TRUE);
    }
    else
    {
        oPanel.SetClipVisibility(m_sUseButtonPath, FALSE);
    }
}
public event function SetWeaponState(int nWeapIndex, SFXPowerWheelWeaponState eNewWeapState)
{
    local array<ASParams> aParams;
    local SFXPowerWheelIconWeapon oIcon;
    
    if (nWeapIndex < 0 || nWeapIndex >= m_aWeaponIcons.Length)
    {
        return;
    }
    oIcon = m_aWeaponIcons[nWeapIndex];
    if (oIcon.nWeaponIcon == 0)
    {
        return;
    }
    if (int(eNewWeapState) == int(oIcon.eWeaponState))
    {
        return;
    }
    if (eNewWeapState == SFXPowerWheelWeaponState.PWWS_Selected)
    {
        if (m_aWeaponIcons[nWeapIndex].bEquipped != TRUE)
        {
            SelectWeapon(nWeapIndex);
        }
    }
    else if (eNewWeapState != SFXPowerWheelWeaponState.PWWS_Hover || oIcon.eWeaponState != SFXPowerWheelWeaponState.PWWS_Selected)
    {
        m_aWeaponIcons[nWeapIndex].bEquipped = FALSE;
    }
    aParams.Length = 1;
    aParams[0].Type = ASParamTypes.ASParam_Integer;
    aParams[0].nVar = m_aWeaponStateFrames[int(eNewWeapState)];
    oPanel.InvokeMethodArgs(oIcon.sPath $ ".SetFrame", aParams);
    m_aWeaponIcons[nWeapIndex].eWeaponState = eNewWeapState;
}
public final event function SetWeaponType(int nWeapIndex, string sWeaponIconResource, int nNewWeapIcon)
{
    local SFXPowerWheelIconWeapon oIcon;
    
    if (nWeapIndex < 0 || nWeapIndex >= m_aWeaponIcons.Length)
    {
        return;
    }
    if (nNewWeapIcon == 0)
    {
        m_aWeaponIcons[nWeapIndex].nAmmo = 0;
        m_aWeaponIcons[nWeapIndex].sName = "";
        m_aWeaponIcons[nWeapIndex].sPawnName = "";
        m_aWeaponIcons[nWeapIndex].sDescription = "";
        m_aWeaponIcons[nWeapIndex].bEquipped = FALSE;
        m_aWeaponIcons[nWeapIndex].oWeaponClass = None;
        m_aWeaponIcons[nWeapIndex].sIconResource = "";
    }
    oIcon = m_aWeaponIcons[nWeapIndex];
    if (nNewWeapIcon != oIcon.nWeaponIcon)
    {
        SetWeaponTypeDisplay(oPanel, oIcon.oIconMC, oIcon.sIconResource, nNewWeapIcon);
    }
    m_aWeaponIcons[nWeapIndex].nWeaponIcon = nNewWeapIcon;
    oIcon = m_aWeaponIcons[nWeapIndex];
    UpdateWeaponIconDisplay(oIcon);
}
public final native function SetWheelVisible(bool bVisible);

public final event function UpdatePowerInformationText(SFXGUIValue_PowerIcon oIcon)
{
    local string sDescriptionText;
    local string sEvaluationText;
    local bool bGoodEval;
    local bool bNuiSpeechEnabled;
    local string sName;
    
    bGoodEval = oIcon.EvaluateForTarget(m_pCurrentPlayerSelection, sEvaluationText);
    if (sEvaluationText != "")
    {
        if (!bGoodEval)
        {
            sDescriptionText = m_sNotSuggestedPrefix $ sEvaluationText $ m_sNotSuggestedSuffix $ "\n";
        }
        else
        {
            sDescriptionText = sEvaluationText $ "\n";
        }
    }
    sDescriptionText = sDescriptionText $ oIcon.sDescription;
    bNuiSpeechEnabled = IsNuiSpeechEnabled();
    if (bNuiSpeechEnabled && oIcon.sName != "" && oIcon.pPawn.IsA('SFXPawn_Henchman'))
    {
        sName = GetNuiPawnCommandString(oIcon.pPawn.GetActorGameName(), oIcon.sName);
    }
    else
    {
        sName = oIcon.sName;
    }
    SetInformationText(sName, sDescriptionText, bNuiSpeechEnabled);
}
public final event function UpdateRadarArrows()
{
    local float fTargetDirection;
    local float fNorthDirection;
    local float fPathDirection;
    
    GetRadarDirectionValues(fTargetDirection, fNorthDirection, fPathDirection);
    if (m_pPlayerController.m_bRadarArrow != FALSE)
    {
        if (Abs(fTargetDirection - m_fCacheTargetDirection) > m_fRadarDirectionChangeDelta)
        {
            oPanel.SetClipVisibility(m_sRadarPath $ ".DirectionIndicator", TRUE);
            oPanel.SetVariableFloat(m_sRadarPath $ ".DirectionIndicator._rotation", fTargetDirection);
            m_fCacheTargetDirection = fTargetDirection;
        }
    }
    else
    {
        oPanel.SetClipVisibility(m_sRadarPath $ ".DirectionIndicator", FALSE);
    }
    if (Abs(fNorthDirection - m_fCacheNorthDirection) > m_fRadarDirectionChangeDelta)
    {
        oPanel.SetVariableFloat(m_sRadarPath $ ".NorthIndicator._rotation", fNorthDirection);
        m_fCacheNorthDirection = fNorthDirection;
    }
    if (m_bHavePathAssistGoal)
    {
        if (Abs(fPathDirection - m_fCachePathDirection) > m_fRadarDirectionChangeDelta)
        {
            oPanel.SetClipVisibility(m_sRadarPath $ ".PathIndicator", TRUE);
            oPanel.SetVariableFloat(m_sRadarPath $ ".PathIndicator._rotation", fPathDirection);
            m_fCachePathDirection = fPathDirection;
        }
    }
    else
    {
        oPanel.SetClipVisibility(m_sRadarPath $ ".PathIndicator", FALSE);
    }
}
public final event function UpdateRadarDisplay(bool bObjectiveMode)
{
    local bool bInVehicle;
    local array<ASParams> aParams;
    local string sElementPath;
    local int nElement;
    local SFXRadarElementData oTempData;
    local string sTemp;
    local int nTemp;
    
    oPanel.InvokeMethod("ClearRadar");
    if (!bObjectiveMode)
    {
        if (m_pPlayerController != None)
        {
            m_pPlayerController.RefreshRadarData();
            bInVehicle = m_pPlayerController.GameModeManager2.IsActive(1);
        }
        else
        {
            bInVehicle = FALSE;
        }
    }
    if (!bObjectiveMode)
    {
        oPanel.SetTextFieldText(m_sRadarPath $ ".txtRange", int(m_pPlayerController.GetRadarRange() * 0.00999999978) $ m_srRadarRangeUnits);
    }
    else
    {
        oPanel.SetTextFieldText(m_sRadarPath $ ".txtRange", "");
    }
    if (m_pPlayerController.m_bRadarIsJammed != FALSE)
    {
        oPanel.SetClipVisibility(m_sRadarPath $ ".FOV1", FALSE);
        oPanel.SetClipVisibility(m_sRadarPath $ ".FOV2", FALSE);
        oPanel.SetClipVisibility(m_sRadarPath $ ".TeamLock", FALSE);
        oPanel.GotoLabelAndStop(m_sRadarPath $ ".Background", "jammed");
        oPanel.GotoFrameAndPlay(m_sRadarPath $ ".Background.Jammed", 2);
    }
    else
    {
        if (!bInVehicle)
        {
            if (bObjectiveMode)
            {
                sTemp = "objective";
            }
            else
            {
                sTemp = "hud";
            }
        }
        else
        {
            sTemp = "mako";
        }
        oPanel.GotoLabelAndStop(m_sRadarPath $ ".Background", sTemp);
        oPanel.SetVariableFloat(m_sRadarPath $ ".FOV1._rotation", -m_pPlayerController.GetRadarFOV());
        oPanel.SetVariableFloat(m_sRadarPath $ ".FOV2._rotation", m_pPlayerController.GetRadarFOV());
        oPanel.SetClipVisibility(m_sRadarPath $ ".FOV1", bObjectiveMode == FALSE);
        oPanel.SetClipVisibility(m_sRadarPath $ ".FOV2", bObjectiveMode == FALSE);
        oPanel.SetClipVisibility(m_sRadarPath $ ".TeamLock", bObjectiveMode == FALSE);
        if (!bObjectiveMode)
        {
            CollectRadarElementData(m_aRadarElementData);
            aParams.Length = 1;
            aParams[0].Type = ASParamTypes.ASParam_Integer;
            aParams[0].nVar = m_aRadarElementData.Length;
            oPanel.InvokeMethodArgs("InitRadarElements", aParams);
            for (nElement = 0; nElement < m_aRadarElementData.Length; ++nElement)
            {
                sElementPath = m_sRadarPath $ ".Elements.RadarElement" $ nElement;
                oTempData = m_aRadarElementData[nElement];
                sTemp = m_aRadarIconFramePaths[int(oTempData.eRadarType) - 1];
                if (oTempData.eRadarType == EBioRadarType.BRT_Pawn_Friendly || oTempData.eRadarType == EBioRadarType.BRT_Pawn_Neutral || oTempData.eRadarType == EBioRadarType.BRT_Pawn_Hostile)
                {
                    if (oTempData.nSize == 0)
                    {
                        sTemp = sTemp $ "Small";
                    }
                    else if (oTempData.nSize == 1)
                    {
                        sTemp = sTemp $ "Medium";
                    }
                    else
                    {
                        sTemp = sTemp $ "Large";
                    }
                }
                if (oTempData.eRadarType != EBioRadarType.BRT_Pawn_Friendly && oTempData.eRadarType != EBioRadarType.BRT_Pawn_Neutral)
                {
                    if (oTempData.eRadarType == EBioRadarType.BRT_Pawn_Hostile && oTempData.nSize == 1)
                    {
                        oPanel.SetClipVisibility(sElementPath, FALSE);
                        continue;
                    }
                    else
                    {
                        oPanel.SetClipVisibility(sElementPath, TRUE);
                    }
                    oPanel.GotoLabelAndStop(sElementPath, sTemp);
                    oPanel.GotoFrameAndStop(sElementPath $ ".subElementMC", 1);
                    nTemp = int(oTempData.vPosition.Z * float(100));
                    if (nTemp < 0)
                    {
                        nTemp = -nTemp;
                    }
                    oPanel.GotoFrameAndStop(sElementPath $ ".subElementMC.altitudeMC", nTemp + 1);
                    nTemp = 1;
                    if (oTempData.nRelativeZ == -1)
                    {
                        nTemp = 2;
                    }
                    else if (oTempData.nRelativeZ == 1)
                    {
                        nTemp = 3;
                    }
                    oPanel.GotoFrameAndStop(sElementPath $ ".charHeight", nTemp);
                    continue;
                }
                oPanel.SetClipVisibility(sElementPath, FALSE);
            }
            UpdateRadarElementPositions(m_aRadarElementData);
            oPanel.SetVariableString("g_sRadarText", "");
        }
        else
        {
            oPanel.SetVariableString("g_sRadarText", m_bHavePathAssistGoal ? string(m_srObjective) : "");
        }
        m_fCacheTargetDirection = 999.0;
        m_fCacheNorthDirection = 999.0;
        m_fCachePathDirection = 999.0;
        UpdateRadarArrows();
        if (m_bHavePathAssistGoal != FALSE && m_bPingPathAssistArrow != FALSE)
        {
            oPanel.GotoLabelAndPlay(m_sRadarPath $ ".PathIndicator.CompassMC.ArrowBurstMC", "start");
            m_bPingPathAssistArrow = FALSE;
        }
        UpdateRadarMapBoundaries();
    }
}
public final event function UpdateRadarElementPositions(out array<SFXRadarElementData> aRadarData)
{
    local int nElement;
    local SFXRadarElementData oTempData;
    local string sPath;
    
    for (nElement = 0; nElement < aRadarData.Length; ++nElement)
    {
        sPath = m_sRadarPath $ ".Elements.RadarElement" $ nElement;
        oTempData = aRadarData[nElement];
        if (oTempData.bUpdate != FALSE)
        {
            oPanel.SetClipLocation(sPath, oTempData.vPosition.X * m_fRadarRadius, oTempData.vPosition.Y * m_fRadarRadius);
            aRadarData[nElement].bUpdate = FALSE;
        }
        if (oTempData.bUpdateLock != FALSE)
        {
            if (oTempData.bLocked != FALSE)
            {
                oPanel.GotoLabelAndPlay(sPath $ ".lockMC", "start");
            }
            else
            {
                oPanel.GotoFrameAndStop(sPath $ ".lockMC", 1);
            }
            aRadarData[nElement].bUpdateLock = FALSE;
        }
    }
}
public final event function UpdateRadarMapBoundaries()
{
    local Vector2D vTopLeft;
    local Vector2D vBottomRight;
    local float fBoundaryRotation;
    local Vector2D vDimensions;
    local Vector2D vScale;
    local Vector2D vTopLine;
    
    if (GetMapBoundaryValues(vTopLeft, vBottomRight, fBoundaryRotation) != FALSE)
    {
        vDimensions.X = vBottomRight.X + vTopLeft.X;
        vDimensions.Y = vBottomRight.Y + vTopLeft.Y;
        vScale.X = vDimensions.X * (float(1) / m_vBoundaryDimensions.X);
        vScale.Y = vDimensions.Y * (float(1) / m_vBoundaryDimensions.Y);
        oPanel.SetVariableFloat(m_sRadarPath $ ".Elements.ElementsBoundary.boundaryMC._xscale", vScale.X);
        oPanel.SetVariableFloat(m_sRadarPath $ ".Elements.ElementsBoundary.boundaryMC._yscale", vScale.Y);
        vTopLine.X = vScale.X * m_fBoundaryShrinkFactor;
        vTopLine.Y = vScale.Y * m_fBoundaryShrinkFactor;
        vTopLine.X -= vTopLeft.X;
        vTopLine.Y -= vTopLeft.Y;
        oPanel.SetClipLocation(m_sRadarPath $ ".Elements.ElementsBoundary.boundaryMC", vTopLine.X, vTopLine.Y);
        oPanel.SetVariableFloat(m_sRadarPath $ ".Elements.ElementsBoundary.boundaryMC._rotation", fBoundaryRotation);
        m_vCacheRadarBoundaryTopLeft = vTopLeft;
        m_vCacheRadarBoundaryBottomRight = vBottomRight;
        m_fCacheRadarBoundaryRotation = fBoundaryRotation;
    }
}
public final event function UpdateTextDisplayForIcon(int nIconIndex)
{
    local SFXGUIValue_PowerIcon oIcon;
    local string sUseText;
    local string sMap1Text;
    local string sMap2Text;
    local string sMap3Text;
    local string sIcon1Token;
    local string sIcon2Token;
    local string sIcon3Token;
    local SFXPowerWheelMapButtonIcon eIcon1;
    local SFXPowerWheelMapButtonIcon eIcon2;
    local SFXPowerWheelMapButtonIcon eIcon3;
    
    if (nIconIndex < 0 || nIconIndex >= m_aPowerIcons.Length)
    {
        return;
    }
    oIcon = m_aPowerIcons[nIconIndex];
    if (m_oPowerIndices.aPlayer.Find(nIconIndex) != -1)
    {
        sIcon1Token = m_sMap1Token;
        sIcon2Token = m_sMap2Token;
        sIcon3Token = m_sMap3Token;
        eIcon1 = SFXPowerWheelMapButtonIcon.PWBI_ShoulderLeft;
        eIcon2 = SFXPowerWheelMapButtonIcon.PWBI_ShoulderRight;
        eIcon3 = SFXPowerWheelMapButtonIcon.PWBI_FaceButtonTop;
        if (oIcon.oMappedIcon.eIcon == SFXPowerWheelMapButtonIcon.PWBI_ShoulderLeft)
        {
            sIcon1Token = "";
            eIcon1 = SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE;
        }
        else if (oIcon.oMappedIcon.eIcon == SFXPowerWheelMapButtonIcon.PWBI_ShoulderRight)
        {
            sIcon2Token = "";
            eIcon2 = SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE;
        }
        else if (oIcon.oMappedIcon.eIcon == SFXPowerWheelMapButtonIcon.PWBI_FaceButtonTop)
        {
            sIcon3Token = "";
            eIcon3 = SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE;
        }
    }
    else if (GetHenchmanMappedPower(oIcon.pPawn) != oIcon.nmPowerName)
    {
        if (oIcon.pPawn == m_pHench1Pawn)
        {
            sIcon1Token = m_sMapHench1Token;
            eIcon1 = SFXPowerWheelMapButtonIcon.PWBI_DPadLeft;
        }
        else
        {
            sIcon1Token = m_sMapHench2Token;
            eIcon1 = SFXPowerWheelMapButtonIcon.PWBI_DPadRight;
        }
    }
    sUseText = "";
    sMap1Text = "";
    sMap2Text = "";
    sMap3Text = "";
    if (oIcon.eState != SFXPowerWheelPowerState.PWPS_EmptySelectable && oIcon.eState != SFXPowerWheelPowerState.PWPS_EmptySelected)
    {
        if (oIcon.eState != SFXPowerWheelPowerState.PWPS_Activated && oIcon.eState != SFXPowerWheelPowerState.PWPS_Overload)
        {
            SetCustomToken(0, oIcon.sName);
            sUseText = GetUIString(m_srUse, TRUE);
            ClearCustomTokens();
        }
        if (eIcon1 != SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE)
        {
            SetCustomToken(0, oIcon.sName);
            SetCustomToken(1, sIcon1Token);
            sMap1Text = GetUIString(m_srMap, TRUE);
            ClearCustomTokens();
        }
        if (eIcon2 != SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE)
        {
            SetCustomToken(0, oIcon.sName);
            SetCustomToken(1, sIcon2Token);
            sMap2Text = GetUIString(m_srMap, TRUE);
            ClearCustomTokens();
        }
        if (eIcon3 != SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE)
        {
            SetCustomToken(0, oIcon.sName);
            SetCustomToken(1, sIcon3Token);
            sMap3Text = GetUIString(m_srMap, TRUE);
            ClearCustomTokens();
        }
    }
    SetUseText(sUseText);
    SetMapText(sMap1Text, eIcon1, sMap2Text, eIcon2, sMap3Text, eIcon3);
    UpdatePowerInformationText(oIcon);
}
public final event function UpdateWeaponIconDisplay(SFXPowerWheelIconWeapon oIcon, optional string sAltPath = "")
{
    local string sAmmoCount;
    local string sPath;
    
    sPath = oIcon.sPath;
    if (sAltPath != "")
    {
        sPath = sAltPath;
    }
    sAmmoCount = "";
    if (oIcon.bHenchIcon == FALSE)
    {
        if (oIcon.nAmmo != -1 && oIcon.nWeaponIcon != 0)
        {
            sAmmoCount = string(oIcon.nAmmo);
        }
    }
    oPanel.SetTextFieldText(sPath $ ".txtAmmo", sAmmoCount);
}
public final event function UsePower(Name PowerName, Pawn Pawn)
{
    m_pPlayerController.GetGameModeDefault().UsePower(PowerName, SFXPawn(Pawn));
}
public final delegate function int WeaponSort(SFXWeapon A, SFXWeapon B)
{
    return B.GUIWeaponOrder - A.GUIWeaponOrder;
}
public event function WheelVisibilityChanged(bool bVisible)
{
    local int nIcon;
    local bool bPowerWheel;
    local bool bWeaponWheel;
    local GFxValue oWheel;
    
    if (!bVisible)
    {
        if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Weapons || m_ePowerWheelMode == SFXPowerWheelMode.PWM_PC)
        {
            LeaveWeaponIcon(m_nCurrentWeaponIconIndex);
            for (nIcon = 0; nIcon < m_aWeaponIcons.Length; ++nIcon)
            {
                oPanel.SetClipVisibility(m_aWeaponIcons[nIcon].sPath, FALSE);
            }
        }
        if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers || m_ePowerWheelMode == SFXPowerWheelMode.PWM_PC)
        {
            LeavePowerIcon(m_nCurrentPowerIconIndex, TRUE);
            for (nIcon = 0; nIcon < m_aPowerIcons.Length; ++nIcon)
            {
                m_aPowerIcons[nIcon].SetSelected(FALSE);
                m_aPowerIcons[nIcon].Hide();
            }
        }
        AS_ShowWheel(FALSE);
        m_bInOutTransition = TRUE;
        m_fLastProcessedStickAngle = -1.0;
        oPanel.SetClipVisibility(m_sTitleTextPath, FALSE);
        SetInformationText("", "", FALSE);
        SetUseText("");
        SetMapText("", 0, "", 0, "", 0);
        oPanel.SetClipVisibility(m_sShepardBlockerPath, FALSE);
        oPanel.SetClipVisibility(m_sHench1BlockerPath, FALSE);
        oPanel.SetClipVisibility(m_sHench2BlockerPath, FALSE);
        SetStatusAndPowerText(None, 1);
        SetStatusAndPowerText(None, 2);
        BioHintSystem(m_pPlayerController.HintSystem).HintEvent('ClearTutorialHint');
        if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Weapons)
        {
            m_pPlayerController.GenerateTutorialEvent(7);
        }
        else if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers)
        {
            m_pPlayerController.GenerateTutorialEvent(9);
        }
    }
    else
    {
        if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Weapons || m_ePowerWheelMode == SFXPowerWheelMode.PWM_PC)
        {
            bWeaponWheel = TRUE;
            for (nIcon = 0; nIcon < m_aWeaponIcons.Length; ++nIcon)
            {
                if (SFXGRI(oWorldInfo.GRI).bCanSpawnHenchmen || !m_aWeaponIcons[nIcon].bHenchIcon)
                {
                    oPanel.SetClipVisibility(m_aWeaponIcons[nIcon].sPath, TRUE);
                }
            }
        }
        if (m_ePowerWheelMode == SFXPowerWheelMode.PWM_Powers || m_ePowerWheelMode == SFXPowerWheelMode.PWM_PC)
        {
            bPowerWheel = TRUE;
            for (nIcon = 0; nIcon < m_aPowerIcons.Length; ++nIcon)
            {
                if (SFXGRI(oWorldInfo.GRI).bCanSpawnHenchmen || !m_aPowerIcons[nIcon].bHenchIcon)
                {
                    m_aPowerIcons[nIcon].SetVisible(TRUE);
                }
            }
        }
        SetSquadPawnDisplay(m_sHench1PortraitImagePath, m_sHench1PortraitMovieClipPath, m_pHench1Pawn);
        SetSquadPawnDisplay(m_sHench2PortraitImagePath, m_sHench2PortraitMovieClipPath, m_pHench2Pawn);
        AS_ShowWheel(TRUE);
        oPanel.SetClipVisibility(m_sTitleTextPath, TRUE);
        if (SFXGRI(oWorldInfo.GRI).bCanSpawnHenchmen)
        {
            SetStatusAndPowerText(m_pHench1Pawn, 1);
            SetStatusAndPowerText(m_pHench2Pawn, 2);
        }
        if (HaveHenchmen() == FALSE)
        {
            oWheel = GetVariableObject(m_sWheelInnerPath);
            if (oWheel != None)
            {
                oWheel.GotoAndStop("MP");
            }
        }
        BioHintSystem(m_pPlayerController.HintSystem).GeneratePowerWheelTutorialHint(bPowerWheel, bWeaponWheel);
    }
}
public final function AS_ShowWheel(bool bMakeVisible)
{
    ActionScriptVoid("ShowWheel");
}
public function CleanupReferences()
{
    local int nIcon;
    
    m_pPlayerController = None;
    m_pPlayerSquad = None;
    m_pShepardPawn = None;
    m_pHench1Pawn = None;
    m_pHench2Pawn = None;
    m_pCurrentPlayerSelection = None;
    for (nIcon = 0; nIcon < m_aPowerIcons.Length; ++nIcon)
    {
        m_aPowerIcons[nIcon].Cleanup();
        m_aPowerIcons[nIcon] = None;
    }
}
public final function ExInt_WheelTransitionOutDone()
{
    m_ePowerWheelMode = SFXPowerWheelMode.PWM_NONE;
    m_bInOutTransition = FALSE;
}
public static function HideWeaponIcon(SFXGUIMovieLegacyAdapter pPanel, GFxValue Icon)
{
    Icon.SetVisible(FALSE);
    Icon.SetMemberObjectText("txtAmmo", "");
}
public function InitPowerIcons()
{
    local SFXGUIValue_PowerIcon oIcon;
    local int N;
    
    for (N = 0; N < m_aPowerIconInfo.Length; ++N)
    {
        oIcon = SFXGUIValue_PowerIcon(GetVariableObject(m_aPowerIconInfo[N].Path, Class'SFXGUIValue_PowerIcon'));
        if (oIcon != None)
        {
            oIcon.sPath = m_aPowerIconInfo[N].Path;
            oIcon.fBoundary = m_aPowerIconInfo[N].Boundary;
            oIcon.bHenchIcon = m_aPowerIconInfo[N].IsHenchmanIcon;
            oIcon.oMappedIcon.sPath = m_aPowerIconInfo[N].MappedIconPath;
            oIcon.sMappedBGPath = m_aPowerIconInfo[N].MappedIconBGPath;
            oIcon.sID = m_aPowerIconInfo[N].Id;
            oIcon.ClearIcon();
            oIcon.bDirty = TRUE;
            oIcon.UpdateDisplay();
            m_aPowerIcons.AddItem(oIcon);
            continue;
        }
    }
}
public final function bool IsPawnBlocked(BioPawn pPawn)
{
    if (pPawn == None)
    {
        return FALSE;
    }
    if (pPawn.Physics == EPhysics.PHYS_RigidBody)
    {
        return TRUE;
    }
    if (CanIssueImmediateOrder(pPawn) == FALSE && CanIssueQueuedOrder(pPawn) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
public function OnAllowCameraRotation(bool i_bValue);

public final function SelectCurrentWeapon()
{
    local SFXPowerWheelIconWeapon oWeaponIcon;
    local BioPawn pPawn;
    local SFXWeapon pWeapon;
    local SFXInventoryManager pInvManager;
    local array<int> aIconIndices;
    local int nIcon;
    
    if (m_nCurrentWeaponIconIndex < 0 || m_nCurrentWeaponIconIndex >= m_aWeaponIcons.Length)
    {
        PlayGuiSound('GuiError');
        return;
    }
    oWeaponIcon = m_aWeaponIcons[m_nCurrentWeaponIconIndex];
    if (oWeaponIcon.eWeaponState == SFXPowerWheelWeaponState.PWWS_Disabled || oWeaponIcon.nWeaponIcon == 0 || oWeaponIcon.nWeaponIcon == 1)
    {
        PlayGuiSound('GuiError');
        return;
    }
    if (m_pPlayerController != None && m_pPlayerController.bMultiplayerCommandMode)
    {
        pPawn = m_pPlayerController.GetBioPawn();
        aIconIndices = m_oWeaponIndices.aPlayer;
    }
    else if (m_oWeaponIndices.aPlayer.Find(m_nCurrentWeaponIconIndex) != -1)
    {
        pPawn = m_pShepardPawn;
        aIconIndices = m_oWeaponIndices.aPlayer;
    }
    else if (m_oWeaponIndices.aHench1.Find(m_nCurrentWeaponIconIndex) != -1)
    {
        pPawn = m_pHench1Pawn;
        aIconIndices = m_oWeaponIndices.aHench1;
    }
    else if (m_oWeaponIndices.aHench2.Find(m_nCurrentWeaponIconIndex) != -1)
    {
        pPawn = m_pHench2Pawn;
        aIconIndices = m_oWeaponIndices.aHench2;
    }
    if (pPawn == None)
    {
        PlayGuiSound('GuiError');
        return;
    }
    pInvManager = SFXInventoryManager(pPawn.InvManager);
    if (pInvManager != None)
    {
        foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pWeapon)
        {
            if (pWeapon.Class == oWeaponIcon.oWeaponClass)
            {
                pInvManager.CurrentWeaponSelection = pWeapon.Class;
                m_pPlayerController.OrderWeaponSwitch(pPawn, pWeapon);
                PlayGuiSound('HUDPowerWheelQueueingHighlightedPowerForActivation');
                for (nIcon = 0; nIcon < aIconIndices.Length; ++nIcon)
                {
                    if (m_aWeaponIcons[aIconIndices[nIcon]].bEquipped == TRUE)
                    {
                        SetWeaponState(aIconIndices[nIcon], 0);
                        break;
                    }
                }
                SetWeaponState(m_nCurrentWeaponIconIndex, 3);
                break;
            }
        }
    }
}
public final function SelectCurrentWheelItem(SFXPowerWheelMode eMode)
{
    if (eMode == SFXPowerWheelMode.PWM_Weapons)
    {
        SelectCurrentWeapon();
    }
    else if (eMode == SFXPowerWheelMode.PWM_Powers)
    {
        SelectCurrentPower();
    }
}
public function SelectWeapon(int nWeaponIndex)
{
    if (nWeaponIndex < 0 || nWeaponIndex >= m_aWeaponIcons.Length)
    {
        return;
    }
    m_aWeaponIcons[nWeaponIndex].bEquipped = TRUE;
    m_nCurrentSelectedWeapon = m_aWeaponIcons[nWeaponIndex].nWeaponIcon;
}
public final function SetInformationText(string sName, string sDesc, bool bDisplayNuiSpeechIcon)
{
    if (sName != "")
    {
        SetTextFieldText(m_sNameTextPath, sName);
        SetClipVisibility(m_sNameTextPath, TRUE);
        SetClipVisibility(m_sNuiSpeechIconPath, bDisplayNuiSpeechIcon);
    }
    else
    {
        SetClipVisibility(m_sNameTextPath, FALSE);
        SetTextFieldText(m_sNameTextPath, "");
        SetClipVisibility(m_sNuiSpeechIconPath, FALSE);
    }
    if (sDesc != "")
    {
        SetTextFieldText(m_sInfoTextPath, sDesc, TRUE);
        SetClipVisibility(m_sInfoTextPath, TRUE);
        if (!m_bDesiredInfoTextBackgroundVisibility)
        {
            m_bDesiredInfoTextBackgroundVisibility = TRUE;
            m_fRemainingInfoTextChangeDelay = m_fInfoTextChangeDelay;
        }
    }
    else
    {
        SetClipVisibility(m_sInfoTextPath, FALSE);
        SetTextFieldText(m_sInfoTextPath, "");
        if (m_bDesiredInfoTextBackgroundVisibility)
        {
            m_bDesiredInfoTextBackgroundVisibility = FALSE;
            m_fRemainingInfoTextChangeDelay = m_fInfoTextChangeDelay;
        }
    }
}
public final function SetSquadPawnDisplay(string sPortraitImagePath, string sPortraitMovieClipPath, BioPawn HenchPawn)
{
    local Texture2D oIcon;
    local SFXModule_Damage pDamageMod;
    local bool bIsDead;
    
    if (sPortraitImagePath == "")
    {
        return;
    }
    SetVariableString(sPortraitImagePath, "");
    if (HenchPawn != None)
    {
        pDamageMod = HenchPawn.GetModule(Class'SFXModule_Damage');
        if (pDamageMod != None)
        {
            bIsDead = pDamageMod.GetCurrentHealth() == float(0);
        }
        oIcon = HenchPawn.GetGUIIcon();
        if (oIcon != None)
        {
            SetVariableString(sPortraitImagePath, PathName(oIcon));
        }
        if (bIsDead)
        {
            GotoLabelAndStop(sPortraitMovieClipPath, "DEAD");
        }
        else if (CanIssueImmediateOrder(HenchPawn) == FALSE && CanIssueQueuedOrder(HenchPawn) == FALSE)
        {
            GotoLabelAndStop(sPortraitMovieClipPath, "BUSY");
        }
        else
        {
            GotoFrameAndStop(sPortraitMovieClipPath, 1);
        }
    }
}
public final function SetStatusAndPowerText(BioPawn pPawn, SFXPowerWheelPawnID ePawnID)
{
    local int nStatusFlags;
    local string sStatus;
    local string sPowerStatus;
    local string sStatusPath;
    local string sPowerPath;
    local SFXPowerCustomActionBase Power;
    local int Index;
    
    switch (ePawnID)
    {
        case SFXPowerWheelPawnID.PWPID_Hench1:
            sStatusPath = m_sTeam1StatusTextPath;
            sPowerPath = m_sTeam1PowerTextPath;
            break;
        case SFXPowerWheelPawnID.PWPID_Hench2:
            sStatusPath = m_sTeam2StatusTextPath;
            sPowerPath = m_sTeam2PowerTextPath;
            break;
        default:
            return;
    }
    sStatus = "";
    sPowerStatus = "";
    if (pPawn != None)
    {
        nStatusFlags = Class'SFXSFHandler_HUD'.static.GetTargetStatusFlags(pPawn);
        sStatus = Class'SFXSFHandler_HUD'.static.GetStatusText(pPawn, nStatusFlags);
        if (pPawn.PowerManager != None)
        {
            for (Index = 0; Index < pPawn.PowerManager.Powers.Length; Index++)
            {
                Power = pPawn.PowerManager.Powers[Index];
                if (Power != None && Power.UsesSharedCooldown && Power.CurrentCooldownTime > 0.00999999978)
                {
                    sPowerStatus = string(m_srRecharging);
                    break;
                }
            }
        }
    }
    oPanel.SetClipVisibility(sStatusPath, sStatus != "");
    oPanel.SetTextFieldText(sStatusPath, sStatus);
    oPanel.SetClipVisibility(sPowerPath, sPowerStatus != "");
    oPanel.SetTextFieldText(sPowerPath, sPowerStatus);
}
public final function SetWeaponIcon(SFXWeapon pWeap, int nSlotIndex, BioPawn pPawn)
{
    if (nSlotIndex < 0 || nSlotIndex > m_aWeaponIcons.Length)
    {
        return;
    }
    m_aWeaponIcons[nSlotIndex].sName = pWeap.GetPrettyName(int(pWeap.WeaponLevel + float(1)));
    m_aWeaponIcons[nSlotIndex].sPawnName = pPawn.GetActorGameName();
    m_aWeaponIcons[nSlotIndex].sDescription = pWeap.GetShortDescription();
    m_aWeaponIcons[nSlotIndex].oWeaponClass = pWeap.Class;
    m_aWeaponIcons[nSlotIndex].nAmmo = pWeap.GetCurrentTotalAmmo();
    m_aWeaponIcons[nSlotIndex].bEquipped = FALSE;
    m_aWeaponIcons[nSlotIndex].sIconResource = PathName(pWeap.IconResource);
    SetWeaponState(nSlotIndex, 0);
    SetWeaponType(nSlotIndex, PathName(pWeap.IconResource), pWeap.IconRef);
    if (pWeap == pPawn.Weapon)
    {
        SetWeaponState(nSlotIndex, 3);
    }
}
public static function SetWeaponTypeDisplay(SFXGUIMovieLegacyAdapter pPanel, GFxValue oIcon, string sIconResource, int nNewType)
{
    local array<ASValue> aParams;
    
    aParams.Length = 2;
    aParams[0].Type = ASType.AS_String;
    aParams[0].S = sIconResource;
    aParams[1].Type = ASType.AS_Number;
    aParams[1].N = float(nNewType);
    oIcon.Invoke("SetIcon", aParams);
}
public function SortWeapons(BioPawn pPawn, out array<SFXWeapon> aWeapons)
{
    aWeapons.Sort(WeaponSort);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aMappingIconPaths[1] = "Y"
    m_aMappingIconPaths[2] = "X"
    m_aMappingIconPaths[3] = "LDpad"
    m_aMappingIconPaths[4] = "RDpad"
    m_aMappingIconPaths[5] = "LB"
    m_aMappingIconPaths[6] = "RB"
    m_aMappingIconPaths[7] = "LT"
    m_aMappingIconPaths[8] = "RT"
    m_oPowerIndices = {
                       aPlayer = (8, 
                                  9, 
                                  7, 
                                  10, 
                                  6, 
                                  11, 
                                  5, 
                                  12
                                 ), 
                       aHench1 = (13, 14, 15, 16, 17), 
                       aHench2 = (4, 3, 2, 1, 0)
                      }
    m_oWeaponIndices = {
                        aPlayer = (4, 5, 3, 6, 2), 
                        aHench1 = (7, 8), 
                        aHench2 = (1, 0)
                       }
    m_oMapTextIcon1 = {sPath = "Wheel.Wheel.ButtonMapTo2", eIcon = SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE}
    m_oMapTextIcon2 = {sPath = "Wheel.Wheel.ButtonMapTo1", eIcon = SFXPowerWheelMapButtonIcon.PWBI_Icon_NONE}
    m_aPowerIconInfo = ({
                         Path = "Wheel.Wheel.Icon205", 
                         MappedIconPath = "Wheel.Wheel.mapIcon205", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG205", 
                         Id = "", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon204", 
                         MappedIconPath = "Wheel.Wheel.mapIcon204", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG204", 
                         Id = "", 
                         Boundary = 23.5, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon203", 
                         MappedIconPath = "Wheel.Wheel.mapIcon203", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG203", 
                         Id = "", 
                         Boundary = 43.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon202", 
                         MappedIconPath = "Wheel.Wheel.mapIcon202", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG202", 
                         Id = "", 
                         Boundary = 60.5, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon201", 
                         MappedIconPath = "Wheel.Wheel.mapIcon201", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG201", 
                         Id = "", 
                         Boundary = 77.5, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon007", 
                         MappedIconPath = "Wheel.Wheel.mapIcon007", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG007", 
                         Id = "", 
                         Boundary = 98.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon005", 
                         MappedIconPath = "Wheel.Wheel.mapIcon005", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG005", 
                         Id = "", 
                         Boundary = 120.5, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon003", 
                         MappedIconPath = "Wheel.Wheel.mapIcon003", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG003", 
                         Id = "", 
                         Boundary = 139.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon001", 
                         MappedIconPath = "Wheel.Wheel.mapIcon001", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG001", 
                         Id = "", 
                         Boundary = 159.5, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon002", 
                         MappedIconPath = "Wheel.Wheel.mapIcon002", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG002", 
                         Id = "", 
                         Boundary = 180.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon004", 
                         MappedIconPath = "Wheel.Wheel.mapIcon004", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG004", 
                         Id = "", 
                         Boundary = 202.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon006", 
                         MappedIconPath = "Wheel.Wheel.mapIcon006", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG006", 
                         Id = "", 
                         Boundary = 222.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon008", 
                         MappedIconPath = "Wheel.Wheel.mapIcon008", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG008", 
                         Id = "", 
                         Boundary = 240.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon101", 
                         MappedIconPath = "Wheel.Wheel.mapIcon101", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG101", 
                         Id = "", 
                         Boundary = 262.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon102", 
                         MappedIconPath = "Wheel.Wheel.mapIcon102", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG102", 
                         Id = "", 
                         Boundary = 282.5, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon103", 
                         MappedIconPath = "Wheel.Wheel.mapIcon103", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG103", 
                         Id = "", 
                         Boundary = 299.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon104", 
                         MappedIconPath = "Wheel.Wheel.mapIcon104", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG104", 
                         Id = "", 
                         Boundary = 317.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "Wheel.Wheel.Icon105", 
                         MappedIconPath = "Wheel.Wheel.mapIcon105", 
                         MappedIconBGPath = "Wheel.Wheel.mappingBG105", 
                         Id = "", 
                         Boundary = 336.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }
                       )
    m_aWeaponIcons = ({
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon202", 
                       sID = "", 
                       fBoundary = 0.0, 
                       bHenchIcon = TRUE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon201", 
                       sID = "", 
                       fBoundary = 53.0, 
                       bHenchIcon = TRUE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon005", 
                       sID = "", 
                       fBoundary = 93.0, 
                       bHenchIcon = FALSE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon003", 
                       sID = "", 
                       fBoundary = 130.0, 
                       bHenchIcon = FALSE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon001", 
                       sID = "", 
                       fBoundary = 160.0, 
                       bHenchIcon = FALSE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon002", 
                       sID = "", 
                       fBoundary = 200.0, 
                       bHenchIcon = FALSE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon004", 
                       sID = "", 
                       fBoundary = 230.0, 
                       bHenchIcon = FALSE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon101", 
                       sID = "", 
                       fBoundary = 267.0, 
                       bHenchIcon = TRUE
                      }, 
                      {
                       sName = "", 
                       sPawnName = "", 
                       sDescription = "", 
                       sIconResource = "", 
                       oWeaponClass = None, 
                       nWeaponIcon = 0, 
                       nAmmo = 0, 
                       oIconMC = None, 
                       bEquipped = FALSE, 
                       eWeaponState = SFXPowerWheelWeaponState.PWWS_Normal, 
                       sPath = "Wheel.Wheel.Weapon102", 
                       sID = "", 
                       fBoundary = 307.0, 
                       bHenchIcon = TRUE
                      }
                     )
    m_sWheelPath = "Wheel"
    m_sWheelInnerPath = "Wheel.Wheel"
    m_sTitleTextPath = "txtTitle"
    m_sNameTextPath = "Wheel.Wheel.txtName"
    m_sInfoTextPath = "txtInfo"
    m_sInfoTextBGPath = "PowerTextBG"
    m_sUseButtonPath = "Wheel.Wheel.mcButtonUse"
    m_sUseTextPath = "Wheel.Wheel.txtUse"
    m_sMapButton1Path = "Wheel.Wheel.mcButtonMap2"
    m_sMapText1Path = "Wheel.Wheel.txtMap2"
    m_sMapButton2Path = "Wheel.Wheel.mcButtonMap1"
    m_sMapText2Path = "Wheel.Wheel.txtMap1"
    m_sMapText3Path = "Wheel.Wheel.txtMap3"
    m_sMapButton3Path = "Wheel.Wheel.mcButtonMap3"
    m_aRadarIconFramePaths = ("friendly", 
                              "neutral", 
                              "hostile", 
                              "vehicle", 
                              "store", 
                              "mapPin", 
                              "plot", 
                              "mineral", 
                              "anomaly", 
                              "interest", 
                              "debris", 
                              "surveyed", 
                              "henchmen", 
                              "transition"
                             )
    m_sShepardBlockerPath = "Wheel.Wheel.BlockerShepard"
    m_sHench1BlockerPath = "Wheel.Wheel.BlockerTeam1"
    m_sHench2BlockerPath = "Wheel.Wheel.BlockerTeam2"
    m_sRadarPath = "Radar.Radar"
    m_sTeam1StatusTextPath = "Wheel.Wheel.txtTeam1Status"
    m_sTeam1PowerTextPath = "Wheel.Wheel.txtTeam1Power"
    m_sHench1PortraitImagePath = "g_Hench1Image.ImageResource"
    m_sHench1PortraitMovieClipPath = "Wheel.Wheel.Team.Team1.Character"
    m_sTeam2StatusTextPath = "Wheel.Wheel.txtTeam2Status"
    m_sTeam2PowerTextPath = "Wheel.Wheel.txtTeam2Power"
    m_sHench2PortraitImagePath = "g_Hench2Image.ImageResource"
    m_sHench2PortraitMovieClipPath = "Wheel.Wheel.Team.Team2.Character"
    m_sWheelArrowPath = "Wheel.Wheel.Arrow"
    m_sNuiSpeechIconPath = "Wheel.Wheel.NuiSpeechIcon"
    m_sNotSuggestedPrefix = "<font color='#FF3333'>"
    m_sNotSuggestedSuffix = "</font>"
    m_sMap1Token = "[XBoxB_Btn_LB]"
    m_sMap2Token = "[XBoxB_Btn_RB]"
    m_sMap3Token = "[XBoxB_Btn_Y]"
    m_sMapHench1Token = "[XBoxB_Btn_DPadL]"
    m_sMapHench2Token = "[XBoxB_Btn_DPadR]"
    m_aWeaponStateFrames[0] = 1
    m_aWeaponStateFrames[1] = 2
    m_aWeaponStateFrames[2] = 3
    m_aWeaponStateFrames[3] = 4
    m_vBoundaryDimensions = {X = 160.0, Y = 160.0}
    m_fInfoTextChangeDelay = 0.100000001
    m_fThumbstickInterpSpeed = 30.0
    m_fLStickAngleDeltaDeg = 0.600000024
    m_fLStickStickyIconAngle = 20.0
    m_nCurrentPowerIconIndex = -1
    m_nCurrentWeaponIconIndex = -1
    m_srBlocked = $172566
    m_srPawnIncapacitated = $172566
    m_srWeaponSwitching = $172565
    m_srWeaponOverheating = $301597
    m_srWeaponReloading = $301598
    m_srDisplayTitle = $301599
    m_srWeaponWheelDisplayTitle = $342200
    m_srPowerWheelDisplayTitle = $342209
    m_srEquip = $112267
    m_srUse = $162384
    m_srMap = $162383
    m_srOverheated = $173750
    m_srRecharging = $171683
    m_srUnavailable = $171729
    m_srRadarRangeUnits = $165335
    m_srObjective = $349239
    m_fRadarDirectionChangeDelta = 0.5
    m_fRadarElementLocationChangeDelta = 0.00999999978
    m_fRadarRadius = 69.0
    m_fBoundaryShrinkFactor = 0.800000012
    m_fVehicleRadarUpdateInterval = 2.0
    m_fRadarObjectiveUpdateInterval = 0.25
    m_bCanMapPlayerPowers = TRUE
    m_bShowUseMapText = TRUE
    bSetGameMode = FALSE
    m_bUseThumbstickAsDPad = FALSE
}