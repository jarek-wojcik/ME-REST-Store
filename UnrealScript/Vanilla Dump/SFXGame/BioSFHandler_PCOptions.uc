Class BioSFHandler_PCOptions extends BioSFHandler_Options
    native
    config(UI);

struct native NonBindableKeyDefinition 
{
    var(NonBindableKeyDefinition) string Command;
    var(NonBindableKeyDefinition) Name Name;
    var(NonBindableKeyDefinition) bool Control;
    var(NonBindableKeyDefinition) bool Shift;
    var(NonBindableKeyDefinition) bool Alt;
    var(NonBindableKeyDefinition) bool ModifierIndependent;
};
struct native GuiBind extends ModeAliasPair 
{
    var(GuiBind) KeyBind Keys[2];
    var(GuiBind) string KeysLocName[2];
    var(GuiBind) array<SubordinateDesc> Subordinates;
    var(GuiBind) stringref Name;
    var(GuiBind) bool bCategory;
};
struct native SubordinateDesc extends ModeAliasPair 
{
    var(SubordinateDesc) bool bAllGameModes;
};
struct native ModeAliasPair 
{
    var(ModeAliasPair) string Alias;
    var(ModeAliasPair) EGameModes GameMode;
};
const PCOptions_MaxNumKeysPerAlias = 2;
const Option_ApplySettings = 9;
const Option_ApplyPCBindings = 8;
const Option_ResetPCBindings = 7;

var(BioSFHandler_PCOptions) array<KeyBind> KeyBinds;
var(BioSFHandler_PCOptions) transient array<GuiBind> AliasMap;
var(BioSFHandler_PCOptions) transient array<NonBindableKeyDefinition> UnBindableKeys;
var(BioSFHandler_PCOptions) transient stringref KeyHasBeenBound;
var(BioSFHandler_PCOptions) transient stringref KeyHasBeenUnbound;
var(BioSFHandler_PCOptions) transient stringref ResetPCBindingsText;
var(BioSFHandler_PCOptions) transient stringref ConfirmResetPCBindingsText;
var(BioSFHandler_PCOptions) transient stringref CancelResetPCBindingsText;
var(BioSFHandler_PCOptions) transient stringref CannotBindConstantKey;
var(BioSFHandler_PCOptions) transient stringref DisplayChangeText;
var(BioSFHandler_PCOptions) transient stringref ConfirmDisplayChangeText;
var(BioSFHandler_PCOptions) transient stringref CancelDisplayChangeText;
var(BioSFHandler_PCOptions) transient int DisplayChangeTimeoutSeconds;
var(BioSFHandler_PCOptions) transient BioSFHandler_MessageBox ConfirmDisplayMessageBox;
var(BioSFHandler_PCOptions) int CaptureBindIndex;
var(BioSFHandler_PCOptions) int CaptureBindNumber;

public final native function ApplyPCBindings();

public final native function ApplySettings();

public native function BuildControlBindingList(GFxValue optionData);

public final native function InitPCBindings(bool Defaults);

public function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}
public native function bool ProcessInput(int ControllerId, Name Key, EInputEvent EventType, optional float AmountDepressed = 1.0, optional bool bGamepad);

public final native function RefreshGUIBindings();

public final native function ResetPCToDefaults(const out array<int> lstOptsToReset);

public function ResetToDefaults(string sPackedIDs)
{
    Helper_CreateResetConfirmPopup(GetSFXUIController(), Callback_ResetPCToDefaults);
    Helper_ExtractPackedOptIDs(m_lstOptsToReset, sPackedIDs);
}
public final native function RevertSettings();

public final native function bool WillChangeDisplay();

public function Callback_ConfirmDisplayChange(bool bAPressed, int Context)
{
    GetPC().ClearTimer('Callback_DisplayChangeTimeout', Self);
    bWaitingOnMsgBox = FALSE;
    if (bAPressed)
    {
        SaveAndExit();
    }
    else
    {
        RevertSettings();
    }
}
public function Callback_DisplayChangeTimeout()
{
    if (ConfirmDisplayMessageBox != None)
    {
        ConfirmDisplayMessageBox.Close(FALSE);
    }
    RevertSettings();
}
public function Callback_ResetPCBindings(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        Helper_DoPCBindingReset();
    }
    bWaitingOnMsgBox = FALSE;
}
public function Callback_ResetPCToDefaults(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        ResetPCToDefaults(m_lstOptsToReset);
        if (m_lstOptsToReset.Length < 1)
        {
            Helper_DoPCBindingReset();
        }
    }
    Callback_ResetToDefaults(bAPressed, Context);
}
public function CaptureNewBinding(int BindIndex, int BindNumber)
{
    local PlayerController PC;
    
    PC = GetPC();
    if (PC != None && PC.PlayerInput != None)
    {
        PC.PlayerInput.__OnReceivedNativeInputKey__Delegate = ProcessInput;
    }
    CaptureBindIndex = BindIndex;
    CaptureBindNumber = BindNumber;
    SetMouseShown(FALSE);
}
public function ConfirmDisplayChange()
{
    local BioMessageBoxOptionalParams Params;
    
    if (ConfirmDisplayMessageBox != None)
    {
        ConfirmDisplayMessageBox.Close(FALSE);
    }
    ConfirmDisplayMessageBox = GetSFXUIController().CreateMessageBox(GetPC());
    ConfirmDisplayMessageBox.SetInputDelegate(Callback_ConfirmDisplayChange);
    Params.srAText = ConfirmDisplayChangeText;
    Params.srBText = CancelDisplayChangeText;
    Params.bNoFade = TRUE;
    ConfirmDisplayMessageBox.DisplayMessageBox(DisplayChangeText, Params);
    bWaitingOnMsgBox = TRUE;
    GetPC().SetTimer(float(DisplayChangeTimeoutSeconds), FALSE, 'Callback_DisplayChangeTimeout', Self);
}
public function Helper_DoPCBindingReset()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        InitPCBindings(TRUE);
        RefreshGUIBindings();
    }
}
public function MovieLoaded()
{
    InitSystemSettingsCache();
    InitPCBindings(FALSE);
    Super.MovieLoaded();
}
public function ResetPCBindings()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    messageBox.SetInputDelegate(Callback_ResetPCBindings);
    Params.srAText = ConfirmResetPCBindingsText;
    Params.srBText = CancelResetPCBindingsText;
    Params.bNoFade = TRUE;
    messageBox.DisplayMessageBox(ResetPCBindingsText, Params);
    bWaitingOnMsgBox = TRUE;
}
public function SaveAndExit()
{
    local BioPlayerController PC;
    local bool ChangedDisplay;
    
    PC = BioPlayerController(GetPC());
    if (PC == None)
    {
        return;
    }
    ChangedDisplay = WillChangeDisplay();
    ApplySettings();
    if (ChangedDisplay)
    {
        ConfirmDisplayChange();
    }
    else
    {
        ApplyPCBindings();
        PC.SavePCInputConfiguration(NewSettings);
        Super.SaveAndExit();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AliasMap = ({
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337733, 
                 bCategory = TRUE, 
                 Alias = "", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_MoveForward", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveForward", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_GalaxyKeyMoveForward", GameMode = EGameModes.GameMode_Galaxy}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveForward", GameMode = EGameModes.GameMode_DreamSequence}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveForward", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337894, 
                 bCategory = FALSE, 
                 Alias = "PC_MoveForward", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_MoveBackward", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveBackward", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_GalaxyKeyMoveBackward", GameMode = EGameModes.GameMode_Galaxy}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveBackward", GameMode = EGameModes.GameMode_DreamSequence}, 
                                 {bAllGameModes = FALSE, Alias = "PC_MoveBackward", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337895, 
                 bCategory = FALSE, 
                 Alias = "PC_MoveBackward", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_StrafeLeft", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeLeft", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_GalaxyKeyStrafeLeft", GameMode = EGameModes.GameMode_Galaxy}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeLeft", GameMode = EGameModes.GameMode_DreamSequence}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeLeft", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337896, 
                 bCategory = FALSE, 
                 Alias = "PC_StrafeLeft", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_StrafeRight", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeRight", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_GalaxyKeyStrafeRight", GameMode = EGameModes.GameMode_Galaxy}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeRight", GameMode = EGameModes.GameMode_DreamSequence}, 
                                 {bAllGameModes = FALSE, Alias = "PC_StrafeRight", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337897, 
                 bCategory = FALSE, 
                 Alias = "PC_StrafeRight", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $174852, 
                 bCategory = FALSE, 
                 Alias = "Walking", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_Action", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Action", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Action", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337962, 
                 bCategory = FALSE, 
                 Alias = "Shared_Action", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = TRUE, Alias = "Shared_ShowMap", GameMode = EGameModes.GameMode_Default}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_HideMap", GameMode = EGameModes.GameMode_GUI}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_ShowMap", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_ShowMap", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_ShowMap", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $708554, 
                 bCategory = FALSE, 
                 Alias = "Shared_ShowMap", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $708967, 
                 bCategory = FALSE, 
                 Alias = "Shared_CoverTurn", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_QuickSave", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $282869, 
                 bCategory = FALSE, 
                 Alias = "Shared_QuickSave", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_QuickLoad", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $282870, 
                 bCategory = FALSE, 
                 Alias = "PC_QuickLoad", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337781, 
                 bCategory = TRUE, 
                 Alias = "", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_Shoot", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Shoot", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Shoot", GameMode = EGameModes.GameMode_IllusiveManConflict}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Shoot", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $337963, 
                 bCategory = FALSE, 
                 Alias = "Shared_Shoot", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_Aim", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Aim", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_CommandToggleCam", GameMode = EGameModes.GameMode_Command}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_Aim", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $282873, 
                 bCategory = FALSE, 
                 Alias = "Shared_Aim", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_Reload", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_Reload", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_Reload", GameMode = EGameModes.GameMode_InjuredShepard}
                                ), 
                 Name = $282875, 
                 bCategory = FALSE, 
                 Alias = "PC_Reload", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_Melee", GameMode = EGameModes.GameMode_Atlas}
                                ), 
                 Name = $282877, 
                 bCategory = FALSE, 
                 Alias = "Shared_Melee", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337964, 
                 bCategory = FALSE, 
                 Alias = "PC_SwapWeapon", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $282872, 
                 bCategory = FALSE, 
                 Alias = "PC_NextWeapon", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $282871, 
                 bCategory = FALSE, 
                 Alias = "PC_PrevWeapon", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_EnterCommandMenu", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "PC_EnterCommandMenu", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "PC_ExitCommandMenu", GameMode = EGameModes.GameMode_Command}
                                ), 
                 Name = $282856, 
                 bCategory = FALSE, 
                 Alias = "PC_EnterCommandMenu", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_SquadFollow", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadFollow", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadFollow", GameMode = EGameModes.GameMode_Command}
                                ), 
                 Name = $337965, 
                 bCategory = FALSE, 
                 Alias = "Shared_SquadFollow", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_SquadMove1", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadMove1", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadMove1", GameMode = EGameModes.GameMode_Command}
                                ), 
                 Name = $337966, 
                 bCategory = FALSE, 
                 Alias = "Shared_SquadMove1", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_SquadMove2", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadMove2", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadMove2", GameMode = EGameModes.GameMode_Command}
                                ), 
                 Name = $337967, 
                 bCategory = FALSE, 
                 Alias = "Shared_SquadMove2", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "Shared_SquadAttack", GameMode = EGameModes.GameMode_Vehicle}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadAttack", GameMode = EGameModes.GameMode_Atlas}, 
                                 {bAllGameModes = FALSE, Alias = "Shared_SquadAttack", GameMode = EGameModes.GameMode_Command}
                                ), 
                 Name = $708968, 
                 bCategory = FALSE, 
                 Alias = "Shared_SquadAttack", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337973, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey1", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337974, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey2", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337975, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey3", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337976, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey4", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337977, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey5", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337978, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey6", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "UseRevivePower", GameMode = EGameModes.GameMode_Dying}
                                ), 
                 Name = $337979, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey7", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $337980, 
                 bCategory = FALSE, 
                 Alias = "PC_HotKey8", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $708645, 
                 bCategory = TRUE, 
                 Alias = "", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_Talk", GameMode = EGameModes.GameMode_GUI}, 
                                 {bAllGameModes = FALSE, Alias = "PC_Talk", GameMode = EGameModes.GameMode_Lobby}, 
                                 {bAllGameModes = FALSE, Alias = "PC_Talk", GameMode = EGameModes.GameMode_Dying}, 
                                 {bAllGameModes = FALSE, Alias = "PC_Talk", GameMode = EGameModes.GameMode_Spectator}
                                ), 
                 Name = $711400, 
                 bCategory = FALSE, 
                 Alias = "PC_Talk", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = ({bAllGameModes = FALSE, Alias = "PC_PushToTalk", GameMode = EGameModes.GameMode_GUI}, 
                                 {bAllGameModes = FALSE, Alias = "PC_PushToTalk", GameMode = EGameModes.GameMode_Lobby}, 
                                 {bAllGameModes = FALSE, Alias = "PC_PushToTalk", GameMode = EGameModes.GameMode_Dying}, 
                                 {bAllGameModes = FALSE, Alias = "PC_PushToTalk", GameMode = EGameModes.GameMode_Spectator}
                                ), 
                 Name = $711401, 
                 bCategory = FALSE, 
                 Alias = "PC_PushToTalk", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $724510, 
                 bCategory = FALSE, 
                 Alias = "ProlongLife", 
                 GameMode = EGameModes.GameMode_Dying
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $687215, 
                 bCategory = TRUE, 
                 Alias = "", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $687216, 
                 bCategory = FALSE, 
                 Alias = "Shared_ExitAtlas", 
                 GameMode = EGameModes.GameMode_Atlas
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $687431, 
                 bCategory = TRUE, 
                 Alias = "", 
                 GameMode = EGameModes.GameMode_Default
                }, 
                {
                 Keys[0] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 Keys[1] = {
                            Command = "", 
                            Name = 'None', 
                            Control = FALSE, 
                            Shift = FALSE, 
                            Alt = FALSE, 
                            bIgnoreCtrl = FALSE, 
                            bIgnoreShift = FALSE, 
                            bIgnoreAlt = FALSE
                           }, 
                 KeysLocName[0] = "", 
                 KeysLocName[1] = "", 
                 Subordinates = (), 
                 Name = $687432, 
                 bCategory = FALSE, 
                 Alias = "Shared_ExitMountedGun", 
                 GameMode = EGameModes.GameMode_Vehicle
                }
               )
    KeyHasBeenBound = $337982
    KeyHasBeenUnbound = $337983
    ResetPCBindingsText = $338327
    ConfirmResetPCBindingsText = $163219
    CancelResetPCBindingsText = $163220
    CannotBindConstantKey = $346979
    DisplayChangeText = $723099
    ConfirmDisplayChangeText = $163219
    CancelDisplayChangeText = $163220
    DisplayChangeTimeoutSeconds = 10
    ScreenLayout = GUILayout.GUILayout_PC
}