Class SFXSFHandler_PCPowerWheel extends SFXSFHandler_PowerWheel
    native
    transient
    config(UI);

const NUM_KEYBOARD_QUICKSLOTS = 8;

var SFXPowerIconData m_aQuickSlotIconInfo[8];
var SFXPowerWheelIconWeapon m_oCenterWeaponIcon;
var SFXPowerWheelIconWeapon m_oHench1WeaponIcon;
var SFXPowerWheelIconWeapon m_oHench2WeaponIcon;
var SFXGUIValue_QuickSlotPowerIcon m_aQuickSlotIcons[8];
var Vector2D m_vMouseDownPos;
var Vector2D m_vDragOffsets;
var int m_nDraggingIcon;
var int m_nCurrentDropTarget;
var float m_fQuickslotIconUpdateInterval;
var int m_nCurrentQuickSlot;
var SFXGUIValue_PowerIcon m_oDragPowerIcon;
var SFXGUIValue_QuickSlotPowerIcon m_oDragSlotIcon;
var config stringref m_srMaximizeText;
var config stringref m_srMinimizeText;
var config float m_fDragStartThreshold;
var bool m_bDashboardWeaponsOpen;
var bool m_bDraggingPower;
var bool m_bDraggingKey;
var bool m_bDoingDrag;
var bool m_bQuickSlotExpanded;
var bool m_bQuickSlotVisible;
var bool m_bEvalQuickSlotPowers;
var EPhysics m_ShepardPreviousPhysics;

public native function doHotKey(int nIndex);

public event function InitDisplay()
{
    Super.InitDisplay();
    m_oCenterWeaponIcon.oIconMC = GetVariableObject(m_oCenterWeaponIcon.sPath);
    m_oHench1WeaponIcon.oIconMC = GetVariableObject(m_oHench1WeaponIcon.sPath);
    m_oHench2WeaponIcon.oIconMC = GetVariableObject(m_oHench2WeaponIcon.sPath);
    HideWeaponIcon(oPanel, m_oCenterWeaponIcon.oIconMC);
    m_bQuickSlotExpanded = FALSE;
    SetQuickSlotState(TRUE, TRUE);
}
public final native function MoveQuickSlotPowerByName(int nSlot, Name nmPowerToMove);

public final native function NewSetQuickSlotPower(int nSlot, int nDraggingIconID, bool bDraggingPower, bool bSilently);

public native function RemoveHenchman(BioPawn pPawn);

public event function SetMapText(string sText1, SFXPowerWheelMapButtonIcon eIcon1, optional string sText2 = "", optional SFXPowerWheelMapButtonIcon eIcon2 = 0, optional string sText3 = "", optional SFXPowerWheelMapButtonIcon eIcon3 = 0);

public final native function SetupQuickSlotKeys();

public final native function SetupQuickSlotPowers();

public event function SetUseText(string sText);

public event function SetWeaponState(int nWeapIndex, SFXPowerWheelWeaponState eNewWeapState)
{
    if (nWeapIndex < 0 || nWeapIndex >= m_aWeaponIcons.Length)
    {
        return;
    }
    if (m_oWeaponIndices.aPlayer.Find(nWeapIndex) == -1)
    {
        if (eNewWeapState == SFXPowerWheelWeaponState.PWWS_Selected)
        {
            eNewWeapState = SFXPowerWheelWeaponState.PWWS_Normal;
        }
    }
    Super.SetWeaponState(nWeapIndex, eNewWeapState);
}
public event function WheelVisibilityChanged(bool bVisible)
{
    local int nIcon;
    local GFxValue oHenchBG;
    
    SetMouseShown(bVisible);
    Super.WheelVisibilityChanged(bVisible);
    if (!bVisible)
    {
        oPanel.GotoFrameAndStop("DashMain.Dash.Player", 1);
        m_bDashboardWeaponsOpen = FALSE;
        SendMouseEvent(52);
        for (nIcon = 0; nIcon < 8; ++nIcon)
        {
            m_aQuickSlotIcons[nIcon].bDragHover = FALSE;
            m_aQuickSlotIcons[nIcon].SetSelected(FALSE);
            m_aQuickSlotIcons[nIcon].UpdateDisplay();
        }
    }
    else if (HaveHenchmen() == FALSE)
    {
        oHenchBG = GetVariableObject("DashMain.Dash.teamPanel1");
        oHenchBG.SetVisible(FALSE);
        oHenchBG = GetVariableObject("DashMain.Dash.teamPanel2");
        oHenchBG.SetVisible(FALSE);
    }
    oPanel.SetClipVisibility("QuickSlots.Control", bVisible);
    m_oCenterWeaponIcon.oIconMC.SetVisible(bVisible);
}
public function CleanupReferences()
{
    local int nIcon;
    
    Super.CleanupReferences();
    for (nIcon = 0; nIcon < 8; ++nIcon)
    {
        m_aQuickSlotIcons[nIcon].Cleanup();
        m_aQuickSlotIcons[nIcon] = None;
    }
    m_oDragPowerIcon.Cleanup();
    m_oDragPowerIcon = None;
    m_oDragSlotIcon.Cleanup();
    m_oDragSlotIcon = None;
}
public final function ClosePlayerWeapons()
{
    if (m_bDashboardWeaponsOpen)
    {
        m_bDashboardWeaponsOpen = FALSE;
        oPanel.GotoLabelAndPlay("DashMain.Dash.Player", "close");
    }
}
public final function ExInt_CollapsePlayerWeapons()
{
    ClosePlayerWeapons();
}
public final function ExInt_IconMouseDown(string sIconID)
{
    local int nIcon;
    local SFXPowerWheelMode eMode;
    
    if (IsMouseShown() == FALSE)
    {
        return;
    }
    m_bDraggingPower = FALSE;
    eMode = FindIconIndexFromPath(sIconID, nIcon);
    if (nIcon == -1 || eMode == SFXPowerWheelMode.PWM_NONE)
    {
        HandleQuickSlotMouseDown(sIconID);
        return;
    }
    if (eMode == SFXPowerWheelMode.PWM_Powers)
    {
        if (m_aPowerIcons[nIcon].eState != SFXPowerWheelPowerState.PWPS_EmptySelectable && m_aPowerIcons[nIcon].eState != SFXPowerWheelPowerState.PWPS_EmptySelected)
        {
            m_bDraggingPower = TRUE;
        }
    }
    m_nDraggingIcon = nIcon;
}
public final function ExInt_IconMouseUp(string sIconID)
{
    local int nIcon;
    local SFXPowerWheelMode eMode;
    
    if (IsMouseShown() == FALSE)
    {
        return;
    }
    eMode = FindIconIndexFromPath(sIconID, nIcon);
    if (nIcon == -1 || eMode == SFXPowerWheelMode.PWM_NONE)
    {
        HandleQuickSlotMouseUp(sIconID);
        return;
    }
    if (m_nDraggingIcon == nIcon && m_bDoingDrag != FALSE)
    {
        m_nDraggingIcon = -1;
        return;
    }
    if (eMode == SFXPowerWheelMode.PWM_Powers && m_nCurrentPowerIconIndex == nIcon)
    {
        SelectCurrentWheelItem(1);
        m_pPlayerController.GenerateTutorialEvent(9);
    }
    else if (eMode == SFXPowerWheelMode.PWM_Weapons && m_nCurrentWeaponIconIndex == nIcon)
    {
        if (m_oWeaponIndices.aPlayer.Find(nIcon) != -1)
        {
            SelectCurrentWheelItem(2);
        }
        else if (m_oWeaponIndices.aHench1.Find(nIcon) != -1)
        {
            SwapHenchmanWeapon(m_pHench1Pawn);
        }
        else if (m_oWeaponIndices.aHench2.Find(nIcon) != -1)
        {
            SwapHenchmanWeapon(m_pHench2Pawn);
        }
    }
    m_nDraggingIcon = -1;
}
public final function ExInt_IconRollOut(string sIconID)
{
    local int nIcon;
    local SFXPowerWheelMode eMode;
    local bool bIsPlayerID;
    
    if (IsMouseShown() == FALSE)
    {
        return;
    }
    eMode = FindIconIndexFromPath(sIconID, nIcon);
    if (nIcon == -1 || eMode == SFXPowerWheelMode.PWM_NONE)
    {
        HandleQuickSlotRollOut(sIconID);
        return;
    }
    if (eMode == SFXPowerWheelMode.PWM_Powers)
    {
        LeavePowerIcon(nIcon, FALSE);
    }
    else if (eMode == SFXPowerWheelMode.PWM_Weapons)
    {
        if (m_oWeaponIndices.aPlayer.Find(nIcon) != -1)
        {
            bIsPlayerID = TRUE;
        }
        if (m_bDashboardWeaponsOpen == bIsPlayerID)
        {
            LeaveWeaponIcon(nIcon);
        }
    }
}
public final function ExInt_IconRollOver(string sIconID)
{
    local int nIcon;
    local SFXPowerWheelMode eMode;
    local bool bIsPlayerID;
    local BioPawn pPawn;
    
    if (IsMouseShown() == FALSE)
    {
        return;
    }
    eMode = FindIconIndexFromPath(sIconID, nIcon);
    if (nIcon == -1 || eMode == SFXPowerWheelMode.PWM_NONE)
    {
        if (sIconID == "WeaponCenter")
        {
            ExpandPlayerWeapons();
        }
        else if (HandleQuickSlotRollOver(sIconID) != FALSE)
        {
            return;
        }
        return;
    }
    if (eMode == SFXPowerWheelMode.PWM_Powers)
    {
        if (m_pPlayerController != None && m_pPlayerController.bMultiplayerCommandMode)
        {
            pPawn = m_pPlayerController.GetBioPawn();
        }
        else if (m_oPowerIndices.aPlayer.Find(nIcon) >= 0)
        {
            pPawn = m_pShepardPawn;
        }
        else if (m_oPowerIndices.aHench1.Find(nIcon) >= 0)
        {
            pPawn = m_pHench1Pawn;
        }
        else if (m_oPowerIndices.aHench2.Find(nIcon) >= 0)
        {
            pPawn = m_pHench2Pawn;
        }
        ClosePlayerWeapons();
        if (IsPawnBlocked(pPawn) == FALSE)
        {
            HoverPowerIcon(nIcon, FALSE);
        }
    }
    else if (eMode == SFXPowerWheelMode.PWM_Weapons)
    {
        if (m_pPlayerController != None && m_pPlayerController.bMultiplayerCommandMode)
        {
            pPawn = m_pPlayerController.GetBioPawn();
        }
        else if (m_oWeaponIndices.aPlayer.Find(nIcon) >= 0)
        {
            pPawn = m_pShepardPawn;
        }
        else if (m_oWeaponIndices.aHench1.Find(nIcon) >= 0)
        {
            pPawn = m_pHench1Pawn;
        }
        else if (m_oWeaponIndices.aHench2.Find(nIcon) >= 0)
        {
            pPawn = m_pHench2Pawn;
        }
        if (IsPawnBlocked(pPawn) != FALSE)
        {
            return;
        }
        if (m_oWeaponIndices.aPlayer.Find(nIcon) != -1)
        {
            bIsPlayerID = TRUE;
        }
        if (m_bDashboardWeaponsOpen == bIsPlayerID)
        {
            HoverWeaponIcon(nIcon);
        }
    }
}
public final function ExpandPlayerWeapons()
{
    if (!m_bDashboardWeaponsOpen)
    {
        m_bDashboardWeaponsOpen = TRUE;
        oPanel.GotoLabelAndPlay("DashMain.Dash.Player", "open");
    }
}
public final function SFXPowerWheelMode FindIconIndexFromPath(string sIconID, out int nFoundIcon)
{
    local int nIcon;
    
    nFoundIcon = -1;
    for (nIcon = 0; nIcon < m_aPowerIcons.Length; ++nIcon)
    {
        if (m_aPowerIcons[nIcon].sID == sIconID)
        {
            nFoundIcon = nIcon;
            return SFXPowerWheelMode.PWM_Powers;
        }
    }
    for (nIcon = 0; nIcon < m_aWeaponIcons.Length; ++nIcon)
    {
        if (m_aWeaponIcons[nIcon].sID == sIconID)
        {
            nFoundIcon = nIcon;
            return SFXPowerWheelMode.PWM_Weapons;
        }
    }
    return SFXPowerWheelMode.PWM_NONE;
}
public final function bool HandleQuickSlotMouseDown(string sIconID)
{
    local int nSlot;
    
    for (nSlot = 0; nSlot < 8; ++nSlot)
    {
        if (m_aQuickSlotIcons[nSlot].sID == sIconID)
        {
            if (m_aQuickSlotIcons[nSlot].eState != SFXPowerWheelPowerState.PWPS_EmptySelectable && m_aQuickSlotIcons[nSlot].eState != SFXPowerWheelPowerState.PWPS_EmptySelected)
            {
                m_bDraggingKey = TRUE;
                m_nDraggingIcon = nSlot;
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final function bool HandleQuickSlotMouseUp(string sIconID)
{
    local int nSlot;
    
    if (sIconID == "QuickslotControl")
    {
        SetQuickSlotState(!m_bQuickSlotExpanded, FALSE);
        return TRUE;
    }
    if (!m_bDoingDrag)
    {
        for (nSlot = 0; nSlot < 8; ++nSlot)
        {
            if (m_aQuickSlotIcons[nSlot].sID == sIconID)
            {
                doHotKey(nSlot);
                m_pPlayerController.GenerateTutorialEvent(9);
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final function bool HandleQuickSlotRollOut(string sIconID)
{
    local int nSlot;
    
    if (sIconID == "QuickslotControl")
    {
        oPanel.GotoFrameAndStop("QuickSlots.Control", 1);
        return TRUE;
    }
    for (nSlot = 0; nSlot < 8; ++nSlot)
    {
        if (m_aQuickSlotIcons[nSlot].sID == sIconID)
        {
            LeaveQuickSlot(nSlot);
            return TRUE;
        }
    }
    return FALSE;
}
public final function bool HandleQuickSlotRollOver(string sIconID)
{
    local int nSlot;
    
    if (sIconID == "QuickslotControl")
    {
        oPanel.GotoLabelAndPlay("QuickSlots.Control", "startselect");
        return TRUE;
    }
    for (nSlot = 0; nSlot < 8; ++nSlot)
    {
        if (m_aQuickSlotIcons[nSlot].sID == sIconID)
        {
            HoverQuickSlot(nSlot);
            return TRUE;
        }
    }
    return FALSE;
}
public final function HoverQuickSlot(int nSlotID)
{
    if (nSlotID < 0 || nSlotID >= 8)
    {
        return;
    }
    if (m_nCurrentQuickSlot != nSlotID)
    {
        LeaveQuickSlot(m_nCurrentQuickSlot);
        if (m_bDraggingPower)
        {
            m_aQuickSlotIcons[nSlotID].bDragHover = TRUE;
        }
        m_aQuickSlotIcons[nSlotID].SetSelected(TRUE);
        m_nCurrentQuickSlot = nSlotID;
        UpdatePowerInformationText(m_aQuickSlotIcons[nSlotID]);
        PlayGuiSound('HUDPowerWheelChangeHighlightedPower');
    }
}
public function InitPowerIcons()
{
    local SFXGUIValue_QuickSlotPowerIcon oIcon;
    local int nIcon;
    
    Super.InitPowerIcons();
    for (nIcon = 0; nIcon < 8; ++nIcon)
    {
        oIcon = SFXGUIValue_QuickSlotPowerIcon(GetVariableObject(m_aQuickSlotIconInfo[nIcon].Path, Class'SFXGUIValue_QuickSlotPowerIcon'));
        if (oIcon != None)
        {
            oIcon.sPath = m_aQuickSlotIconInfo[nIcon].Path;
            oIcon.sID = m_aQuickSlotIconInfo[nIcon].Id;
            m_aQuickSlotIcons[nIcon] = oIcon;
            continue;
        }
    }
    m_oDragPowerIcon = SFXGUIValue_PowerIcon(GetVariableObject("DragPower", Class'SFXGUIValue_PowerIcon'));
    if (m_oDragPowerIcon != None)
    {
        m_oDragPowerIcon.sPath = "DragPower";
        m_oDragPowerIcon.eState = SFXPowerWheelPowerState.PWPS_Selected;
    }
    m_oDragSlotIcon = SFXGUIValue_QuickSlotPowerIcon(GetVariableObject("DragKey", Class'SFXGUIValue_QuickSlotPowerIcon'));
    if (m_oDragSlotIcon != None)
    {
        m_oDragSlotIcon.sPath = "DragKey";
        m_oDragSlotIcon.eState = SFXPowerWheelPowerState.PWPS_Selected;
    }
}
public final function LeaveQuickSlot(int nSlotID)
{
    if (nSlotID < 0 || nSlotID >= 8)
    {
        return;
    }
    m_aQuickSlotIcons[nSlotID].bDragHover = FALSE;
    m_aQuickSlotIcons[nSlotID].SetSelected(FALSE);
    m_nCurrentQuickSlot = -1;
    SetInformationText("", "", FALSE);
}
public function OnAllowCameraRotation(bool i_bValue)
{
    if (i_bValue)
    {
    }
}
public function SelectWeapon(int nWeaponIndex)
{
    if (nWeaponIndex < 0 || nWeaponIndex >= m_aWeaponIcons.Length)
    {
        return;
    }
    if (m_oWeaponIndices.aPlayer.Find(nWeaponIndex) != -1)
    {
        Super.SelectWeapon(nWeaponIndex);
        SetWeaponTypeDisplay(oPanel, m_oCenterWeaponIcon.oIconMC, m_aWeaponIcons[nWeaponIndex].sIconResource, m_aWeaponIcons[nWeaponIndex].nWeaponIcon);
        UpdateWeaponIconDisplay(m_aWeaponIcons[nWeaponIndex], m_oCenterWeaponIcon.sPath);
        m_oCenterWeaponIcon.nWeaponIcon = m_aWeaponIcons[nWeaponIndex].nWeaponIcon;
        ClosePlayerWeapons();
    }
}
public final function SetQuickSlotState(bool bExpand, bool bSkipTransition)
{
    local int nIcon;
    
    if (m_bQuickSlotExpanded == bExpand)
    {
        return;
    }
    if (bExpand)
    {
        SetupQuickSlotKeys();
        if (!bSkipTransition)
        {
            oPanel.GotoLabelAndPlay("QuickSlots", "maximize");
        }
        else
        {
            oPanel.GotoLabelAndStop("QuickSlots", "maximized");
        }
        oPanel.SetTextFieldText("QuickSlots.Control.controlMC.txtMinMax", string(m_srMinimizeText));
        oPanel.GotoLabelAndStop("QuickSlots.Control.controlMC.Button", "minimize");
        for (nIcon = 0; nIcon < 8; ++nIcon)
        {
            m_aQuickSlotIcons[nIcon].SetSelected(FALSE);
            m_aQuickSlotIcons[nIcon].UpdateDisplay();
        }
    }
    else
    {
        if (!bSkipTransition)
        {
            oPanel.GotoLabelAndPlay("QuickSlots", "minimize");
        }
        else
        {
            oPanel.GotoLabelAndStop("QuickSlots", "minimized");
        }
        oPanel.SetTextFieldText("QuickSlots.Control.controlMC.txtMinMax", string(m_srMaximizeText));
        oPanel.GotoLabelAndStop("QuickSlots.Control.controlMC.Button", "maximize");
    }
    m_bQuickSlotExpanded = bExpand;
}
public function SortWeapons(BioPawn pPawn, out array<SFXWeapon> aWeapons)
{
    local int nWeap;
    local SFXWeapon pSwapWeap;
    
    if (pPawn == m_pShepardPawn)
    {
        Super.SortWeapons(pPawn, aWeapons);
        return;
    }
    for (nWeap = 0; nWeap < aWeapons.Length; ++nWeap)
    {
        if (aWeapons[nWeap] == pPawn.Weapon)
        {
            if (nWeap != 0)
            {
                pSwapWeap = aWeapons[0];
                aWeapons[0] = aWeapons[nWeap];
                aWeapons[nWeap] = pSwapWeap;
            }
        }
    }
}
public final function SwapHenchmanWeapon(BioPawn pHench)
{
    local SFXInventoryManager pInvManager;
    local SFXWeapon pWeapon;
    local int nIcon;
    local SFXPowerWheelIconWeapon oWeaponIcon;
    local bool bSwitched;
    
    if (pHench == None)
    {
        PlayGuiSound('GuiError');
        return;
    }
    if (pHench == m_pHench1Pawn)
    {
        nIcon = m_oWeaponIndices.aHench1[0];
    }
    else if (pHench == m_pHench2Pawn)
    {
        nIcon = m_oWeaponIndices.aHench2[0];
    }
    pInvManager = SFXInventoryManager(pHench.InvManager);
    oWeaponIcon = m_aWeaponIcons[nIcon];
    if (pInvManager != None)
    {
        foreach pInvManager.InventoryActors(Class'SFXWeapon', pWeapon)
        {
            if (pWeapon.Class != oWeaponIcon.oWeaponClass)
            {
                pInvManager.CurrentWeaponSelection = pWeapon.Class;
                m_pPlayerController.OrderWeaponSwitch(pHench, pWeapon);
                PlayGuiSound('HUDPowerWheelQueueingHighlightedPowerForActivation');
                m_aWeaponIcons[nIcon].nWeaponIcon = -1;
                SetWeaponIcon(pWeapon, nIcon, pHench);
                HoverWeaponIcon(nIcon, TRUE);
                bSwitched = TRUE;
                break;
            }
        }
    }
    if (!bSwitched)
    {
        PlayGuiSound('GuiError');
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aQuickSlotIconInfo[0] = {
                               Path = "QuickSlots.Keys.keymapMC1", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap1", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[1] = {
                               Path = "QuickSlots.Keys.keymapMC2", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap2", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[2] = {
                               Path = "QuickSlots.Keys.keymapMC3", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap3", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[3] = {
                               Path = "QuickSlots.Keys.keymapMC4", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap4", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[4] = {
                               Path = "QuickSlots.Keys.keymapMC5", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap5", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[5] = {
                               Path = "QuickSlots.Keys.keymapMC6", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap6", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[6] = {
                               Path = "QuickSlots.Keys.keymapMC7", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap7", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_aQuickSlotIconInfo[7] = {
                               Path = "QuickSlots.Keys.keymapMC8", 
                               MappedIconPath = "", 
                               MappedIconBGPath = "", 
                               Id = "KeyMap8", 
                               Boundary = 0.0, 
                               IsHenchmanIcon = FALSE, 
                               IsQuickslotIcon = FALSE
                              }
    m_oCenterWeaponIcon = {
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
                           sPath = "DashMain.Dash.Player.WeaponCenter", 
                           sID = "", 
                           fBoundary = 0.0, 
                           bHenchIcon = FALSE
                          }
    m_oHench1WeaponIcon = {
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
                           sPath = "DashMain.Dash.Weapon101", 
                           sID = "Weapon101", 
                           fBoundary = 0.0, 
                           bHenchIcon = TRUE
                          }
    m_oHench2WeaponIcon = {
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
                           sPath = "DashMain.Dash.Weapon201", 
                           sID = "Weapon201", 
                           fBoundary = 0.0, 
                           bHenchIcon = TRUE
                          }
    m_nDraggingIcon = -1
    m_nCurrentDropTarget = -1
    m_fQuickslotIconUpdateInterval = 0.100000001
    m_srMaximizeText = $325379
    m_srMinimizeText = $325380
    m_fDragStartThreshold = 3.0
    m_oPowerIndices = {
                       aPlayer = (0, 
                                  1, 
                                  2, 
                                  3, 
                                  4, 
                                  5, 
                                  6, 
                                  7
                                 ), 
                       aHench1 = (8, 9, 10, 11, 12), 
                       aHench2 = (13, 14, 15, 16, 17)
                      }
    m_oWeaponIndices = {
                        aPlayer = (0, 1, 2, 3, 4), 
                        aHench1 = (5), 
                        aHench2 = (6)
                       }
    m_aPowerIconInfo = ({
                         Path = "DashMain.Dash.Icon001", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon001", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon002", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon002", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon003", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon003", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon004", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon004", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon005", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon005", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon006", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon006", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon007", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon007", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon008", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon008", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = FALSE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon101", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon101", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon102", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon102", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon103", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon103", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon104", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon104", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon105", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon105", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon201", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon201", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon202", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon202", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon203", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon203", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon204", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon204", 
                         Boundary = 0.0, 
                         IsHenchmanIcon = TRUE, 
                         IsQuickslotIcon = FALSE
                        }, 
                        {
                         Path = "DashMain.Dash.Icon205", 
                         MappedIconPath = "", 
                         MappedIconBGPath = "", 
                         Id = "Icon205", 
                         Boundary = 0.0, 
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
                       sPath = "DashMain.Dash.Player.Weapon001", 
                       sID = "Weapon001", 
                       fBoundary = 0.0, 
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
                       sPath = "DashMain.Dash.Player.Weapon002", 
                       sID = "Weapon002", 
                       fBoundary = 0.0, 
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
                       sPath = "DashMain.Dash.Player.Weapon003", 
                       sID = "Weapon003", 
                       fBoundary = 0.0, 
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
                       sPath = "DashMain.Dash.Player.Weapon004", 
                       sID = "Weapon004", 
                       fBoundary = 0.0, 
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
                       sPath = "DashMain.Dash.Player.Weapon005", 
                       sID = "Weapon005", 
                       fBoundary = 0.0, 
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
                       sPath = "DashMain.Dash.Weapon101", 
                       sID = "Weapon101", 
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
                       sPath = "DashMain.Dash.Weapon201", 
                       sID = "Weapon201", 
                       fBoundary = 0.0, 
                       bHenchIcon = TRUE
                      }
                     )
    m_sWheelPath = "DashMain"
    m_sWheelInnerPath = "DashMain.Dash"
    m_sNameTextPath = "txtName"
    m_sShepardBlockerPath = "DashMain.Dash.BlockerShepard"
    m_sHench1BlockerPath = "DashMain.Dash.BlockerTeam1"
    m_sHench2BlockerPath = "DashMain.Dash.BlockerTeam2"
    m_sTeam1StatusTextPath = "DashMain.Dash.txtTeam1Status"
    m_sTeam1PowerTextPath = "DashMain.Dash.txtTeam1Power"
    m_sHench1PortraitMovieClipPath = "DashMain.Dash.Hench1"
    m_sTeam2StatusTextPath = "DashMain.Dash.txtTeam2Status"
    m_sTeam2PowerTextPath = "DashMain.Dash.txtTeam2Power"
    m_sHench2PortraitMovieClipPath = "DashMain.Dash.Hench2"
    m_bCanMapPlayerPowers = FALSE
    m_bShowUseMapText = FALSE
    ScreenLayout = GUILayout.GUILayout_PC
}