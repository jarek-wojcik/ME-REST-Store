Class BioSFHandler_PCGalaxyMap extends BioSFHandler_GalaxyMap
    native
    config(UI);

var transient SFXUIControlState PrimaryAction;
var transient SFXUIControlState EscapeAction;
var config transient stringref ActionTokenString;
var transient bool bMoveToMouse;
var transient bool bMouseMovementEnabled;
var transient bool m_bActionTextVisible;

public event function BuyFuel()
{
    local SFXGameModeManager Manager;
    local SFXGUIInteraction GuiMan;
    local BioPlayerController PC;
    local SFXGameModeGalaxy GalaxyMap;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        PC = BioPlayerController(GetPC());
    }
    if (PC != None)
    {
        Manager = PC.GameModeManager2;
    }
    if (Manager != None)
    {
        GalaxyMap = SFXGameModeGalaxy(Manager.GameModes[11]);
    }
    if (GalaxyMap != None)
    {
        GalaxyMap.StartFuel();
        GalaxyMap.BuyFuel();
    }
    PC.SetTimer(0.100000001, TRUE, 'RepeatBuyFuel', Self);
}
public event function bool HandleInputEvent(BioGuiEvents nEvent, optional float fValue = 1.0)
{
    local SFXGameModeManager Manager;
    local SFXGUIInteraction GuiMan;
    local BioPlayerController PC;
    local SFXGameModeOrbital OrbitalGame;
    local SFXGameModeMultiLand MultiLand;
    local BioCameraBehaviorGalaxy GalaxyCam;
    local bool bIsOrbitalMode;
    local bool bIsMultiLandMode;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        PC = BioPlayerController(GetPC());
    }
    if (PC != None)
    {
        Manager = PC.GameModeManager2;
    }
    bIsOrbitalMode = FALSE;
    bIsMultiLandMode = FALSE;
    if (Manager != None)
    {
        OrbitalGame = SFXGameModeOrbital(Manager.HACK_GetOrbitalMode());
        bIsOrbitalMode = Manager.IsActive(12);
        MultiLand = SFXGameModeMultiLand(Manager.HACK_GetMultiLandMode());
        bIsMultiLandMode = Manager.IsActive(13);
    }
    if (Manager != None)
    {
        GalaxyCam = BioCameraBehaviorGalaxy(Manager.HACK_GetCameraMode(11));
    }
    if (!IsMouseShown())
    {
        switch (nEvent)
        {
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_A:
                break;
            case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_LEFT_RELEASE:
                if (bIsMultiLandMode)
                {
                    if (MultiLand.TestLandingCondition())
                    {
                        MultiLand.AttemptLand();
                    }
                    else
                    {
                        PlayGuiError();
                    }
                }
                else
                {
                    PerformPrimaryAction();
                }
                break;
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_B_RELEASE:
                PerformEscapeAction();
                break;
            case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_X:
                if (bIsOrbitalMode)
                {
                    OrbitalGame.RingReticleLeftRight(fValue);
                }
                if (bIsMultiLandMode)
                {
                    MultiLand.RingReticleLeftRight(fValue);
                }
                m_fLeftStickX = fValue;
                break;
            case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_Y:
                if (bIsOrbitalMode)
                {
                    OrbitalGame.RingReticleUpDown(fValue);
                }
                if (bIsMultiLandMode)
                {
                    MultiLand.RingReticleUpDown(fValue);
                }
                m_fLeftStickY = -fValue;
                break;
            case BioGuiEvents.BIOGUI_EVENT_KEY_WHEEL_UP:
            case BioGuiEvents.BIOGUI_EVENT_KEY_WHEEL_DOWN:
                if (bIsMultiLandMode)
                {
                    SendMouseEvent(nEvent);
                    return TRUE;
                }
                break;
            default:
        }
    }
    else
    {
        switch (nEvent)
        {
            case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_LEFT:
                if (bMouseMovementEnabled && (GalaxyCam.m_nCurrentState == 3 || GalaxyCam.m_nCurrentState == 2))
                {
                    bMoveToMouse = TRUE;
                }
                break;
            case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_LEFT_RELEASE:
                if (GalaxyCam.m_nCurrentState == 3 || GalaxyCam.m_nCurrentState == 2)
                {
                    bMoveToMouse = FALSE;
                }
                break;
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_B_RELEASE:
                PerformEscapeAction();
                break;
            default:
        }
        m_fLeftStickX = 0.0;
        m_fLeftStickY = 0.0;
    }
    return Super.HandleInputEvent(nEvent, fValue);
}
public final event function SetPCEscapeAction(bool bVisible)
{
    local string S;
    local string sTemp;
    local BioPlayerController oPC;
    
    oPC = BioPlayerController(GetPC());
    if (bVisible && EscapeAction.Text != 0)
    {
        sTemp = "(" $ oPC.GameModeManager2.GetLocalizedNameForKey('Escape', FALSE, FALSE, FALSE) $ ")";
        SetCustomToken(0, sTemp);
        SetCustomToken(1, UIStrRef(EscapeAction.Text));
        S = GetUIString(ActionTokenString, TRUE);
        ClearCustomTokens();
    }
    AS_SetPCEscapeAction(S);
}
public final event function SetPCPrimaryAction(bool bVisible)
{
    local string S;
    
    if (bVisible && PrimaryAction.Text != 0)
    {
        SetCustomToken(0, "[Mouse_Btn_L]");
        SetCustomToken(1, UIStrRef(PrimaryAction.Text));
        S = GetUIString(ActionTokenString, TRUE);
        ClearCustomTokens();
    }
    AS_SetPCPrimaryAction(S);
}
public final function AllowMouseMovement(bool bAllow)
{
    bMouseMovementEnabled = bAllow;
}
public final function AS_SetPCEscapeAction(const string sText)
{
    ActionScriptVoid("Main.SetPCEscapeAction");
}
public final function AS_SetPCPrimaryAction(const string sText)
{
    ActionScriptVoid("Main.SetPCPrimaryAction");
}
public final function PerformEscapeAction()
{
    local delegate<OnCallbackEvent> fnEscape;
    
    if (EscapeAction.Action != ESFXGalaxyMapUIAction.GalaxyAction_None && aUIActionCallbacks[int(EscapeAction.Action)] != None)
    {
        fnEscape = aUIActionCallbacks[int(EscapeAction.Action)];
        fnEscape();
    }
}
public final function PerformPrimaryAction()
{
    local delegate<OnCallbackEvent> fnPrimary;
    
    if (PrimaryAction.Action != ESFXGalaxyMapUIAction.GalaxyAction_None && aUIActionCallbacks[int(PrimaryAction.Action)] != None)
    {
        fnPrimary = aUIActionCallbacks[int(PrimaryAction.Action)];
        fnPrimary();
    }
}
public function RepeatBuyFuel()
{
    local SFXGameModeManager Manager;
    local SFXGUIInteraction GuiMan;
    local BioPlayerController PC;
    local SFXGameModeGalaxy GalaxyMap;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        PC = BioPlayerController(GetPC());
    }
    if (PC != None)
    {
        Manager = PC.GameModeManager2;
    }
    if (Manager != None)
    {
        GalaxyMap = SFXGameModeGalaxy(Manager.GameModes[11]);
    }
    if (GalaxyMap != None)
    {
        if (GalaxyMap.CanBuyFuel())
        {
            GalaxyMap.BuyFuel();
        }
        else
        {
            PC.ClearTimer('RepeatBuyFuel', Self);
            GalaxyMap.StopFuel();
            if (!bMouseMovementEnabled)
            {
                bMouseMovementEnabled = TRUE;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ActionTokenString = $724405
    bMouseMovementEnabled = TRUE
    m_bMouseVisibleWhenFocused = FALSE
    ScreenLayout = GUILayout.GUILayout_PC
}