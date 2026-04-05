Class BioGlobalVariableTable
    native
    transient
    config(Game);

struct native CopyPlot 
{
    var int nSId;
    var int nTId;
    var SFXPlotType nType;
};
struct native NewGameCanonPlot 
{
    var PlotIdenfitier Id;
    var int nValue;
    var int nConditional;
    var int nConditionalParameter;
};
struct native PlotIdenfitier 
{
    var int nIndex;
    var SFXPlotType nType;
};
enum SFXRomanced
{
    SFXRomanced_NO_ONE,
    SFXRomanced_Ashley,
    SFXRomanced_Kaidan,
    SFXRomanced_Liara,
    SFXRomanced_Miranda,
    SFXRomanced_Garrus,
    SFXRomanced_Jacob,
    SFXRomanced_Thane,
    SFXRomanced_Jack,
    SFXRomanced_Tali,
};
enum SFXME2Plot_CollectorBaseState
{
    CollectorBase_Irradiate,
    CollectorBase_Destroyed,
};
enum SFXME2Plot_HereticsState
{
    Heretics_Rewrite,
    Heretics_Destroyed,
    Heretics_NotComplete,
};
enum SFXME1Plot_WrexState
{
    WREX_ALIVE,
    WREX_DEAD,
    WREX_IGNORED,
};
enum SFXPlotType
{
    SFXPlotType_Float,
    SFXPlotType_Integer,
    SFXPlotType_Boolean,
};
struct native TimedPlotUnlock_t 
{
    var int PlotBool;
    var int UnlockDay;
};

var native Map_Mirror IntVariables;
var native Map_Mirror FloatVariables;
var array<int> BoolVariables;
var config array<NewGameCanonPlot> ME1CanonPlotVariables;
var config array<NewGameCanonPlot> ME2CanonPlotVariables;
var config array<CopyPlot> ME1ToME3PlotCopy;
var config array<CopyPlot> ME2ToME3PlotCopy;
var config array<PlotIdenfitier> NewGamePlusPlotsToPersist;
var config array<TimedPlotUnlock_t> TimedPlotUnlocks;
var config int ME1PlotTable_IndexOffset;
var config int ME1PlotTable_Bool_CutoffIndex;
var config int ME1PlotTable_Int_CutoffIndex;
var config int ME1PlotTable_Float_CutoffIndex;
var config int ME3_Plots_Utility_Player_Info_Paragon;
var config int ME3_Plots_Utility_Player_Info_Renegade;
var config int ME3_Plots_Utility_Player_Info_ReputationPoints;
var config int ME3_Plots_Utility_Player_Info_ME2Paragon;
var config int ME3_Plots_Utility_Player_Info_ME2Renegade;
var config int ME3_Plots_Utility_Player_Info_Childhood;
var config int ME3_Plots_Utility_Player_Info_Reputation;
var config int ME3_Plots_Utility_Player_Info_PersuadeMultiplier;
var config int ME3_Plots_Utility_Player_Info_Character_Class;
var config int ME3_Plots_Utility_Player_Info_Female_Player;
var config int ME3_Plots_Bool_Is_ME2_Import;
var config int ME3_Plots_Bool_Is_ME1_Import;
var config int ME3_Plots_Int_ME3_NewGamePlus_Count;
var config int PS3DarkHorseME1PlayedPlotCheck_Bool;
var config int ME2__ME1_Plots_for_ME2__Background_and_Relationships__Kaidan_romance_True;
var config int ME2__ME1_Plots_for_ME2__Background_and_Relationships__Ashley_romance_True;
var config int ME2__ME1_Plots_for_ME2__Background_and_Relationships__Liara_romance_True;
var config int ME2__ME1_Plots_for_ME2__Background_and_Relationships__NoRomance_True;
var config int ME2__ME1_Plots_for_ME2__CH2_Virmire__Ash_died;
var config int ME2__ME1_Plots_for_ME2__CH2_Virmire__Kaidan_died;
var config int ME2__ME1_Plots_for_ME2__CH2_Noveria__Rachni_Alive;
var config int ME2__ME1_Plots_for_ME2__CH2_Virmire_Wrex_Died;
var config int ME2__ME1_Plots_for_ME2__CH2_Virmire_Ash_Killed_Wrex;
var config int ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Council_Dead;
var config int ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Council_Alive;
var config int ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Udina_Chosen;
var config int ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Anderson_chosen;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_Buddy_dialog_count;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_active;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__Romance_Buddy_dialog_count;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__romance_active;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_Buddy_dialog_count;
var config int ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_active;
var config int ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Kaidan;
var config int ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Ash;
var config int ME3__ME1_Plots_for_ME3__CH2_Noveria__Rachni_Queen__Queen_Dealt_With__Queen_Released;
var config int ME3__ME1_Plots_for_ME3__CH2_Noveria__Rachni_Queen__Queen_Dealt_With__Queen_eliminated;
var config int ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Player;
var config int ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__Krogan;
var config int ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanMale;
var config int ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanFemale;
var config int ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Choice_Is_Made__Save_the_Council;
var config int ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Choice_Is_Made__Destroy_the_Council;
var config int ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Chose_ambassador;
var config int ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Chose_Anderson;
var config int ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Ashley;
var config int ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_AshKilledWithoutPermission;
var config int ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Saved_Data;
var config int ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Destroyed_Data;
var config int ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Blow_Them_Up;
var config int ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Rewrite_Them;
var config int ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Work_with_Cerberus;
var config int ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Destroy_Base;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Vixen;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Leading;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Grunt;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Assassin;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Veteran;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Thief;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Mystic;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Professor;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Geth;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Tali;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Convict;
var config int ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Garrus;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Vixen__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Garrus__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Leading__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Assassin__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Convict__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Henchmen__Tali__Relationship;
var config int ME3__ME2_Plots_for_ME3__Global__Achievements__ChangedDifficulty;
var Bio2DA oNameLookupTable;
var Bio2DA AchievementTable;

public final native function ApplyCanonPlots(array<NewGameCanonPlot> aCanonPlotVariables);

public native function ClearAllVariables(optional bool bPersistME1ME2plots = FALSE);

public final native function CopyME2PlotData(SFXSaveGame LegacyImportSaveGame);

public final native function CopyPlots(array<CopyPlot> toCopy);

public final native function DoDarkHorseME1PlotCopyAndPlotLogicFix();

public final native function DoME2PlotImport(SFXSaveGame LegacyImportSaveGame);

public final native function DoME3NewGamePlusImport(SFXSaveGame NewGamePlusSave);

public final event function EnumeratePersonalizationVars(out array<int> Vars)
{
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.CasualAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.FullBodyAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.TorsoAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.ShoulderAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.ArmAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.LegAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.HelmetAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.SpecAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.Tint1Appearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.Tint2Appearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.PatternAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.PatternColorAppearances, Vars);
    AddCustomElementListPlotVars(Class'SFXPlayerCustomization'.default.EmissiveAppearances, Vars);
}
public final native function FixME1PlotsDuringME2PlotImport();

public native function bool GetBool(int nIndex);

public native function bool GetBoolByName(Name nmLabel);

public native function float GetFloat(int nIndex);

public native function float GetFloatByName(Name nmLabel);

public native function int GetInt(int nIndex);

public native function int GetIntByName(Name nmLabel);

public final native function GetPlayerPlotData(out PlayerInfoEx PlayerData);

public final native function MergeME1PlotRecord(const out ME1PlotTableRecord me1Plots);

public native function OnSendMessageComplete(int messageId, array<int> messageIds, int errorCode);

public native function SetBool(int nIndex, bool bValue, optional bool bEvaluateAchievement = TRUE, optional bool bSkipAllAdditionalProcessing = FALSE);

public native function SetBoolByName(Name nmLabel, bool bValue);

public native function SetFloat(int nIndex, float fValue, optional bool bSkipAllAdditionalProcessing = FALSE);

public native function SetFloatByName(Name nmLabel, float fValue);

public native function SetInt(int nIndex, int nValue, optional bool bSkipAllAdditionalProcessing = FALSE);

public native function SetIntByName(Name nmLabel, int nValue);

public final native function SetNewGamePlotStates(SFXSaveGame LegacyImportSaveGame, SFXSaveGame PlusImportSaveGame, const out PlayerInfoEx PlayerData, optional bool bIncludePlayerVariables = TRUE);

public final native function SetPlayerPlotData(const out PlayerInfoEx PlayerData);

public final function AddCustomElementListPlotVars(out array<CustomizableElement> Elements, out array<int> Vars)
{
    local int idx;
    
    for (idx = 0; idx < Elements.Length; idx++)
    {
        if (Elements[idx].PlotFlag != -1 && Elements[idx].PlotFlag != 0)
        {
            Vars.AddItem(Elements[idx].PlotFlag);
        }
    }
}
public function stringref GetStrRefByName(Name nmLabel)
{
    local int nIndex;
    
    if (oNameLookupTable.GetIntEntryNN(nmLabel, 'Index', nIndex) == TRUE)
    {
        return stringref(nIndex);
    }
    return $-1;
}
public final function bool MajorPlot_ME1_RachniiQueenSaved()
{
    return GetBool(ME3__ME1_Plots_for_ME3__CH2_Noveria__Rachni_Queen__Queen_Dealt_With__Queen_Released);
}
public final function bool MajorPlot_ME1_SavedTheCouncil()
{
    return GetBool(ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Choice_Is_Made__Save_the_Council);
}
public final function bool MajorPlot_ME1_VirmireSurvivor_IsAsh()
{
    return GetBool(ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Ash);
}
public final function SFXME1Plot_WrexState MajorPlot_ME1_WrexStatus()
{
    local bool bWrexInParty;
    local bool bWrexDead;
    local SFXME1Plot_WrexState eResult;
    
    eResult = SFXME1Plot_WrexState.WREX_IGNORED;
    bWrexInParty = GetBool(ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__Krogan);
    bWrexDead = GetBool(ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Ashley) || GetBool(ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Player) || GetBool(ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_AshKilledWithoutPermission);
    if (bWrexInParty)
    {
        eResult = SFXME1Plot_WrexState.WREX_ALIVE;
    }
    else if (bWrexDead)
    {
        eResult = SFXME1Plot_WrexState.WREX_DEAD;
    }
    return eResult;
}
public final function SFXME2Plot_CollectorBaseState MajorPlot_ME2_CollectorBaseStatus()
{
    local SFXME2Plot_CollectorBaseState eResult;
    local bool bIrradiate;
    local bool bDestroyed;
    
    eResult = SFXME2Plot_CollectorBaseState.CollectorBase_Irradiate;
    bIrradiate = GetBool(ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Work_with_Cerberus);
    bDestroyed = GetBool(ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Destroy_Base);
    if (bIrradiate)
    {
        eResult = SFXME2Plot_CollectorBaseState.CollectorBase_Irradiate;
    }
    else if (bDestroyed)
    {
        eResult = SFXME2Plot_CollectorBaseState.CollectorBase_Destroyed;
    }
    return eResult;
}
public final function bool MajorPlot_ME2_DestroyedMaelonsData()
{
    return GetBool(ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Destroyed_Data);
}
public final function SFXME2Plot_HereticsState MajorPlot_ME2_HerteticsStatus()
{
    local SFXME2Plot_HereticsState eResult;
    local bool bRewrite;
    local bool bDestroyed;
    
    eResult = SFXME2Plot_HereticsState.Heretics_NotComplete;
    bDestroyed = GetBool(ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Blow_Them_Up);
    bRewrite = GetBool(ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Rewrite_Them);
    if (bRewrite)
    {
        eResult = SFXME2Plot_HereticsState.Heretics_Rewrite;
    }
    else if (bDestroyed)
    {
        eResult = SFXME2Plot_HereticsState.Heretics_Destroyed;
    }
    return eResult;
}
public final function int MajorPlot_ME2_NumberOfSuicideMissionSurvivors()
{
    local int nCount;
    
    nCount = 0;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Vixen) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Leading) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Grunt) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Assassin) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Veteran) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Thief) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Tali) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Convict) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Garrus) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Mystic) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Professor) ? nCount + 1 : nCount;
    nCount = GetBool(ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Geth) ? nCount + 1 : nCount;
    return nCount;
}
public final function SFXRomanced MajorPlot_ME2_Romance()
{
    local SFXRomanced anNPC;
    
    anNPC = SFXRomanced.SFXRomanced_NO_ONE;
    if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Vixen__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Miranda;
    }
    else if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Garrus__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Garrus;
    }
    else if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Leading__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Jacob;
    }
    else if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Assassin__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Thane;
    }
    else if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Convict__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Jack;
    }
    else if (GetInt(ME3__ME2_Plots_for_ME3__Global__Henchmen__Tali__Relationship) == 5)
    {
        anNPC = SFXRomanced.SFXRomanced_Tali;
    }
    return anNPC;
}
public final function bool MajorPlot_ME2_SavedMaelonsData()
{
    return GetBool(ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Saved_Data);
}
public final function SFXRomanced MajorPolt_ME1_Romance()
{
    local SFXRomanced anNPC;
    
    anNPC = SFXRomanced.SFXRomanced_NO_ONE;
    if (GetBool(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__romance_active) && GetInt(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__Romance_Buddy_dialog_count) >= 4)
    {
        anNPC = SFXRomanced.SFXRomanced_Ashley;
    }
    else if (GetBool(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_active) && GetInt(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_Buddy_dialog_count) >= 4)
    {
        anNPC = SFXRomanced.SFXRomanced_Kaidan;
    }
    else if (GetBool(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_active) && GetInt(ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_Buddy_dialog_count) >= 4)
    {
        anNPC = SFXRomanced.SFXRomanced_Liara;
    }
    return anNPC;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ME1CanonPlotVariables = ({
                              Id = {nIndex = 13941, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 16380, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 13798, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 12588, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 16058, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 13029, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 13827, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 11, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 13828, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 12, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 13002, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 15434, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }
                            )
    ME2CanonPlotVariables = ({
                              Id = {nIndex = 3329, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3328, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3326, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3330, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 41, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 38, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 197, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 40, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 201, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 33, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 34, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 1831, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3629, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3631, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3632, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 3515, nType = SFXPlotType.SFXPlotType_Boolean}, 
                              nValue = 1, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }, 
                             {
                              Id = {nIndex = 166, nType = SFXPlotType.SFXPlotType_Integer}, 
                              nValue = 4, 
                              nConditional = 0, 
                              nConditionalParameter = 0
                             }
                            )
    ME1ToME3PlotCopy = ({nSId = 10001, nTId = 10296, nType = SFXPlotType.SFXPlotType_Integer}, 
                        {nSId = 10002, nTId = 10297, nType = SFXPlotType.SFXPlotType_Integer}, 
                        {nSId = 14639, nTId = 17662, nType = SFXPlotType.SFXPlotType_Boolean}
                       )
    ME2ToME3PlotCopy = ({nSId = 66, nTId = 17662, nType = SFXPlotType.SFXPlotType_Boolean}, 
                        {nSId = 7, nTId = 10296, nType = SFXPlotType.SFXPlotType_Integer}, 
                        {nSId = 8, nTId = 10297, nType = SFXPlotType.SFXPlotType_Integer}, 
                        {nSId = 230, nTId = 10151, nType = SFXPlotType.SFXPlotType_Integer}
                       )
    NewGamePlusPlotsToPersist = ({nIndex = 19455, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19456, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19457, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19458, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19459, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19460, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19461, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19462, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19467, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19468, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19469, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19470, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21399, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21400, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21401, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21402, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20914, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20915, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20916, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20917, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20918, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20919, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20920, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20921, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 18988, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 18995, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 18999, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19000, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19005, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19006, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19007, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 19008, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 22339, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 22340, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 22341, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20984, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20985, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20986, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20987, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20988, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 20989, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21417, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21224, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21225, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21226, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21227, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21228, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21229, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21231, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21568, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21613, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21560, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21561, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21562, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21563, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21564, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21565, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21566, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21567, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21246, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21235, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21236, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21232, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21234, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21233, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21237, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21572, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21573, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21574, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21575, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21576, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21577, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21238, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21239, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21240, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21241, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21242, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21243, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21244, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21245, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21578, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21579, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21580, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21581, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21582, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21583, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21584, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21247, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21248, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21249, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21250, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21251, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21569, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21570, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21585, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21586, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21587, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21588, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21589, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21590, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21252, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21254, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21255, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21256, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21591, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21592, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21593, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21594, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21259, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21260, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21261, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21262, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21263, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21264, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21265, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21266, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21267, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21268, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21269, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21270, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21271, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21272, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21273, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21274, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21275, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21276, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21277, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21278, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21279, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21280, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21281, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21282, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21283, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21284, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21285, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21287, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21286, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21288, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21290, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21291, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21292, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21293, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21294, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21295, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21296, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21297, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21298, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21299, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21300, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21301, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21302, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21303, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21304, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21305, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21306, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21307, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21308, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21309, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21555, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21556, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21557, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21558, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21559, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 10300, nType = SFXPlotType.SFXPlotType_Integer}, 
                                 {nIndex = 21038, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21039, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21040, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21041, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21113, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21118, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21115, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21116, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 22153, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21042, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21044, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21045, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21046, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21047, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21048, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21050, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21053, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21054, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21110, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21106, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21107, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21108, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21109, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21111, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21112, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 22642, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 10159, nType = SFXPlotType.SFXPlotType_Integer}, 
                                 {nIndex = 10160, nType = SFXPlotType.SFXPlotType_Integer}, 
                                 {nIndex = 10380, nType = SFXPlotType.SFXPlotType_Integer}, 
                                 {nIndex = 22226, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 21554, nType = SFXPlotType.SFXPlotType_Boolean}, 
                                 {nIndex = 10475, nType = SFXPlotType.SFXPlotType_Integer}
                                )
    ME1PlotTable_IndexOffset = 10000
    ME1PlotTable_Bool_CutoffIndex = 17655
    ME1PlotTable_Int_CutoffIndex = 10148
    ME1PlotTable_Float_CutoffIndex = 10039
    ME3_Plots_Utility_Player_Info_Paragon = 10159
    ME3_Plots_Utility_Player_Info_Renegade = 10160
    ME3_Plots_Utility_Player_Info_ReputationPoints = 10380
    ME3_Plots_Utility_Player_Info_ME2Paragon = 2
    ME3_Plots_Utility_Player_Info_ME2Renegade = 3
    ME3_Plots_Utility_Player_Info_Childhood = 10296
    ME3_Plots_Utility_Player_Info_Reputation = 10297
    ME3_Plots_Utility_Player_Info_PersuadeMultiplier = 10065
    ME3_Plots_Utility_Player_Info_Character_Class = 10151
    ME3_Plots_Utility_Player_Info_Female_Player = 17662
    ME3_Plots_Bool_Is_ME2_Import = 21554
    ME3_Plots_Bool_Is_ME1_Import = 22226
    ME3_Plots_Int_ME3_NewGamePlus_Count = 10475
    PS3DarkHorseME1PlayedPlotCheck_Bool = 7447
    ME2__ME1_Plots_for_ME2__Background_and_Relationships__Kaidan_romance_True = 1529
    ME2__ME1_Plots_for_ME2__Background_and_Relationships__Ashley_romance_True = 1528
    ME2__ME1_Plots_for_ME2__Background_and_Relationships__Liara_romance_True = 1530
    ME2__ME1_Plots_for_ME2__Background_and_Relationships__NoRomance_True = 1926
    ME2__ME1_Plots_for_ME2__CH2_Virmire__Ash_died = 1540
    ME2__ME1_Plots_for_ME2__CH2_Virmire__Kaidan_died = 1541
    ME2__ME1_Plots_for_ME2__CH2_Noveria__Rachni_Alive = 3151
    ME2__ME1_Plots_for_ME2__CH2_Virmire_Wrex_Died = 3752
    ME2__ME1_Plots_for_ME2__CH2_Virmire_Ash_Killed_Wrex = 1862
    ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Council_Dead = 1553
    ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Council_Alive = 1554
    ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Udina_Chosen = 1555
    ME2__ME1_Plots_for_ME2__CH4_Star_Citadel__Anderson_chosen = 1556
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_Buddy_dialog_count = 10015
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Kaidan__Romance_active = 13960
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__Romance_Buddy_dialog_count = 10017
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Ash__romance_active = 14281
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_Buddy_dialog_count = 10016
    ME3__ME1_Plots_for_ME3__Global_Plots__Henchman_Liara__Romance_active = 14169
    ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Kaidan = 13828
    ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Ash = 13827
    ME3__ME1_Plots_for_ME3__CH2_Noveria__Rachni_Queen__Queen_Dealt_With__Queen_Released = 12587
    ME3__ME1_Plots_for_ME3__CH2_Noveria__Rachni_Queen__Queen_Dealt_With__Queen_eliminated = 12588
    ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Player = 13029
    ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__Krogan = 13942
    ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanMale = 13939
    ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanFemale = 13940
    ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Choice_Is_Made__Save_the_Council = 13001
    ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Choice_Is_Made__Destroy_the_Council = 13002
    ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Chose_ambassador = 15434
    ME3__ME1_Plots_for_ME3__CH4_Star_Citadel__Final_Choice__Chose_Anderson = 15435
    ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_KilledBy_Ashley = 13028
    ME3__ME1_Plots_for_ME3__CH2_Virmire__Krogan_conundrum__Failure__Failure_AshKilledWithoutPermission = 15543
    ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Saved_Data = 2676
    ME3__ME2_Plots_for_ME3__Loyalty_Missions__Professor_Loyalty__Mission_Complete__Destroyed_Data = 2677
    ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Blow_Them_Up = 757
    ME3__ME2_Plots_for_ME3__Loyalty_Missions__Geth_Loyalty__Heretic_Resolution__Rewrite_Them = 759
    ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Work_with_Cerberus = 1832
    ME3__ME2_Plots_for_ME3__Act_3__Final_Decision__Destroy_Base = 1831
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Vixen = 33
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Leading = 34
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Grunt = 42
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Assassin = 39
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Veteran = 44
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Thief = 37
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Mystic = 43
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Professor = 41
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Geth = 36
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Tali = 40
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Convict = 35
    ME3__ME2_Plots_for_ME3__Utility__Henchmen__In_Party__Garrus = 38
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Vixen__Relationship = 266
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Garrus__Relationship = 270
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Leading__Relationship = 267
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Assassin__Relationship = 271
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Convict__Relationship = 213
    ME3__ME2_Plots_for_ME3__Global__Henchmen__Tali__Relationship = 272
    ME3__ME2_Plots_for_ME3__Global__Achievements__ChangedDifficulty = 5616
    oNameLookupTable = Bio2DA'BIOG_2DA_PlotManager_X.PlotManagerGameData'
    AchievementTable = Bio2DANumberedRows'BIOG_2DA_GamerProfile_X.Achievements'
}