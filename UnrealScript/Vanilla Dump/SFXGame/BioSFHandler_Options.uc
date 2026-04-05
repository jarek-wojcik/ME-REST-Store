Class BioSFHandler_Options extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

struct native OptionTelemetryInfo 
{
    var int Value_Initial;
    var int Value_ToSend;
    var EGuiOptions Id;
};
enum EOptionsGuiMode
{
    GuiMode_BrowserWheel,
    GuiMode_MainMenu,
    GuiMode_NewGame,
    GuiMode_Multiplayer,
};
struct native GamePopulatedOptionPage 
{
    var string PopulationFunc;
    var EGuiOptions Id;
};
struct native SliderOption 
{
    var string TelemetryKey;
    var delegate<AddTelem> AddTelemFunc;
    var string UClass;
    var stringref Label;
    var stringref Story;
    var int Max;
    var int StepSize;
    var int DefaultVal;
    var EGuiOptions Id;
    
    structdefaultproperties
    {
        Max = 100
        StepSize = 5
    }
};
struct native RadioGroupOption 
{
    var string TelemetryKey;
    var delegate<AddTelem> AddTelemFunc;
    var string UClass;
    var OptionText Value0;
    var OptionText Value1;
    var stringref Label;
    var stringref Story;
    var int DefaultVal;
    var EGuiOptions Id;
    
    structdefaultproperties
    {
        Value0 = {Label = $653225, Story = $0, Value = 1}
        Value1 = {Label = $653223, Story = $0, Value = 0}
    }
};
struct native TextSliderOption 
{
    var string TelemetryKey;
    var delegate<AddTelem> AddTelemFunc;
    var array<OptionText> Values;
    var string UClass;
    var stringref Label;
    var stringref Story;
    var int DefaultVal;
    var EGuiOptions Id;
};
struct native OptionPage 
{
    var array<EGuiOptions> Options;
    var stringref Label;
    var stringref Story;
};
struct native OptionText 
{
    var stringref Label;
    var stringref Story;
    var int Value;
};
enum EGuiOptions
{
    OPTION_NULL,
    OPTION_Difficulty,
    OPTION_AutoLvlUp,
    OPTION_Subtitles,
    OPTION_SquadPower,
    OPTION_AutoSave,
    OPTION_ControlBindings,
    OPTION_MouseInvert,
    OPTION_MouseSmooth,
    OPTION_MouseSensitivity,
    OPTION_Resolution,
    OPTION_WindowMode,
    OPTION_Gamma,
    OPTION_Bloom,
    OPTION_DynShadows,
    OPTION_EnvShadows,
    OPTION_FilmGrain,
    OPTION_MusicVolume,
    OPTION_SFXVolume,
    OPTION_DlgVolume,
    OPTION_OnlineTelemetry,
    OPTION_OnlineAutoLogin,
    OPTION_ControllerRumble,
    OPTION_InvertYAxis,
    OPTION_ControllerSensitivity,
    OPTION_StickConfig,
    OPTION_TriggerConfig,
    OPTION_SwapTriggersShoulders,
    OPTION_MotionBlur,
    OPTION_AimAssist,
    OPTION_HideCinematicHelmet,
    OPTION_HenchHelmetOption,
    OPTION_ActionUIHints,
    OPTION_TextLanguage,
    OPTION_VOLanguage,
    OPTION_SpeechLanguage,
    OPTION_MPAutoLvlUp,
    OPTION_MPVoiceChatInputDevice,
    OPTION_MPVoiceChatOutputDevice,
    OPTION_MPVoiceChatVolume,
    OPTION_MPVoiceChatMode,
    OPTION_MPVoiceContinueOnLostFocus,
    OPTION_AutoReplyMode,
    OPTION_AudioDynamicRange,
    OPTION_Hints,
    OPTION_AntiAliasing,
    OPTION_CONTENT_1,
    OPTION_CONTENT_2,
    OPTION_CONTENT_3,
    OPTION_CONTENT_4,
    OPTION_CONTENT_5,
    OPTION_CONTENT_6,
    OPTION_CONTENT_7,
    OPTION_CONTENT_8,
    OPTION_CONTENT_9,
    OPTION_CONTENT_10,
    OPTION_CONTENT_11,
    OPTION_CONTENT_12,
    OPTION_CONTENT_13,
    OPTION_CONTENT_14,
    OPTION_CONTENT_15,
    OPTION_CONTENT_16,
    OPTION_CONTENT_17,
    OPTION_CONTENT_18,
    OPTION_CONTENT_19,
    OPTION_CONTENT_20,
    OPTION_CONTENT_21,
    OPTION_CONTENT_22,
    OPTION_CONTENT_23,
    OPTION_CONTENT_24,
    OPTION_CONTENT_25,
};
const Option_ConfirmCancelExit = 6;
const Option_SaveAndExit = 5;
const Option_SetOption = 4;
const Option_Initialize = 3;
const Option_ResetDefaults = 2;
const Option_Close = 1;

var array<SFXGUI_OptionsObject> m_aContentOptions;
var array<int> m_lstOptsToReset;
var transient array<OptionTelemetryInfo> TelemetryInfo;
var config array<TextSliderOption> TextSliderOptions;
var config array<RadioGroupOption> RadioGroupOptions;
var config array<SliderOption> SliderOptions;
var config array<GamePopulatedOptionPage> GamePopulatedOptionPages;
var config array<OptionPage> OptionPages;
var config array<OptionPage> NewGameOptionPages;
var config array<OptionPage> MPOptionPages;
var config array<Name> IgnoreDifficultyMapNames;
var delegate<AddTelem> __AddTelem__Delegate;
var delegate<OnCloseCallback> __OnCloseCallback__Delegate;
var(BioSFHandler_Options) transient stringref ResetToDefaultsText;
var(BioSFHandler_Options) transient stringref ConfirmResetToDefaultsText;
var(BioSFHandler_Options) transient stringref CancelResetToDefaultsText;
var(BioSFHandler_Options) transient stringref ExitConfirmText;
var(BioSFHandler_Options) transient stringref ConfirmExitFromMenuText;
var(BioSFHandler_Options) transient stringref CancelExitFromMenuText;
var stringref srSkipConfirm;
var stringref srYes;
var stringref srNo;
var config stringref ResolutionStory;
var config int GammaLevels;
var config stringref GammaStory;
var config stringref VCInputStory;
var config stringref VCOutputStory;
var export SFXProfileSettings NewSettings;
var(BioSFHandler_Options) bool m_bSelfPanelClose;
var(BioSFHandler_Options) bool bWaitingOnMsgBox;
var(BioSFHandler_Options) transient EOptionsGuiMode GuiMode;
var EDifficultyOptions CachedDifficulty;

public static delegate function AddTelem(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value);

public static native function AddTelem_Language(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value);

public static native function AddTelem_Resolution(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value);

public static native function AddTelem_VCInput(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value);

public static native function AddTelem_VCOutput(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value);

public static event function AddTelemetryInfo(out array<TelemetryAttribute> Attributes, EGuiOptions eOptionId, int Value)
{
    local string TelemetryKey;
    local delegate<AddTelem> AddTelemFunc;
    local int OptionIndex;
    
    TelemetryKey = "";
    AddTelemFunc = AddTelem_Int;
    OptionIndex = default.TextSliderOptions.Find('Id', eOptionId);
    if (OptionIndex != -1)
    {
        TelemetryKey = default.TextSliderOptions[OptionIndex].TelemetryKey;
        if (default.TextSliderOptions[OptionIndex].AddTelemFunc != None)
        {
            AddTelemFunc = default.TextSliderOptions[OptionIndex].AddTelemFunc;
        }
        else
        {
            AddTelemFunc = AddTelem_Int;
        }
    }
    else
    {
        OptionIndex = default.RadioGroupOptions.Find('Id', eOptionId);
        if (OptionIndex != -1)
        {
            TelemetryKey = default.RadioGroupOptions[OptionIndex].TelemetryKey;
            if (default.RadioGroupOptions[OptionIndex].AddTelemFunc != None)
            {
                AddTelemFunc = default.RadioGroupOptions[OptionIndex].AddTelemFunc;
            }
            else
            {
                AddTelemFunc = AddTelem_Bool;
            }
        }
        else
        {
            OptionIndex = default.SliderOptions.Find('Id', eOptionId);
            if (OptionIndex != -1)
            {
                TelemetryKey = default.SliderOptions[OptionIndex].TelemetryKey;
                if (default.SliderOptions[OptionIndex].AddTelemFunc != None)
                {
                    AddTelemFunc = default.SliderOptions[OptionIndex].AddTelemFunc;
                }
                else
                {
                    AddTelemFunc = AddTelem_Int;
                }
            }
        }
    }
    if (Len(TelemetryKey) > 0)
    {
        AddTelemFunc(Attributes, TelemetryKey, eOptionId, Value);
    }
}
public native function EProfileSetting GetProfileSettingForOption(int Type);

public native function GetProfileSettingsForOptions(out array<EProfileSetting> lstProfSettings, const out array<int> lstTypes);

public static native function InitSystemSettingsCache();

public delegate function OnCloseCallback();

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
    GetSFXUIController().HideMainMenu();
}
public event function OnStart()
{
    local BioPlayerController PC;
    
    Super(SFXGUIMovie).OnStart();
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        CachedDifficulty = PC.ProfileSettings.GetDifficultyConfigOption();
    }
}
public function ResetToDefaults(string sPackedIDs)
{
    local SFXGUIInteraction GuiMan;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        Helper_CreateResetConfirmPopup(GuiMan, Callback_ResetToDefaults);
    }
    Helper_ExtractPackedOptIDs(m_lstOptsToReset, sPackedIDs);
}
public native function SendTelemetryChanges();

public static native function SendTelemetryDump(Name Hook);

public native function SetOption(int Type, int Value);

public native function SetOptionsOnGUI(SFXProfileSettings Settings);

public native function UpdateAudioVolumeSettings(SFXProfileSettings ReadFrom);

public native function UpdateDisplayGamma(SFXProfileSettings ReadFrom);

public native function UpdateSpeechLanguageOptions(SFXGUI_Option_TextLanguage TextOption);

public static function AddTelem_Bool(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value)
{
    Attributes.Add(1);
    Attributes[Attributes.Length - 1].Type = ETelemetryAttributeType.AttributeType_Bool;
    Attributes[Attributes.Length - 1].Key = Class'SFXTelemetry'.static.FStringToFourCC(TelemetryKey);
    Attributes[Attributes.Length - 1].bData = Value == 0 ? FALSE : TRUE;
}
public static function AddTelem_Brightness(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value)
{
    Attributes.Add(1);
    Attributes[Attributes.Length - 1].Type = ETelemetryAttributeType.AttributeType_Int;
    Attributes[Attributes.Length - 1].Key = Class'SFXTelemetry'.static.FStringToFourCC(TelemetryKey);
    Attributes[Attributes.Length - 1].nData = Value - 5;
}
public static function AddTelem_Int(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value)
{
    Attributes.Add(1);
    Attributes[Attributes.Length - 1].Type = ETelemetryAttributeType.AttributeType_Int;
    Attributes[Attributes.Length - 1].Key = Class'SFXTelemetry'.static.FStringToFourCC(TelemetryKey);
    Attributes[Attributes.Length - 1].nData = Value;
}
public static function AddTelem_InvBool(out array<TelemetryAttribute> Attributes, const out string TelemetryKey, EGuiOptions eOptionId, int Value)
{
    Attributes.Add(1);
    Attributes[Attributes.Length - 1].Type = ETelemetryAttributeType.AttributeType_Bool;
    Attributes[Attributes.Length - 1].Key = Class'SFXTelemetry'.static.FStringToFourCC(TelemetryKey);
    Attributes[Attributes.Length - 1].bData = Value == 0 ? TRUE : FALSE;
}
public function Callback_ResetToDefaults(bool bAPressed, int Context)
{
    local BioPlayerController PC;
    local array<EProfileSetting> lstProfileSettings;
    local SFXGUI_Option_TextLanguage TextLanguageOption;
    local int nContentOption;
    
    if (bAPressed)
    {
        PC = BioPlayerController(GetPC());
        if (PC != None)
        {
            GetProfileSettingsForOptions(lstProfileSettings, m_lstOptsToReset);
            NewSettings.SetToDefaultsEx(lstProfileSettings);
            for (nContentOption = 0; nContentOption < m_aContentOptions.Length; ++nContentOption)
            {
                if (m_aContentOptions[nContentOption].OptionIsAvailable())
                {
                    m_aContentOptions[nContentOption].ResetToDefault();
                    if (int(m_aContentOptions[nContentOption].OptionId) == 33)
                    {
                        TextLanguageOption = SFXGUI_Option_TextLanguage(m_aContentOptions[nContentOption]);
                        UpdateSpeechLanguageOptions(TextLanguageOption);
                    }
                }
            }
            SetOptionsOnGUI(NewSettings);
            UpdateDisplayGamma(NewSettings);
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public final function CloseGui()
{
    local SFXGUIInteraction GuiMan;
    local BioPlayerController PC;
    local BioWorldInfo BWI;
    
    PC = BioPlayerController(GetPC());
    BWI = BioWorldInfo(PC.WorldInfo);
    if (__OnCloseCallback__Delegate != None)
    {
        __OnCloseCallback__Delegate();
    }
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        switch (GuiMode)
        {
            case EOptionsGuiMode.GuiMode_MainMenu:
                SendTelemetryChanges();
                GuiMan.ShowMainMenu();
                if (m_bSelfPanelClose)
                {
                    GuiMan.RemovePanel(oPanel);
                }
                break;
            case EOptionsGuiMode.GuiMode_BrowserWheel:
                SendTelemetryChanges();
                GuiMan.ReturnToBrowserWheel(oPanel);
                break;
            case EOptionsGuiMode.GuiMode_NewGame:
                SendTelemetryDump('TelemetryHook_Option_GameStart');
                GuiMan.StopGuiSound('NewGameOptions');
                if (m_bSelfPanelClose)
                {
                    GuiMan.RemovePanel(oPanel);
                }
                break;
            case EOptionsGuiMode.GuiMode_Multiplayer:
                SendTelemetryChanges();
                if (m_bSelfPanelClose)
                {
                    GuiMan.RemovePanel(oPanel);
                }
                break;
            default:
        }
    }
    bWaitingOnMsgBox = FALSE;
    __OnCloseCallback__Delegate = None;
    if (BWI != None && IgnoreDifficultyMapNames.Find(Name(BWI.GetMapName())) == -1 && int(PC.ProfileSettings.GetDifficultyConfigOption()) != int(CachedDifficulty))
    {
        BWI.GetGlobalVariables().SetBoolByName('ChangedDifficulty', TRUE);
    }
}
public function Helper_CreateResetConfirmPopup(SFXGUIInteraction GuiMan, delegate<BioSFHandler_MessageBox.InputCallback> pInputDelegate)
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    messageBox = GuiMan.CreateMessageBox(GetPC());
    messageBox.SetInputDelegate(pInputDelegate);
    Params.srAText = ConfirmResetToDefaultsText;
    Params.srBText = CancelResetToDefaultsText;
    Params.bNoFade = TRUE;
    messageBox.DisplayMessageBox(ResetToDefaultsText, Params);
    bWaitingOnMsgBox = TRUE;
}
public function Helper_ExtractPackedOptIDs(out array<int> lstOptIDs, string sPackedIDs)
{
    local int i;
    local array<string> lstStringParts;
    
    if (Len(sPackedIDs) > 0)
    {
        ParseStringIntoArray(sPackedIDs, lstStringParts, ",", TRUE);
        lstOptIDs.Length = lstStringParts.Length;
        for (i = 0; i < lstStringParts.Length; ++i)
        {
            lstOptIDs[i] = int(lstStringParts[i]);
        }
    }
    else
    {
        lstOptIDs.Length = 0;
    }
}
public function MovieLoaded()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC == None)
    {
        return;
    }
    if (GuiMode == EOptionsGuiMode.GuiMode_NewGame)
    {
        PlayGuiSound('NewGameOptions');
    }
    NewSettings.SetToDefaults();
    NewSettings = PC.ProfileSettings;
    m_aContentOptions.Length = 0;
    SetOptionsOnGUI(NewSettings);
}
public function SaveAndExit()
{
    local int nContentOption;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC == None)
    {
        return;
    }
    PC.SaveProfile();
    UpdateAudioVolumeSettings(PC.ProfileSettings);
    for (nContentOption = 0; nContentOption < m_aContentOptions.Length; ++nContentOption)
    {
        if (m_aContentOptions[nContentOption].OptionIsAvailable())
        {
            m_aContentOptions[nContentOption].SaveOption();
        }
    }
    CloseGui();
}
public function SetOnCloseCallback(delegate<OnCloseCallback> fn_OnCloseDelegate)
{
    __OnCloseCallback__Delegate = fn_OnCloseDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TextSliderOptions = ({
                          TelemetryKey = "diff", 
                          AddTelemFunc = None, 
                          Values = ({Label = $163187, Story = $163188, Value = 0}, 
                                    {Label = $163189, Story = $664735, Value = 0}, 
                                    {Label = $163193, Story = $163194, Value = 0}, 
                                    {Label = $163195, Story = $664736, Value = 0}, 
                                    {Label = $308434, Story = $308435, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $163185, 
                          Story = $163186, 
                          DefaultVal = 2, 
                          Id = EGuiOptions.OPTION_Difficulty
                         }, 
                         {
                          TelemetryKey = "aurp", 
                          AddTelemFunc = None, 
                          Values = ({Label = $700289, Story = $700290, Value = 0}, 
                                    {Label = $700285, Story = $700286, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $700283, 
                          Story = $700284, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_AutoReplyMode
                         }, 
                         {
                          TelemetryKey = "spal", 
                          AddTelemFunc = None, 
                          Values = ({Label = $163205, Story = $163206, Value = 0}, 
                                    {Label = $163207, Story = $163208, Value = 0}, 
                                    {Label = $163209, Story = $163210, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $163203, 
                          Story = $0, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_AutoLvlUp
                         }, 
                         {
                          TelemetryKey = "mpal", 
                          AddTelemFunc = AddTelem_InvBool, 
                          Values = ({Label = $653225, Story = $653226, Value = 0}, 
                                    {Label = $653223, Story = $653224, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $653222, 
                          Story = $0, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_MPAutoLvlUp
                         }, 
                         {
                          TelemetryKey = "res", 
                          AddTelemFunc = AddTelem_Resolution, 
                          Values = (), 
                          UClass = "", 
                          Label = $338308, 
                          Story = $338309, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_Resolution
                         }, 
                         {
                          TelemetryKey = "wmod", 
                          AddTelemFunc = None, 
                          Values = ({Label = $345305, Story = $345306, Value = 0}, 
                                    {Label = $345307, Story = $345308, Value = 0}, 
                                    {Label = $345309, Story = $345310, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $345304, 
                          Story = $0, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_WindowMode
                         }, 
                         {
                          TelemetryKey = "brig", 
                          AddTelemFunc = AddTelem_Brightness, 
                          Values = (), 
                          UClass = "", 
                          Label = $350554, 
                          Story = $350555, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_Gamma
                         }, 
                         {
                          TelemetryKey = "tlng", 
                          AddTelemFunc = AddTelem_Language, 
                          Values = (), 
                          UClass = "SFXGame.SFXGUI_Option_TextLanguage", 
                          Label = $652180, 
                          Story = $652181, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_TextLanguage
                         }, 
                         {
                          TelemetryKey = "vlng", 
                          AddTelemFunc = AddTelem_Language, 
                          Values = (), 
                          UClass = "SFXGame.SFXGUI_Option_VOLanguage", 
                          Label = $652198, 
                          Story = $652199, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_VOLanguage
                         }, 
                         {
                          TelemetryKey = "slng", 
                          AddTelemFunc = AddTelem_Language, 
                          Values = (), 
                          UClass = "SFXGame.SFXGUI_Option_SpeechLanguage", 
                          Label = $652197, 
                          Story = $652200, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_SpeechLanguage
                         }, 
                         {
                          TelemetryKey = "csns", 
                          AddTelemFunc = None, 
                          Values = ({Label = $163486, Story = $163487, Value = 0}, 
                                    {Label = $163488, Story = $163489, Value = 0}, 
                                    {Label = $163490, Story = $163491, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $163483, 
                          Story = $0, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_ControllerSensitivity
                         }, 
                         {
                          TelemetryKey = "stkc", 
                          AddTelemFunc = None, 
                          Values = ({Label = $163476, Story = $163477, Value = 0}, 
                                    {Label = $163478, Story = $325608, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $163475, 
                          Story = $0, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_StickConfig
                         }, 
                         {
                          TelemetryKey = "trgc", 
                          AddTelemFunc = None, 
                          Values = ({Label = $325610, Story = $325611, Value = 0}, 
                                    {Label = $325612, Story = $325613, Value = 0}, 
                                    {Label = $389256, Story = $389257, Value = 0}, 
                                    {Label = $389258, Story = $389259, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $325609, 
                          Story = $0, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_TriggerConfig
                         }, 
                         {
                          TelemetryKey = "vcid", 
                          AddTelemFunc = AddTelem_VCInput, 
                          Values = (), 
                          UClass = "", 
                          Label = $661520, 
                          Story = $661523, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MPVoiceChatInputDevice
                         }, 
                         {
                          TelemetryKey = "vcod", 
                          AddTelemFunc = AddTelem_VCOutput, 
                          Values = (), 
                          UClass = "", 
                          Label = $661521, 
                          Story = $661524, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MPVoiceChatOutputDevice
                         }, 
                         {
                          TelemetryKey = "", 
                          AddTelemFunc = None, 
                          Values = ({Label = $708509, Story = $708512, Value = 0}, 
                                    {Label = $708510, Story = $708513, Value = 0}, 
                                    {Label = $708511, Story = $708514, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $708505, 
                          Story = $708506, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MPVoiceChatMode
                         }, 
                         {
                          TelemetryKey = "hhmt", 
                          AddTelemFunc = None, 
                          Values = ({Label = $724221, Story = $724222, Value = 0}, 
                                    {Label = $717055, Story = $724223, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $579348, 
                          Story = $579349, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_HideCinematicHelmet
                         }, 
                         {
                          TelemetryKey = "henh", 
                          AddTelemFunc = None, 
                          Values = ({Label = $717051, Story = $717052, Value = 0}, 
                                    {Label = $717053, Story = $717054, Value = 0}, 
                                    {Label = $717055, Story = $717056, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $717049, 
                          Story = $717050, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_HenchHelmetOption
                         }, 
                         {
                          TelemetryKey = "", 
                          AddTelemFunc = None, 
                          Values = ({Label = $720494, Story = $720496, Value = 0}, 
                                    {Label = $720495, Story = $720496, Value = 0}
                                   ), 
                          UClass = "", 
                          Label = $720493, 
                          Story = $720496, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_AudioDynamicRange
                         }
                        )
    RadioGroupOptions = ({
                          TelemetryKey = "subt", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $163235, 
                          Story = $163236, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_Subtitles
                         }, 
                         {
                          TelemetryKey = "sqdp", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $165462, 
                          Story = $165463, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_SquadPower
                         }, 
                         {
                          TelemetryKey = "ausv", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $172927, 
                          Story = $172928, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_AutoSave
                         }, 
                         {
                          TelemetryKey = "minv", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $338304, 
                          Story = $338305, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MouseInvert
                         }, 
                         {
                          TelemetryKey = "msmo", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $361868, 
                          Story = $361869, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MouseSmooth
                         }, 
                         {
                          TelemetryKey = "aals", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $722771, 
                          Story = $724395, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_AntiAliasing
                         }, 
                         {
                          TelemetryKey = "dshd", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $338314, 
                          Story = $338315, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_DynShadows
                         }, 
                         {
                          TelemetryKey = "tlmt", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $345453, 
                          Story = $345454, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_OnlineTelemetry
                         }, 
                         {
                          TelemetryKey = "auli", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $345449, 
                          Story = $616958, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_OnlineAutoLogin
                         }, 
                         {
                          TelemetryKey = "crmb", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $163479, 
                          Story = $163480, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_ControllerRumble
                         }, 
                         {
                          TelemetryKey = "yinv", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $163221, 
                          Story = $163222, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_InvertYAxis
                         }, 
                         {
                          TelemetryKey = "hint", 
                          AddTelemFunc = AddTelem_InvBool, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 0}, 
                          Value1 = {Label = $653223, Story = $0, Value = 1}, 
                          Label = $723078, 
                          Story = $723079, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_Hints
                         }, 
                         {
                          TelemetryKey = "auih", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $579209, 
                          Story = $579210, 
                          DefaultVal = 1, 
                          Id = EGuiOptions.OPTION_ActionUIHints
                         }, 
                         {
                          TelemetryKey = "", 
                          AddTelemFunc = None, 
                          UClass = "", 
                          Value0 = {Label = $653225, Story = $0, Value = 1}, 
                          Value1 = {Label = $653223, Story = $0, Value = 0}, 
                          Label = $724749, 
                          Story = $724750, 
                          DefaultVal = 0, 
                          Id = EGuiOptions.OPTION_MPVoiceContinueOnLostFocus
                         }
                        )
    SliderOptions = ({
                      TelemetryKey = "msns", 
                      AddTelemFunc = None, 
                      UClass = "", 
                      Label = $361870, 
                      Story = $361871, 
                      Max = 150, 
                      StepSize = 5, 
                      DefaultVal = 100, 
                      Id = EGuiOptions.OPTION_MouseSensitivity
                     }, 
                     {
                      TelemetryKey = "mvol", 
                      AddTelemFunc = None, 
                      UClass = "", 
                      Label = $163267, 
                      Story = $163268, 
                      Max = 100, 
                      StepSize = 5, 
                      DefaultVal = 100, 
                      Id = EGuiOptions.OPTION_MusicVolume
                     }, 
                     {
                      TelemetryKey = "svol", 
                      AddTelemFunc = None, 
                      UClass = "", 
                      Label = $163269, 
                      Story = $163270, 
                      Max = 100, 
                      StepSize = 5, 
                      DefaultVal = 100, 
                      Id = EGuiOptions.OPTION_SFXVolume
                     }, 
                     {
                      TelemetryKey = "dvol", 
                      AddTelemFunc = None, 
                      UClass = "", 
                      Label = $163271, 
                      Story = $163272, 
                      Max = 100, 
                      StepSize = 5, 
                      DefaultVal = 100, 
                      Id = EGuiOptions.OPTION_DlgVolume
                     }, 
                     {
                      TelemetryKey = "vvol", 
                      AddTelemFunc = None, 
                      UClass = "", 
                      Label = $661522, 
                      Story = $661525, 
                      Max = 100, 
                      StepSize = 5, 
                      DefaultVal = 100, 
                      Id = EGuiOptions.OPTION_MPVoiceChatVolume
                     }
                    )
    GamePopulatedOptionPages = ({PopulationFunc = "BuildControlBindingList", Id = EGuiOptions.OPTION_ControlBindings}
                               )
    OptionPages = ({
                    Options = (EGuiOptions.OPTION_Difficulty, EGuiOptions.OPTION_AutoLvlUp, EGuiOptions.OPTION_SquadPower, EGuiOptions.OPTION_AutoSave, EGuiOptions.OPTION_Hints, EGuiOptions.OPTION_ActionUIHints), 
                    Label = $163117, 
                    Story = $163118
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_AutoReplyMode, EGuiOptions.OPTION_Subtitles, EGuiOptions.OPTION_HideCinematicHelmet, EGuiOptions.OPTION_HenchHelmetOption, EGuiOptions.OPTION_VOLanguage, EGuiOptions.OPTION_TextLanguage), 
                    Label = $163187, 
                    Story = $722109
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_ControlBindings), 
                    Label = $282879, 
                    Story = $282880
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_MouseInvert, EGuiOptions.OPTION_MouseSmooth, EGuiOptions.OPTION_MouseSensitivity), 
                    Label = $338302, 
                    Story = $338303
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_Resolution, EGuiOptions.OPTION_WindowMode, EGuiOptions.OPTION_Gamma, EGuiOptions.OPTION_AntiAliasing, EGuiOptions.OPTION_DynShadows), 
                    Label = $163249, 
                    Story = $163250
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_MusicVolume, 
                               EGuiOptions.OPTION_SFXVolume, 
                               EGuiOptions.OPTION_DlgVolume, 
                               EGuiOptions.OPTION_AudioDynamicRange, 
                               EGuiOptions.OPTION_MPVoiceChatMode, 
                               EGuiOptions.OPTION_MPVoiceContinueOnLostFocus, 
                               EGuiOptions.OPTION_MPVoiceChatInputDevice, 
                               EGuiOptions.OPTION_MPVoiceChatOutputDevice
                              ), 
                    Label = $163265, 
                    Story = $163266
                   }, 
                   {
                    Options = (EGuiOptions.OPTION_OnlineTelemetry), 
                    Label = $345447, 
                    Story = $345448
                   }
                  )
    NewGameOptionPages = ({
                           Options = (EGuiOptions.OPTION_Difficulty, 
                                      EGuiOptions.OPTION_AutoReplyMode, 
                                      EGuiOptions.OPTION_AutoLvlUp, 
                                      EGuiOptions.OPTION_Subtitles, 
                                      EGuiOptions.OPTION_SquadPower, 
                                      EGuiOptions.OPTION_AutoSave, 
                                      EGuiOptions.OPTION_HideCinematicHelmet, 
                                      EGuiOptions.OPTION_HenchHelmetOption, 
                                      EGuiOptions.OPTION_ActionUIHints, 
                                      EGuiOptions.OPTION_SpeechLanguage
                                     ), 
                           Label = $0, 
                           Story = $0
                          }
                         )
    MPOptionPages = ({
                      Options = (EGuiOptions.OPTION_MPAutoLvlUp, EGuiOptions.OPTION_Subtitles, EGuiOptions.OPTION_Hints, EGuiOptions.OPTION_ActionUIHints), 
                      Label = $163117, 
                      Story = $163118
                     }, 
                     {
                      Options = (EGuiOptions.OPTION_ControlBindings), 
                      Label = $282879, 
                      Story = $282880
                     }, 
                     {
                      Options = (EGuiOptions.OPTION_MouseInvert, EGuiOptions.OPTION_MouseSmooth, EGuiOptions.OPTION_MouseSensitivity), 
                      Label = $338302, 
                      Story = $338303
                     }, 
                     {
                      Options = (EGuiOptions.OPTION_Resolution, EGuiOptions.OPTION_WindowMode, EGuiOptions.OPTION_Gamma, EGuiOptions.OPTION_AntiAliasing, EGuiOptions.OPTION_DynShadows), 
                      Label = $163249, 
                      Story = $163250
                     }, 
                     {
                      Options = (EGuiOptions.OPTION_MusicVolume, 
                                 EGuiOptions.OPTION_SFXVolume, 
                                 EGuiOptions.OPTION_DlgVolume, 
                                 EGuiOptions.OPTION_AudioDynamicRange, 
                                 EGuiOptions.OPTION_MPVoiceChatMode, 
                                 EGuiOptions.OPTION_MPVoiceContinueOnLostFocus, 
                                 EGuiOptions.OPTION_MPVoiceChatInputDevice, 
                                 EGuiOptions.OPTION_MPVoiceChatOutputDevice
                                ), 
                      Label = $163265, 
                      Story = $163266
                     }, 
                     {
                      Options = (EGuiOptions.OPTION_OnlineTelemetry), 
                      Label = $345447, 
                      Story = $345448
                     }
                    )
    IgnoreDifficultyMapNames = ('Biop_ProEar')
    ResetToDefaultsText = $169878
    ConfirmResetToDefaultsText = $163219
    CancelResetToDefaultsText = $163220
    ExitConfirmText = $331552
    ConfirmExitFromMenuText = $331553
    CancelExitFromMenuText = $331554
    srSkipConfirm = $348806
    srYes = $147164
    srNo = $343064
    ResolutionStory = $338309
    GammaLevels = 11
    GammaStory = $350555
    VCInputStory = $661523
    VCOutputStory = $661524
    m_bSelfPanelClose = TRUE
    nHandlerID = 28
}