Class SFXSFHandler_AreaMap extends SFXGUIMovieLegacyAdapter
    config(UI);

struct SFXMapLocationData 
{
    var stringref srLocation;
    var int nIndex;
    var SFXAreaMapLayout Floor;
};
struct SFXCharacterMapData 
{
    var PlotIdenfitier PlotId;
    var stringref srCharacter;
    var stringref srLocation;
    var int nValue;
    var int nConditional;
    var int nConditionalParam;
    var SFXAreaMapLayout Floor;
};
struct SFXMapAssetData 
{
    var string Asset;
    var int GroupID;
    var SFXAreaMapLayout Floor;
};
enum SFXAreaMapLayout
{
    AM_CitDock,
    AM_CitEmb,
    AM_CitHosp,
    AM_CitPurg,
    AM_CitCommons,
    AM_CitCamp,
    AM_Biop_nor_1,
    AM_Biop_nor_2,
    AM_Biop_nor_3,
    AM_Biop_nor_4,
    AM_Biop_nor_5,
};

var transient export PostProcessSettings m_PostProcessEffect;
var config array<string> LocationIcons;
var bool m_bFromBrowserWheel;

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            ASScrollDrawer(fValue);
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_RTHUMB:
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_LTHUMB:
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_B_RELEASE:
            OnBeginClose();
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_LT:
            if (IsTriggerShoulderSwapped())
            {
                ScrollRight();
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_LB:
            if (!IsTriggerShoulderSwapped())
            {
                ScrollRight();
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_RT:
            if (IsTriggerShoulderSwapped())
            {
                ScrollLeft();
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_RB:
            if (!IsTriggerShoulderSwapped())
            {
                ScrollLeft();
            }
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public function bool Initialize(bool bFromBrowserWheel)
{
    local SFXAreaMapData oMapData;
    
    m_bFromBrowserWheel = bFromBrowserWheel;
    ASSetTriggerDisplay(!IsTriggerShoulderSwapped());
    oMapData = GetSFXUIController().GetAreaMapData();
    if (oMapData != None)
    {
        SetMap(oMapData);
        ProcessPlayer(oMapData);
        PlayGuiSound('MapOpen');
        if (!m_bFromBrowserWheel)
        {
            PlayGuiSound('BrowserSelectMenu');
            AddDOFEffect();
        }
        ShowAreaMapHint();
        return TRUE;
    }
    return FALSE;
}
public function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
}
public function bool ShowHint(Name HintName)
{
    local HintDefinition oHint;
    local SFXEngine Engine;
    local BioPlayerController PC;
    
    PC = oWorldInfo.GetLocalPlayerController();
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine.GetPlayerVariable(HintName) == 0)
    {
        if (BioHintSystem(PC.HintSystem).FindHintDefinition(HintName, oHint))
        {
            Engine.SetPlayerVariable(HintName, 1);
            GetSFXUIController().ShowPlatformSpecificHint(oHint.DefaultText, oHint.PS3Text, oHint.PCText, oHint.DisplayDuration, oHint.HintPosition);
            return TRUE;
        }
    }
    return FALSE;
}
public function AddDOFEffect()
{
    GetLP().OverridePostProcessSettings(m_PostProcessEffect, oWorldInfo.RealTimeSeconds);
}
public function ASOnBeginClose()
{
    ActionScriptVoid("OnBeginClose");
}
public function ASOnStartScrollLeft()
{
    ActionScriptVoid("OnStartScrollLeft");
}
public function ASOnStartScrollRight()
{
    ActionScriptVoid("OnStartScrollRight");
}
public function ASScrollDrawer(float nScroll)
{
    ActionScriptVoid("ScrollDrawer");
}
public function ASSetMapData(array<string> NewMapAssetList, array<string> NewMapLayoutList, array<string> NewDrawerTextList, int NewMapIndex)
{
    ActionScriptVoid("InitializeMapData");
}
public function ASSetPlayerLocRot(float nPxX, float nPxY, float nRotation)
{
    ActionScriptVoid("SetPlayerLocRot");
}
public function ASSetTriggerDisplay(bool bShowingBumpers)
{
    ActionScriptVoid("SetTriggerDisplay");
}
private final function CloseMap()
{
    GetSFXUIController().CancelHint();
    GetPC().ClearTimer('ShowAreaMapCharactersHint', Self);
    if (!m_bFromBrowserWheel)
    {
        GetSFXUIController().HideAreaMap(GetPC());
    }
    else
    {
        GetSFXUIController().ReturnToBrowserWheel(oPanel, FALSE, GetPC());
    }
}
public function string GetDrawerText(SFXAreaMapData oMapData, SFXAreaMapLayout Floor)
{
    local array<SFXCharacterMapData> CharacterMapData;
    local SFXCharacterMapData CharacterMapDataIter;
    local array<SFXMapLocationData> MapLocationData;
    local SFXMapLocationData MapLocationDataIter;
    local string ToDisplay;
    local int LocationIconIndex;
    
    CharacterMapData = oMapData.GetCharacterData(Floor);
    MapLocationData = oMapData.GetLocationData(Floor);
    foreach MapLocationData(MapLocationDataIter, )
    {
        ToDisplay $= "<b></b>";
        LocationIconIndex = MapLocationDataIter.nIndex - 1;
        if (LocationIconIndex >= 0 && LocationIconIndex < LocationIcons.Length)
        {
            ToDisplay $= LocationIcons[LocationIconIndex];
        }
        ToDisplay = ToDisplay $ "<font color=\"#ffffff\">" $ GetUIString(MapLocationDataIter.srLocation) $ "</font>" $ "\n" $ "<font color=\"#88e7ff\">";
        foreach CharacterMapData(CharacterMapDataIter, )
        {
            if (CharacterMapDataIter.srLocation == MapLocationDataIter.srLocation)
            {
                ToDisplay $= "      " $ GetUIString(CharacterMapDataIter.srCharacter) $ "\n";
            }
        }
        ToDisplay $= "</font>";
    }
    return ToDisplay;
}
public function OnBeginClose()
{
    RemoveDOFEffect();
    ASOnBeginClose();
}
public function PauseMenuAdditionalProcessing()
{
    Initialize(TRUE);
}
public function ProcessPlayer(SFXAreaMapData oMapData)
{
    local SFXPawn_Player pPlayer;
    local float PxX;
    local float PxY;
    local BioPlayerController PC;
    
    if (oWorldInfo != None)
    {
        PC = oWorldInfo.GetLocalPlayerController();
        pPlayer = SFXPawn_Player(PC.Pawn);
    }
    if (oMapData != None && oPanel != None && pPlayer != None)
    {
        if (pPlayer != None)
        {
            oMapData.GetPixelCoordinates(pPlayer.location.X, pPlayer.location.Y, PxX, PxY);
            ASSetPlayerLocRot(PxX, PxY, float(pPlayer.Rotation.Yaw) * 0.00549316406);
        }
    }
}
public function RemoveDOFEffect()
{
    GetLP().ClearPostProcessSettingsOverride(0.25);
}
public function ScrollLeft()
{
    ASOnStartScrollLeft();
}
public function ScrollRight()
{
    ASOnStartScrollRight();
}
public function SetMap(SFXAreaMapData oMapData)
{
    local array<string> MapAssetList;
    local array<string> MapLayoutList;
    local array<string> DrawerTextList;
    local int MapIndex;
    local int Index;
    local array<SFXMapAssetData> AssetData;
    local SFXMapAssetData AssetDataIter;
    
    AssetData = oMapData.GetAssetPaths(oMapData.Floor);
    foreach AssetData(AssetDataIter, Index)
    {
        MapAssetList.AddItem(AssetDataIter.Asset);
        MapLayoutList.AddItem(string(AssetDataIter.Floor));
        DrawerTextList.AddItem(GetDrawerText(oMapData, AssetDataIter.Floor));
        if (int(oMapData.Floor) == int(AssetDataIter.Floor))
        {
            MapIndex = Index;
        }
    }
    ASSetMapData(MapAssetList, MapLayoutList, DrawerTextList, MapIndex);
}
public function ShowAreaMapCharactersHint()
{
    ShowHint('MapCharacterHint');
}
public function ShowAreaMapHint()
{
    if (ShowHint('MapHint'))
    {
        GetPC().SetTimer(5.0, FALSE, 'ShowAreaMapCharactersHint', Self);
    }
    else
    {
        ShowAreaMapCharactersHint();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_PostProcessEffect = {
                           ColorGradingLUT = {
                                              LUTTextures = (), 
                                              LUTWeights = ()
                                             }, 
                           RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}, 
                           DOF_FocusPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                           Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}, 
                           Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}, 
                           Scene_Shadows = {X = 0.0, Y = 0.0, Z = 0.0}, 
                           Bloom_Scale = 1.0, 
                           Bloom_Threshold = 1.0, 
                           Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}, 
                           Bloom_ScreenBlendThreshold = 10.0, 
                           Bloom_InterpolationDuration = 1.0, 
                           DOF_FalloffExponent = 4.0, 
                           DOF_BlurKernelSize = 64.0, 
                           DOF_BlurBloomKernelSize = 16.0, 
                           DOF_MaxNearBlurAmount = 1.0, 
                           DOF_MaxFarBlurAmount = 1.0, 
                           DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                           DOF_FocusInnerRadius = 1.0, 
                           DOF_FocusDistance = 100000.0, 
                           DOF_InterpolationDuration = 0.300000012, 
                           MotionBlur_MaxVelocity = 1.0, 
                           MotionBlur_Amount = 0.5, 
                           MotionBlur_CameraRotationThreshold = 45.0, 
                           MotionBlur_CameraTranslationThreshold = 10000.0, 
                           MotionBlur_InterpolationDuration = 1.0, 
                           Scene_Desaturation = 0.0, 
                           Scene_InterpolationDuration = 1.0, 
                           RimShader_InterpolationDuration = 1.0, 
                           ColorGrading_LookupTable = None, 
                           PP_DesaturationMultiplier = 0.0, 
                           PP_HighlightsMultiplier = 1.0, 
                           PP_MidTonesMultiplier = 1.0, 
                           PP_ShadowsMultiplier = 0.0, 
                           bOverride_EnableBloom = TRUE, 
                           bOverride_EnableDOF = TRUE, 
                           bOverride_EnableMotionBlur = TRUE, 
                           bOverride_EnableSceneEffect = TRUE, 
                           bOverride_AllowAmbientOcclusion = TRUE, 
                           bOverride_OverrideRimShaderColor = TRUE, 
                           bOverride_Bloom_Scale = TRUE, 
                           bOverride_Bloom_Threshold = TRUE, 
                           bOverride_Bloom_Tint = TRUE, 
                           bOverride_Bloom_ScreenBlendThreshold = TRUE, 
                           bOverride_Bloom_InterpolationDuration = TRUE, 
                           bOverride_DOF_FalloffExponent = TRUE, 
                           bOverride_DOF_BlurKernelSize = TRUE, 
                           bOverride_DOF_BlurBloomKernelSize = TRUE, 
                           bOverride_DOF_MaxNearBlurAmount = TRUE, 
                           bOverride_DOF_MaxFarBlurAmount = TRUE, 
                           bOverride_DOF_ModulateBlurColor = TRUE, 
                           bOverride_DOF_FocusType = TRUE, 
                           bOverride_DOF_FocusInnerRadius = TRUE, 
                           bOverride_DOF_FocusDistance = TRUE, 
                           bOverride_DOF_FocusPosition = TRUE, 
                           bOverride_DOF_InterpolationDuration = TRUE, 
                           bOverride_MotionBlur_MaxVelocity = TRUE, 
                           bOverride_MotionBlur_Amount = TRUE, 
                           bOverride_MotionBlur_FullMotionBlur = TRUE, 
                           bOverride_MotionBlur_CameraRotationThreshold = TRUE, 
                           bOverride_MotionBlur_CameraTranslationThreshold = TRUE, 
                           bOverride_MotionBlur_InterpolationDuration = TRUE, 
                           bOverride_Scene_Desaturation = TRUE, 
                           bOverride_Scene_HighLights = TRUE, 
                           bOverride_Scene_MidTones = TRUE, 
                           bOverride_Scene_Shadows = TRUE, 
                           bOverride_Scene_InterpolationDuration = TRUE, 
                           bOverride_RimShader_Color = TRUE, 
                           bOverride_RimShader_InterpolationDuration = TRUE, 
                           bEnableBloom = TRUE, 
                           bEnableDOF = TRUE, 
                           bEnableMotionBlur = TRUE, 
                           bEnableSceneEffect = TRUE, 
                           bAllowAmbientOcclusion = TRUE, 
                           bOverrideRimShaderColor = FALSE, 
                           bOverride_EnableFilmic = TRUE, 
                           bEnableFilmic = TRUE, 
                           bOverride_EnableVignette = TRUE, 
                           bEnableVignette = TRUE, 
                           bOverride_EnableFilmGrain = TRUE, 
                           bEnableFilmGrain = TRUE, 
                           MotionBlur_FullMotionBlur = TRUE, 
                           DOF_FocusType = EFocusType.FOCUS_Distance
                          }
    LocationIcons = ("[AreaMap_Label_01]", 
                     "[AreaMap_Label_02]", 
                     "[AreaMap_Label_03]", 
                     "[AreaMap_Label_04]", 
                     "[AreaMap_Label_05]", 
                     "[AreaMap_Label_06]", 
                     "[AreaMap_Label_07]", 
                     "[AreaMap_Label_08]", 
                     "[AreaMap_Label_09]", 
                     "[AreaMap_Label_10]"
                    )
}