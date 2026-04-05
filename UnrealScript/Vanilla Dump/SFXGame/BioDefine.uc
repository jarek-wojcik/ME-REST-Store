Class BioDefine
    native
    abstract;

enum GAWExternalAssetID
{
    GAWExternalAssetID_Multiplayer,
    GAWExternalAssetID_Iphone,
    GAWExternalAssetID_FaceBook,
};
enum EEndGameOption
{
    EGO_ReapersDestroyedEarthDestroyed,
    EGO_ReapersDestroyedEarthDevastated,
    EGO_ReapersDestroyedEarthOk,
    EGO_ReapersDestroyedEarthOkShepardAlive,
    EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave,
    EGO_BecomeAReaperAndEarthOkAndReapersLeave,
    EGO_HarmonyOfManAndMachine,
    EGO_Demo,
    EGO_None,
};
enum ETargetTipText
{
    TargetTipText_None,
    TargetTipText_Talk,
    TargetTipText_Examine,
    TargetTipText_Use,
    TargetTipText_Open,
    TargetTipText_Salvage,
    TargetTipText_PickUp,
    TargetTipText_Bypass,
    TargetTipText_Support,
    TargetTipText_Reactivate,
    TargetTipText_Deactivate,
    TargetTipText_Activate,
    TargetTipText_Warn,
    TargetTipText_Revive,
};
enum EObjectiveMarkerIconType
{
    EOMIT_None,
    EOMIT_Attack,
    EOMIT_Supply,
    EOMIT_Alert,
};
struct EnemyWaveInfo 
{
    var Name EnemyType;
    var int MinCount;
    var int MaxCount;
    var int MaxPerWave;
};
struct ScarInfo 
{
    var(ScarInfo) Vector2D Threshold;
    var(ScarInfo) string Emissive;
    var(ScarInfo) string Normal;
    var(ScarInfo) string EyeEmissive;
    var(ScarInfo) string FemaleEmissive;
    var(ScarInfo) string FemaleNormal;
    var(ScarInfo) string FemaleEyeEmissive;
    var(ScarInfo) LinearColor Color;
};
struct PowerEvolveStatDetails 
{
    var string Title;
    var string TotalTitle;
    var int Pct;
    var int BonusPct;
};
enum EGAWAssetSubType
{
    GAWAssetSubType_None,
    GAWAssetSubType_Ground,
    GAWAssetSubType_Fleet,
};
enum EGAWAssetType
{
    GAWAssetType_Military,
    GAWAssetType_Device,
    GAWAssetType_Intel,
    GAWAssetType_Artifact,
    GAWAssetType_Salvage,
    GAWAssetType_Treasure,
    GAWAssetType_External,
    GAWAssetType_Modifier,
    GAWAssetType_Quest,
};
enum EAsyncLoadStatus
{
    ASYNC_LOAD_ERROR,
    ASYNC_LOAD_STARTED,
    ASYNC_LOAD_INPROGRESS,
    ASYNC_LOAD_COMPLETE,
};
enum ESFXHUDActionIcon
{
    SFXHUD_Action_NONE,
    SFXHUD_Cover_Enter,
    SFXHUD_Cover_Mantle,
    SFXHUD_Cover_Climb,
    SFXHUD_Cover_90DegreeRight,
    SFXHUD_Cover_90DegreeLeft,
    SFXHUD_Cover_SlipRight,
    SFXHUD_Cover_SlipLeft,
    SFXHUD_Cover_SwatTurnRight,
    SFXHUD_Cover_SwatTurnLeft,
    SFXHUD_Cover_Grab,
    SFXHUD_LadderUp,
    SFXHUD_LadderDown,
    SFXHUD_GapJump,
    SFXHUD_AtlasSuit,
};
enum ESFXHUDPOIIconState
{
    SFXHUD_POI_Off,
    SFXHUD_POI_On,
    SFXHUD_POI_Activated,
};
struct native ASParams 
{
    var string sVar;
    var int nVar;
    var float fVar;
    var bool bVar;
    var ASParamTypes Type;
};
enum ASParamTypes
{
    ASParam_Integer,
    ASParam_Float,
    ASParam_String,
    ASParam_Boolean,
    ASParam_Undefined,
};
struct native BioMessageBoxData 
{
    var init string m_sMessage;
    var BioMessageBoxOptionalParams m_stParams;
    var Name m_nmName;
    var Name m_nmCallbackFunction;
    var int m_nPriority;
    var Object m_pCallbackObject;
    var int m_nContext;
    var int m_nControllerId;
    var bool m_bPersistThroughTravel;
    var bool m_bWasGamePaused;
    var bool m_bIsWeaponChoiceDlg;
};
struct native BioMessageBoxOptionalParams 
{
    var stringref srAText;
    var stringref srBText;
    var int nIconIndex;
    var bool bNoFade;
    var bool bModal;
    var bool bForcePlayersOnly;
    var BioMessageBoxIconSets nIconSet;
    var SFX_MB_Skin m_SkinType;
    var SFX_MB_TextAlign m_TextAlign;
};
enum SFX_MB_TextAlign
{
    SFX_MB_Centered,
    SFX_MB_Left,
    SFX_MB_Right,
};
enum SFX_MB_Skin
{
    SFX_MB_Skin_User,
    SFX_MB_Skin_Shepard,
};
enum SFXGenericHintIcon
{
    HINTICON_None,
};
enum SFXPCHintIcon
{
    PCICON_None,
};
enum SFXPS3HintIcon
{
    PS3ICON_None,
};
enum SFXXBoxHintIcon
{
    XBICON_None,
    XBICON_XBOX_A,
    XBICON_XBOX_B,
    XBICON_XBOX_Y,
    XBICON_XBOX_X,
    XBICON_XBOX_Right_Thumb,
    XBICON_XBOX_Right_Thumb_Pressed,
    XBICON_XBOX_Right_Thumb_Released,
    XBICON_XBOX_Left_Thumb,
    XBICON_XBOX_Left_Thumb_Pressed,
    XBICON_XBOX_Left_Thumb_Released,
    XBICON_XBOX_Right_Thumb_Up,
    XBICON_XBOX_Right_Thumb_UpRight,
    XBICON_XBOX_Right_Thumb_Right,
    XBICON_XBOX_Right_Thumb_DownRight,
    XBICON_XBOX_Right_Thumb_Down,
    XBICON_XBOX_Right_Thumb_DownLeft,
    XBICON_XBOX_Right_Thumb_Left,
    XBICON_XBOX_Right_Thumb_UpLeft,
    XBICON_XBOX_Left_Thumb_Up,
    XBICON_XBOX_Left_Thumb_UpRight,
    XBICON_XBOX_Left_Thumb_Right,
    XBICON_XBOX_Left_Thumb_DownRight,
    XBICON_XBOX_Left_Thumb_Down,
    XBICON_XBOX_Left_Thumb_DownLeft,
    XBICON_XBOX_Left_Thumb_Left,
    XBICON_XBOX_Left_Thumb_UpLeft,
    XBICON_XBOX_DPad,
    XBICON_XBOX_DPad_Up,
    XBICON_XBOX_DPad_Right,
    XBICON_XBOX_DPad_Down,
    XBICON_XBOX_DPad_Left,
    XBICON_XBOX_Start,
    XBICON_XBOX_Back,
    XBICON_XBOX_Right_Shoulder,
    XBICON_XBOX_Right_Trigger,
    XBICON_XBOX_Left_Shoulder,
    XBICON_XBOX_Left_Trigger,
};
enum SFXHintPosition
{
    SFXHINTPOS_Top,
    SFXHINTPOS_Middle,
    SFXHINTPOS_Bottom,
};
enum BioMessageBoxIconSets
{
    ICONSET_None,
    ICONSET_Manufacturer,
    ICONSET_Combat,
    ICONSET_Plot,
    ICONSET_ItemProperties,
};
enum Cerberus3DState
{
    C3D_Default,
    C3D_RightPanel_Open,
    C3D_RightPanel_Closed,
    C3D_RightPanel_Opening,
    C3D_RightPanel_Closing,
};
enum SFXDisplayableSquadCommands
{
    SFX_DSC_READY,
    SFX_DSC_ATTACK,
    SFX_DSC_MOVETO,
    SFX_DSC_FOLLOW,
};
enum BioTutorialPosition
{
    BTP_Top,
    BTP_Bottom,
    BTP_MessageBox,
};
enum SFMovieStrokeStyle
{
    SF_MSS_Correct,
    SF_MSS_Normal,
    SF_MSS_Hairline,
};
enum BioThumbstickDir
{
    BTD_Centered,
    BTD_Negative,
    BTD_Positive,
};
enum BioGuiEvents
{
    BIOGUI_EVENT_ON_ENTER,
    BIOGUI_EVENT_ON_EXIT,
    BIOGUI_EVENT_AXIS_LSTICK_X,
    BIOGUI_EVENT_AXIS_LSTICK_Y,
    BIOGUI_EVENT_AXIS_RSTICK_X,
    BIOGUI_EVENT_AXIS_RSTICK_Y,
    BIOGUI_EVENT_AXIS_MOUSE_X,
    BIOGUI_EVENT_AXIS_MOUSE_Y,
    BIOGUI_EVENT_KEY_WHEEL_UP,
    BIOGUI_EVENT_KEY_WHEEL_DOWN,
    BIOGUI_EVENT_CONTROL_COOLDOWN_EXPIRE,
    BIOGUI_EVENT_CONTROL_DOWN,
    BIOGUI_EVENT_CONTROL_LEFT,
    BIOGUI_EVENT_CONTROL_RIGHT,
    BIOGUI_EVENT_CONTROL_UP,
    BIOGUI_EVENT_BUTTON_A,
    BIOGUI_EVENT_BUTTON_B,
    BIOGUI_EVENT_BUTTON_X,
    BIOGUI_EVENT_BUTTON_Y,
    BIOGUI_EVENT_BUTTON_LT,
    BIOGUI_EVENT_BUTTON_RT,
    BIOGUI_EVENT_BUTTON_LB,
    BIOGUI_EVENT_BUTTON_RB,
    BIOGUI_EVENT_BUTTON_BACK,
    BIOGUI_EVENT_BUTTON_START,
    BIOGUI_EVENT_BUTTON_LTHUMB,
    BIOGUI_EVENT_BUTTON_RTHUMB,
    BIOGUI_EVENT_KEY_ESCAPE,
    BIOGUI_EVENT_KEY_DELETE,
    BIOGUI_EVENT_KEY_TAB,
    BIOGUI_EVENT_MOUSE_BUTTON_RIGHT,
    BIOGUI_EVENT_MOUSE_BUTTON_LEFT,
    BIOGUI_EVENT_CONTROL_DOWN_RELEASE,
    BIOGUI_EVENT_CONTROL_LEFT_RELEASE,
    BIOGUI_EVENT_CONTROL_RIGHT_RELEASE,
    BIOGUI_EVENT_CONTROL_UP_RELEASE,
    BIOGUI_EVENT_BUTTON_A_RELEASE,
    BIOGUI_EVENT_BUTTON_B_RELEASE,
    BIOGUI_EVENT_BUTTON_X_RELEASE,
    BIOGUI_EVENT_BUTTON_Y_RELEASE,
    BIOGUI_EVENT_BUTTON_LT_RELEASE,
    BIOGUI_EVENT_BUTTON_RT_RELEASE,
    BIOGUI_EVENT_BUTTON_LB_RELEASE,
    BIOGUI_EVENT_BUTTON_RB_RELEASE,
    BIOGUI_EVENT_BUTTON_BACK_RELEASE,
    BIOGUI_EVENT_BUTTON_START_RELEASE,
    BIOGUI_EVENT_BUTTON_LTHUMB_RELEASE,
    BIOGUI_EVENT_BUTTON_RTHUMB_RELEASE,
    BIOGUI_EVENT_KEY_ESCAPE_RELEASE,
    BIOGUI_EVENT_KEY_DELETE_RELEASE,
    BIOGUI_EVENT_KEY_TAB_RELEASE,
    BIOGUI_EVENT_MOUSE_BUTTON_RIGHT_RELEASE,
    BIOGUI_EVENT_MOUSE_BUTTON_LEFT_RELEASE,
};
enum EGuiHandlers
{
    GUI_HANDLER_NONE,
    GUI_HANDLER_INVENTORY,
    GUI_HANDLER_INGAMEGUI,
    GUI_HANDLER_CHARACTER_RECORD,
    GUI_HANDLER_LOOT,
    GUI_HANDLER_CONVERSATION,
    GUI_HANDLER_SHOP,
    GUI_HANDLER_GALAXYMAP,
    GUI_HANDLER_MAINMENU,
    GUI_HANDLER_NEW_CHARACTER,
    GUI_HANDLER_SELECT_CHARACTER,
    GUI_HANDLER_JOURNAL,
    GUI_HANDLER_HUD,
    GUI_HANDLER_PARTYSELECT,
    GUI_HANDLER_XMODS,
    GUI_HANDLER_SQUADCOMMAND,
    GUI_HANDLER_DATACODEX,
    GUI_HANDLER_SAVELOAD,
    GUI_HANDLER_ACHIEVEMENT,
    GUI_HANDLER_AREAMAP,
    GUI_HANDLER_SHAREDINGAMEGUI,
    GUI_HANDLER_MENUBROWSER,
    GUI_HANDLER_GAMEOVER,
    GUI_HANDLER_SPECIALIZATION,
    GUI_HANDLER_MESSAGEBOX,
    GUI_HANDLER_INTROTEXT,
    GUI_HANDLER_BLACKSCREEN,
    GUI_HANDLER_CREDITS,
    GUI_HANDLER_OPTIONS,
    GUI_HANDLER_ADDITONALCONTENT,
    GUI_HANDLER_SKILLGAME,
    GUI_HANDLER_SPLASH_SCREEN,
    GUI_HANDLER_REPLAYCHARACTERSELECT,
    GUI_HANDLER_CHOICEGUI,
    GUI_HANDLER_SNIPEROVERLAY,
};
struct HenchmanInfoStruct 
{
    var Name className;
    var Name Tag;
    var stringref PrettyName;
    var stringref AlternatePrettyName;
    var Name AlternateHenchNamePlotFlag;
    var int HenchAcquiredPlotID;
    var int HenchInSquadPlotID;
    var string HenchmanImage;
};
struct native BioDiscoveredCodex extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var init array<BioDiscoveredCodexPage> lstDiscoveredPages;
};
struct native BioDiscoveredCodexPage extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var int nPage;
    var bool bNew;
};
struct native BioCodexSection extends BioCodexEntry 
{
    var const transient native noexport Pointer VfTable;
    var bool bPrimary;
};
struct native BioCodexPage extends BioCodexEntry 
{
    var const transient native noexport Pointer VfTable;
    var int nSection;
};
struct native BioCodexEntry extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var stringref srTitle;
    var stringref srDescription;
    var int nTextureIndex;
    var int nPriority;
    var WwiseEvent CodexSound;
};
struct native BioStateTaskList extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var init array<BioTaskEval> lstTaskEvals;
};
struct native BioTaskEval extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var int nQuest;
    var int nTask;
    var int nConditional;
    var int nState;
};
struct native BioQuest extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var init array<BioQuestGoal> lstGoals;
    var init array<BioQuestTask> lstTasks;
    var init array<BioPlotItem> lstPlotItems;
    var bool bMission;
};
struct native BioPlotItem extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var stringref srName;
    var int nIconIndex;
    var int nConditional;
    var int nState;
    var int nTargetItems;
};
struct native BioQuestTask extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var init array<int> lstPlotItemIndices;
    var init string sWaypointTag;
    var init Name nmPlanet;
    var stringref srName;
    var stringref srDescription;
    var bool bQuestCompleteTask;
};
struct native BioQuestGoal extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var stringref srName;
    var stringref srDescription;
    var int nConditional;
    var int nState;
};
struct native BioQuestProgress extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var init array<int> lstTaskHistory;
    var int nQuestAdded;
    var int nActiveGoal;
    var bool bQuestUpdated;
};
struct native BioSEESubstate extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var init array<int> lstSiblingIndices;
    var int nGlobalBool;
    var int nParentIndex;
    var bool bNewState;
    var bool bUseParam;
    var bool bParentTypeOr;
};
struct native BioSEELocalInt extends BioSEELocal 
{
    var const transient native noexport Pointer VfTable;
    var int nNewValue;
};
struct native BioSEELocalFloat extends BioSEELocal 
{
    var const transient native noexport Pointer VfTable;
    var float fNewValue;
};
struct native BioSEELocalBool extends BioSEELocal 
{
    var const transient native noexport Pointer VfTable;
    var bool bNewValue;
};
struct native BioSEELocal extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var init Name ObjectTag;
    var init Name FunctionName;
    var int nObjectType;
    var bool bUseParam;
};
struct native BioSEEInt extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var int nGlobalInt;
    var int nNewValue;
    var bool bUseParam;
    var bool bIncrement;
};
struct native BioSEEFunction extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var init Name FunctionPackage;
    var init Name FunctionClass;
    var init Name FunctionName;
    var int nParameter;
};
struct native BioSEEFloat extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var int nGlobalFloat;
    var float fNewValue;
    var bool bUseParam;
    var bool bIncrement;
};
struct native BioSEEConsequence extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var int nConsequence;
};
struct native BioSEEBool extends BioStateEventElement 
{
    var const transient native noexport Pointer VfTable;
    var int nGlobalBool;
    var bool bNewState;
    var bool bUseParam;
};
struct native BioStateEvent extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
    var native init array<Pointer> lstEventElements;
};
struct native BioStateEventElement extends BioVersionedNativeObject 
{
    var const transient native noexport Pointer VfTable;
};
struct native BioVersionedNativeObject 
{
    var int nInstanceVersion;
};
enum EResistanceType
{
    ResistanceType_None,
    ResistanceType_Shield,
    ResistanceType_Biotic,
    ResistanceType_Armour,
};
enum ERaceType
{
    RaceType_None,
    RaceType_Humanoid,
    RaceType_Machine,
    RaceType_Animal,
};
enum EAffiliationType
{
    AffiliationType_None,
    AffiliationType_GenericMerc,
    AffiliationType_Reaper,
    AffiliationType_Cerberus,
    AffiliationType_Geth,
};
enum EChallengeType
{
    ChallengeType_None,
    ChallengeType_Minion,
    ChallengeType_Elite,
    ChallengeType_SubBoss,
    ChallengeType_Boss,
};
enum ECharacterType
{
    CharacterType_None,
    CharacterType_Human,
    CharacterType_Cerberus_Trooper,
    CharacterType_Cerberus_Centurion,
    CharacterType_Cerberus_Guardian,
    CharacterType_Cerberus_Nemesis,
    CharacterType_Cerberus_Phantom,
    CharacterType_Cerberus_Engineer,
    CharacterType_Cerberus_Atlas,
    CharacterType_Reaper_Husk,
    CharacterType_Reaper_Cannibal,
    CharacterType_Reaper_Marauder,
    CharacterType_Reaper_Brute,
    CharacterType_Reaper_Ravager,
    CharacterType_Reaper_Banshee,
    CharacterType_Geth_Trooper,
    CharacterType_Geth_Rocket_Trooper,
    CharacterType_Geth_Pyro,
    CharacterType_Geth_Hunter,
    CharacterType_Geth_Prime,
};
enum EStateEventElementTypes
{
    SEE_Bool,
    SEE_Consequence,
    SEE_Float,
    SEE_Function,
    SEE_Int,
    SEE_LocalBool,
    SEE_LocalFloat,
    SEE_LocalInt,
    SEE_Substate,
};
enum ELookAtTransitionType
{
    LookAt_Default,
    LookAt_Locked,
    LookAt_InstantTrans,
};
struct native CustomizableElement 
{
    var(CustomizableElement) PlayerMeshInfo Mesh;
    var(CustomizableElement) array<string> GameEffects;
    var(CustomizableElement) PlayerPatternInfo Pattern;
    var(CustomizableElement) PlayerSpecInfo Spec;
    var(CustomizableElement) PlayerTintInfo Tint;
    var(CustomizableElement) int Id;
    var(CustomizableElement) stringref Name;
    var(CustomizableElement) stringref Description;
    var(CustomizableElement) int PlotFlag;
    var(CustomizableElement) bool bCustomizable;
    var(CustomizableElement) ECustomizableElementType Type;
};
struct native PlayerPatternInfo 
{
    var(PlayerPatternInfo) VectorParameterValue Stripe1Param;
    var(PlayerPatternInfo) VectorParameterValue Stripe2Param;
    var(PlayerPatternInfo) VectorParameterValue Stripe3Param;
};
struct native PlayerTintInfo 
{
    var(PlayerTintInfo) VectorParameterValue TintParam;
    var(PlayerTintInfo) VectorParameterValue PhongParam;
};
struct native PlayerSpecInfo 
{
    var(PlayerSpecInfo) ScalarParameterValue SpecParam;
    var(PlayerSpecInfo) ScalarParameterValue SpecPwrParam;
    var(PlayerSpecInfo) ScalarParameterValue EnvMapParam;
};
struct native PlayerMeshInfo 
{
    var(PlayerMeshInfo) string Male;
    var(PlayerMeshInfo) string MaleVisor;
    var(PlayerMeshInfo) string MaleFaceplate;
    var(PlayerMeshInfo) string MaleMaterialOverride;
    var(PlayerMeshInfo) string Female;
    var(PlayerMeshInfo) string FemaleVisor;
    var(PlayerMeshInfo) string FemaleFaceplate;
    var(PlayerMeshInfo) string FemaleMaterialOverride;
    var(PlayerMeshInfo) bool bHasBreather;
    var(PlayerMeshInfo) bool bHideHead;
    var(PlayerMeshInfo) bool bHideHair;
};
struct native PlayerEmissiveColorValue 
{
    var(PlayerEmissiveColorValue) LinearColor ParameterValue;
    var(PlayerEmissiveColorValue) Name ParameterName;
    var(PlayerEmissiveColorValue) stringref ColorName;
    
    structdefaultproperties
    {
        ParameterName = 'Emissive'
    }
};
struct native PlayerCustomColor3Value 
{
    var(PlayerCustomColor3Value) LinearColor ParameterValue;
    var(PlayerCustomColor3Value) Name ParameterName;
    var(PlayerCustomColor3Value) stringref ColorName;
    
    structdefaultproperties
    {
        ParameterName = 'Tint_Color03'
    }
};
struct native PlayerCustomColor2Value 
{
    var(PlayerCustomColor2Value) LinearColor ParameterValue;
    var(PlayerCustomColor2Value) Name ParameterName;
    var(PlayerCustomColor2Value) stringref ColorName;
    
    structdefaultproperties
    {
        ParameterName = 'Tint_Color02'
    }
};
struct native PlayerCustomColor1Value 
{
    var(PlayerCustomColor1Value) LinearColor ParameterValue;
    var(PlayerCustomColor1Value) LinearColor PhongParameterValue;
    var(PlayerCustomColor1Value) Name ParameterName;
    var(PlayerCustomColor1Value) Name PhongParameterName;
    var(PlayerCustomColor1Value) stringref ColorName;
    
    structdefaultproperties
    {
        ParameterName = 'Tint_Color01'
        PhongParameterName = 'Phong_Spec_Color'
    }
};
struct native PlayerCustomPatternColorValue 
{
    var(PlayerCustomPatternColorValue) LinearColor Stripe1ColorValue;
    var(PlayerCustomPatternColorValue) LinearColor Stripe2ColorValue;
    var(PlayerCustomPatternColorValue) LinearColor Stripe3ColorValue;
    var(PlayerCustomPatternColorValue) Name Stripe1ColorName;
    var(PlayerCustomPatternColorValue) Name Stripe2ColorName;
    var(PlayerCustomPatternColorValue) Name Stripe3ColorName;
    var(PlayerCustomPatternColorValue) stringref ColorName;
    
    structdefaultproperties
    {
        Stripe1ColorName = 'Stripe_Color_01'
        Stripe2ColorName = 'Stripe_Color_02'
        Stripe3ColorName = 'Stripe_Color_03'
    }
};
struct native PlayerCustomPatternValue 
{
    var(PlayerCustomPatternValue) LinearColor Stripe1ParameterValue;
    var(PlayerCustomPatternValue) LinearColor Stripe2ParameterValue;
    var(PlayerCustomPatternValue) LinearColor Stripe3ParameterValue;
    var(PlayerCustomPatternValue) Name Stripe1ParameterName;
    var(PlayerCustomPatternValue) Name Stripe2ParameterName;
    var(PlayerCustomPatternValue) Name Stripe3ParameterName;
    var(PlayerCustomPatternValue) stringref PatternName;
    
    structdefaultproperties
    {
        Stripe1ParameterName = 'Stripe_Parameter_01'
        Stripe2ParameterName = 'Stripe_Parameter_02'
        Stripe3ParameterName = 'Stripe_Parameter_03'
    }
};
enum ECustomizableElementType
{
    CustomizableType_None,
    CustomizableType_Torso,
    CustomizableType_Shoulders,
    CustomizableType_Arms,
    CustomizableType_Legs,
    CustomizableType_Helmet,
    CustomizableType_Spec,
    CustomizableType_Tint,
    CustomizableType_Pattern,
    CustomizableType_PatternColor,
    CustomizableType_Emissive,
};
enum EAttachSlot
{
    EASlot_Holster,
    EASlot_LowerBack,
    EASlot_LeftShoulder,
    EASlot_RightShoulder,
    EASlot_CenterBack,
};
enum EInventoryResourceTypes
{
    INV_RESOURCE_CREDITS,
    INV_RESOURCE_MEDIGEL,
    INV_RESOURCE_SALVAGE,
    INV_RESOURCE_GRENADES,
    INV_RESOURCE_RARE1_EEZO,
    INV_RESOURCE_RARE2_IRIDIUM,
    INV_RESOURCE_RARE3_PALLADIUM,
    INV_RESOURCE_RARE4_PLATINUM,
    INV_RESOURCE_PROBES,
    INV_RESOURCE_FUEL,
};
enum EActionComplete_Combat
{
    ACC_Cancelled,
    ACC_Success,
    ACC_Failed,
    ACC_Dead,
    ACC_TargetKilled,
    ACC_TimeOut,
    ACC_LowTargeting,
    ACC_LostSight,
    ACC_Disabled,
    ACC_PowerCooldown,
    ACC_WeaponOverheat,
    ACC_WeaponCoolDown,
};
enum EBioRadarType
{
    BRT_None,
    BRT_Pawn_Friendly,
    BRT_Pawn_Neutral,
    BRT_Pawn_Hostile,
    BRT_Vehicle,
    BRT_Store,
    BRT_Destination,
    BRT_Plot,
    BRT_Mineral,
    BRT_Anomaly,
    BRT_Point_Of_Interest,
    BRT_Debris,
    BRT_Surveyed,
    BRT_Henchmen,
    BRT_Transition,
    BRT_TextNote,
};
enum EBioSkillGameDifficulty
{
    SKILL_GAME_DIFFICULTY_EASY,
    SKILL_GAME_DIFFICULTY_MEDIUM,
    SKILL_GAME_DIFFICULTY_HARD,
};
enum EBioSkillGame
{
    SKILL_GAME_DECRYPTION,
    SKILL_GAME_ELECTRONICS,
    SKILL_GAME_CUSTOM,
};

public static final native function stringref GetStringRef(ETargetTipText TipText);

public static final function string PrettyFloat(float F, optional int decimals = 1)
{
    local string S;
    
    S = string(F);
    decimals = decimals == 0 ? -1 : decimals;
    return Left(S, Len(S) - 4 + decimals);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}