Class BioUIWorld
    native
    config(UI);

const UIWORLD_FLAG_UseSourceAsTemplate = 32;
const UIWORLD_FLAG_DynamicLightEnv = 16;
const UIWORLD_FLAG_SpawnHidden = 8;
const UIWORLD_FLAG_DisableCollision = 4;
const UIWORLD_FLAG_HideScar = 2;
const UIWORLD_FLAG_HideHeadGear = 1;

var PostProcessSettings m_CurrentPostProcessSettings;
var const transient native array<Pointer> m_aCommandQueue;
var const transient native array<Actor> m_aoInitialActors;
var(BioUIWorld) config string m_sMapFile;
var array<BioPawn> m_SpawnedPawnOriginalReferences;
var delegate<UIWorld_DeferredOperator> __UIWorld_DeferredOperator__Delegate;
var transient native Pointer m_pWorld;
var const transient native Pointer m_pCriticalSection;
var const transient native Object m_mSpawnedActorMap;
var(BioUIWorld) config BioConvLightingData m_CustomLightingData;
var(BioUIWorld) config Name m_fnCameraActorName;
var transient native CameraActor m_pCameraActor;
var transient RvrClientEffectInterface m_CE_FullBiotic;
var transient RvrClientEffectInterface m_CE_HalfBiotic;
var transient RvrClientEffectInterface m_CE_OmniTool;
var BioSFHandler_NewCharacter m_oNCHandler;
var PostProcessChain m_PostProcessChain;
var(BioUIWorld) config bool m_bEnabled;
var transient bool m_bLoaded;

public native function AddDeferredOperation(delegate<UIWorld_DeferredOperator> InDelegate, optional Object InData);

public native function AttachBioticsAndTech(BioPawn a_pSourcePawn, Name a_fnClassName);

public native function AttachOmnitool(BioPawn a_pSourcePawn, bool a_fnClassName);

public event function ClearScarFromPawn(BioPawn PawnToClear)
{
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(PawnToClear);
    if (PlayerPawn != None)
    {
        PlayerPawn.bOverrideHideScars = TRUE;
        PlayerPawn.UpdateParameters();
    }
    else if (PawnToClear.HeadMesh != None)
    {
        Class'SFXPlayerCustomization'.static.ApplyScarParameters(Class'SFXPlayerCustomization'.default.Scars[Class'SFXPlayerCustomization'.default.Scars.Length - 1], PawnToClear.bIsFemale, PawnToClear.HeadMesh);
    }
}
public native function DestroyPawn(BioPawn a_pOriginalPawn);

private final native function ExUpdateHeadGearVisibility(BioPawn pOriginalPawn, bool bVisible);

private final event function FireDeferredOperation(delegate<UIWorld_DeferredOperator> InDelegate, Object InData)
{
    InDelegate(InData);
}
public native function FlushPendingCommands();

public native function Actor GetSpawnedActor(BioPawn a_pOriginalPawn);

public native function HidePawn(BioPawn a_pOriginalPawn, optional bool bHidden = TRUE);

public native function bool LoadWorld();

public native function MovePawn(BioPawn a_pOriginalPawn, Name a_fnNewLocation);

public native function PrimeTextures(BioPawn a_pSourcePawn);

public native function ResetActors();

public native function RotatePawn(BioPawn a_pOriginalPawn, Rotator a_newRot);

public native function SetAnimSet(BioPawn SourcePawn, AnimSet AnimSet);

public native function SetBoolVariable(Name a_fnVariableName, bool a_bValue);

public native function SetNameVariable(Name a_fnVariableName, Name a_nmValue);

public native function SetObjectVariable(Name a_fnVariableName, Object a_pValue);

private final native function SpawnActor(BioPawn InSourcePawn, Actor InActorArchetype, Name InSpawnLocation, Name InSpawnVariable, AnimSet InAnimSet, Name InRemoteEvent, int InSpawnFlags);

public event function SpawnPawn(BioPawn InOriginalPawn, Name InSpawnLocation, Name InSpawnVariable, optional AnimSet InAnimSet, optional Name InRemoteEvent, optional int InSpawnFlags)
{
    if (m_SpawnedPawnOriginalReferences.Find(InOriginalPawn) == -1)
    {
        SpawnPawnImpl(InOriginalPawn, InSpawnLocation, InSpawnVariable, InAnimSet, InRemoteEvent, InSpawnFlags);
    }
    else
    {
        HidePawn(InOriginalPawn, FALSE);
    }
    m_SpawnedPawnOriginalReferences.AddItem(InOriginalPawn);
}
public native function SwapPawn(BioPawn a_pSourcePawn, Name a_fnSourceVarName, BioPawn a_pOtherPawn, Name a_fnOtherVarName);

public native function TriggerEvent(Name a_fnEventName, Actor a_pCaller);

public delegate function UIWorld_DeferredOperator(Object InData);

public native function bool UnloadWorld();

public native function UpdateAppearance(BioPawn a_pOriginalPawn, optional AnimSet a_AnimSet, optional int a_Flags);

private final event function UpdateSpawnedHeadGear(Actor InActor, bool bVisible)
{
    local SFXPawn_PlayerParty PlayerParty;
    local SFXStuntActor StuntActor;
    
    PlayerParty = SFXPawn_PlayerParty(InActor);
    StuntActor = SFXStuntActor(InActor);
    if (PlayerParty != None)
    {
        PlayerParty.SetHeadGearVisibility(bVisible);
    }
    else if (StuntActor != None)
    {
        StuntActor.SetHeadGearVisibility(bVisible);
    }
}
public final function CleanupPawn(BioPawn InOriginalPawn)
{
    local int FoundIdx;
    
    FoundIdx = m_SpawnedPawnOriginalReferences.Find(InOriginalPawn);
    if (FoundIdx != -1)
    {
        m_SpawnedPawnOriginalReferences.Remove(FoundIdx, 1);
        if (m_SpawnedPawnOriginalReferences.Find(InOriginalPawn) == -1)
        {
            DestroyPawn(InOriginalPawn);
            if (m_SpawnedPawnOriginalReferences.Length == 0)
            {
                CleanupUIWorld();
            }
        }
    }
}
public final function CleanupUIWorld()
{
    ResetActors();
    TriggerEvent('LightsOff', Class'Engine'.static.GetCurrentWorldInfo());
    FlushPendingCommands();
}
public final function SpawnPawnImpl(BioPawn InOriginalPawn, Name InSpawnLocation, Name InSpawnVariable, optional AnimSet InAnimSet, optional Name InRemoteEvent, optional int InSpawnFlags)
{
    local SFXPawn_PlayerParty PartyPawn;
    local Actor SourceArchetype;
    
    PartyPawn = SFXPawn_PlayerParty(InOriginalPawn);
    if (PartyPawn != None)
    {
        SourceArchetype = PartyPawn.UIWorldArchetype;
    }
    if (SourceArchetype == None || (InSpawnFlags & 32) != 0)
    {
        SourceArchetype = Actor(InOriginalPawn.ObjectArchetype);
    }
    SpawnActor(InOriginalPawn, SourceArchetype, InSpawnLocation, InSpawnVariable, InAnimSet, InRemoteEvent, InSpawnFlags);
    if (PartyPawn != None && (InSpawnFlags & 1) == 0)
    {
        UpdateHeadGearVisibility(PartyPawn);
    }
}
public final function UpdateHeadGearVisibility(SFXPawn_PlayerParty inPawn)
{
    local bool bVisible;
    
    if (inPawn != None)
    {
        bVisible = inPawn.ShouldShowHelmet();
        ExUpdateHeadGearVisibility(inPawn, bVisible);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_CurrentPostProcessSettings = {
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
                                    DOF_BlurKernelSize = 16.0, 
                                    DOF_BlurBloomKernelSize = 16.0, 
                                    DOF_MaxNearBlurAmount = 1.0, 
                                    DOF_MaxFarBlurAmount = 1.0, 
                                    DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                                    DOF_FocusInnerRadius = 2000.0, 
                                    DOF_FocusDistance = 0.0, 
                                    DOF_InterpolationDuration = 1.0, 
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
                                    bEnableDOF = FALSE, 
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
    m_sMapFile = "BIOG_UIWorld"
    m_CustomLightingData = {
                            TargetBoneName = 'Chest2', 
                            KeyLight_Scale_Red = 1.0, 
                            KeyLight_Scale_Green = 1.0, 
                            KeyLight_Scale_Blue = 1.0, 
                            FillLight_Scale_Red = 1.0, 
                            FillLight_Scale_Green = 1.0, 
                            FillLight_Scale_Blue = 1.0, 
                            RimLightColor = {B = 255, G = 112, R = 112, A = 0}, 
                            RimLightScale = 2.75, 
                            RimLightYaw = -20.0, 
                            RimLightPitch = 0.0, 
                            BouncedLightingIntensity = 0.0, 
                            LightRig = None, 
                            LightRigOrientation = 0.0, 
                            bLockEnvironment = FALSE, 
                            bTriggerFullUpdate = FALSE, 
                            bUseForNextCamera = FALSE, 
                            bCastShadows = TRUE, 
                            RimLightControl = ERimLightControlType.RLCT_Camera, 
                            LightingType = EConvLightingType.ConvLighting_Cinematic
                           }
    m_fnCameraActorName = 'CameraActor_3'
    m_PostProcessChain = PostProcessChain'BioVFX_FB_RenderSyle.Final_RenderStyle.UIWorld_PostProcess'
    m_bEnabled = TRUE
}