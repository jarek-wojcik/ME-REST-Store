Class SFXSaveManagerMP
    native
    config(Game);

struct native ActiveMatchConsumable 
{
    var int ClassNameID;
    var float Value;
};
struct native PendingLoadOperation 
{
    var delegate<OnRefreshMPDataDelegate> LoadDelegate;
};
struct native PendingSaveOperation 
{
    var delegate<OnSaveRecordsDelegate> SaveDelegate;
    var bool ForceSaveBase;
};
struct native NewReinforcementData 
{
    var string VariableName;
    var EReinforcementGUICategory Category;
};
enum EReinforcementGUICategory
{
    EReinforcementGUICategory_None,
    EReinforcementGUICategory_AssaultRifle,
    EReinforcementGUICategory_SMG,
    EReinforcementGUICategory_SniperRifle,
    EReinforcementGUICategory_Pistol,
    EReinforcementGUICategory_Shotgun,
    EReinforcementGUICategory_Mod,
    EReinforcementGUICategory_Kit,
    EReinforcementGUICategory_MatchConsumableAmmo,
    EReinforcementGUICategory_MatchConsumableWeapon,
    EReinforcementGUICategory_MatchConsumableArmor,
    EReinforcementGUICategory_MatchConsumableGear,
    EReinforcementGUICategory_NewlyAffordableStoreItems,
    EReinforcementGUICategory_KitAppearance,
};
struct native StartingMPPlayerVariable 
{
    var string PlayerVariable;
    var int Value;
};
enum ECharacterNameResult
{
    ECharacterNameResult_AllGood,
    ECharacterNameResult_NotUnique,
    ECharacterNameResult_NameTooLong,
    ECharacterNameResult_Empty,
};
struct native MPFaceCodeData 
{
    var string firstName;
    var string faceCode;
    var int Id;
};
struct native MPKitData 
{
    var string KitTextureRef;
    var string LockedKitTextureRef;
    var string SmallKitTextureRef;
    var string ArchetypeRef;
    var string PowerIconResource;
    var config array<int> RequiredDLCModuleIDs;
    var Name KitName;
    var Name BaseMPClassName;
    var stringref srDisplayName;
    var stringref srDefaultName;
    var int PowerIconIndex1;
    var int PowerIconIndex2;
    var int PowerIconIndex3;
    var stringref srPowerName1;
    var stringref srPowerName2;
    var stringref srPowerName3;
    var int MaxNewUnlockLevel;
    var bool bLockedByDefault;
    var bool bPermanentlyLocked;
    var bool bUsePrimaryColor;
    var bool bUseSecondaryColor;
    var bool bUsePattern;
    var bool bUsePatternColor;
    var bool bUsePhong;
    var bool bUseEmissive;
    var bool bUseSkinTone;
    var bool bHideIfLocked;
    
    structdefaultproperties
    {
        bUsePrimaryColor = TRUE
        bUseSecondaryColor = TRUE
        bUsePattern = TRUE
        bUsePatternColor = TRUE
        bUsePhong = TRUE
        bUseEmissive = TRUE
    }
};
struct native MPClassData 
{
    var Name className;
    var stringref srDisplayName;
    var stringref srDescription;
};
struct native MPTutorialPromoMessage 
{
    var string ImageURL;
    var int TrackingID;
    var int offerId;
    var stringref MessageTitle;
    var stringref MessageText;
};
const NumClassSlots = 8;
const NumCharacterSlots = 79;

var config MPTutorialPromoMessage DefaultTutorialMessage;
var config array<MPClassData> MPClasses;
var config array<MPKitData> MPKits;
var array<SFXMPClassRecord> Classes;
var array<SFXMPCharacterRecord> Characters;
var array<MPFaceCodeData> FaceCodes;
var config array<StartingMPPlayerVariable> DefaultMPPlayerVariables;
var array<NewReinforcementData> NewReinforcements;
var config array<EReinforcementGUICategory> ValidNewReinforcementCategories;
var array<PendingSaveOperation> PendingSaveOperations;
var array<PendingLoadOperation> PendingLoadOperations;
var array<ActiveMatchConsumable> ActiveMatchConsumablesForOfflineTransfer;
var string NewlyAffordableStoreItemsPlayerVariableName;
var delegate<OnSaveRecordsDelegate> __OnSaveRecordsDelegate__Delegate;
var delegate<OnRefreshMPDataDelegate> __OnRefreshMPDataDelegate__Delegate;
var transient native Object PlayerVariables;
var config int MaxMPLevelBonus;
var int AvailableCredits;
var int NextPackToConsume;
var int NumCopiesToConsume;
var int TotalCreditsSpent;
var int TotalPlatformCurrencySpent;
var transient int SessionCreditsSpent;
var transient int SessionCreditsEarned;
var transient int SessionPlatformCurrencySpent;
var int TotalGamesPlayed;
var int TotalTimePlayed;
var int LastLevelUpTime;
var SFXOnlineSaveGameMP OnlineSave;
var config stringref srTooNewErrorMessage;
var config stringref srTooNewErrorMessageBoxOK;
var transient SFXMatchResultsData MPMatchResultsData;
var SFXMPCharacterRecord CurrentCharacter;
var SFXMPCharacterRecord CurrCharacterToModify;
var bool bInitialized;
var bool bDisableSaving;
var bool m_bDebugPlayerVariables;
var bool m_bSaveInProgress;
var bool m_bLoadInProgress;

public native function GetAllPlayerVariableIDsAndValues(out array<Name> VariableIDs, out array<int> VariableValues);

public final event function string GetCurrentCharacterClass()
{
    return string(CurrentCharacter.className);
}
public final event function int GetCurrentCharacterClassLevel()
{
    return GetClassRecord(CurrentCharacter.className).Level;
}
public final event function string GetCurrentCharacterKit()
{
    return string(CurrentCharacter.KitName);
}
public final event function string GetCurrentCharacterName()
{
    return CurrentCharacter.CharacterName;
}
public event function Name GetMPPlayerVariableID(Name VariableName)
{
    local int VariableID;
    
    VariableID = Class'SFXGameConfig'.static.GetPurchasableItemID(string(VariableName));
    if (VariableID != -1)
    {
        return Name(string(VariableID));
    }
    return 'None';
}
public event function Name GetMPPlayerVariableName(Name VariableID)
{
    return Name(Class'SFXGameConfig'.static.GetPurchasableItemClassName(int(string(VariableID))));
}
public event function int GetN7Rating()
{
    local SFXMPClassRecord MPClassRecord;
    local int n7Rating;
    local int MaxLevel;
    
    n7Rating = 0;
    MaxLevel = Class'BioLevelUpSystem'.static.GetMaxLevel();
    foreach Classes(MPClassRecord, )
    {
        n7Rating += (MaxLevel + MaxMPLevelBonus) * MPClassRecord.NumPromotions;
        if (MPClassRecord.HasAnyDeployedCharacters())
        {
            n7Rating += MPClassRecord.Level;
        }
    }
    return n7Rating;
}
public native function int GetPlayerVariable(Name VariableName);

public function Initialize()
{
    if (OnlineSave == None)
    {
        OnlineSave = new Class'SFXOnlineSaveGameMP';
    }
    OnlineSave.Initialize();
    if (MPMatchResultsData == None)
    {
        MPMatchResultsData = new Class'SFXMatchResultsData';
    }
}
public delegate function OnRefreshMPDataDelegate(int nResult);

public delegate function OnSaveRecordsDelegate(int nResult);

public native function QueryPlayerVariables(out array<Name> VariableNames, optional string SearchText);

public native function ResetMPPlayerVariables();

public native function SetPlayerVariable(Name VariableName, int nValue);

public native function SetPlayerVariableFromID(Name VariableID, int nValue);

public function SetupInitialMPCharacters()
{
    local int ClassIdx;
    local int KitIdx;
    local SFXMPClassRecord ClassRecord;
    local SFXMPCharacterRecord CharacterRecord;
    
    Classes.Length = 0;
    Characters.Length = 0;
    for (ClassIdx = 0; ClassIdx < MPClasses.Length; ++ClassIdx)
    {
        ClassRecord = new Class'SFXMPClassRecord';
        ClassRecord.className = MPClasses[ClassIdx].className;
        for (KitIdx = 0; KitIdx < MPKits.Length; ++KitIdx)
        {
            if (MPKits[KitIdx].BaseMPClassName == MPClasses[ClassIdx].className)
            {
                CharacterRecord = new Class'SFXMPCharacterRecord';
                CharacterRecord.className = MPClasses[ClassIdx].className;
                CharacterRecord.KitName = MPKits[KitIdx].KitName;
                CharacterRecord.Deployed = FALSE;
                CharacterRecord.CharacterName = GetUniqueCharacterName(CharacterRecord.KitName);
                ClassRecord.Characters.AddItem(CharacterRecord);
                Characters.AddItem(CharacterRecord);
            }
        }
        Classes.AddItem(ClassRecord);
    }
}
public event function SetupInitialMPPlayerVariables()
{
    local SFXEngine Engine;
    local int idx;
    
    if (DefaultMPPlayerVariables.Length <= 0)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    for (idx = 0; idx < DefaultMPPlayerVariables.Length; idx++)
    {
        SetPlayerVariable(Name(DefaultMPPlayerVariables[idx].PlayerVariable), DefaultMPPlayerVariables[idx].Value);
    }
}
public function BioPlayerController GetPC()
{
    local BioWorldInfo WorldInfo;
    
    WorldInfo = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WorldInfo != None)
    {
        return WorldInfo.GetLocalPlayerController();
    }
    return None;
}
public function AddCredits(int nCreditAmount, optional string Transaction)
{
    local SFXGAWReinforcementManagerBase GAWManager;
    
    GAWManager = SFXLocalPlayer(GetPC().Player).GAWReinforcementManager;
    if (GAWManager != None && GAWManager.CanAffordNewStoreItems(AvailableCredits, AvailableCredits + nCreditAmount))
    {
        AddNewReinforcement(12, NewlyAffordableStoreItemsPlayerVariableName);
    }
    AvailableCredits = Max(0, AvailableCredits + nCreditAmount);
    SessionCreditsEarned += nCreditAmount;
    Class'SFXTelemetryHooks'.static.SendMPCredits(nCreditAmount, AvailableCredits, SessionCreditsEarned, SessionCreditsSpent, Transaction);
}
public function AddNewFaceCode(string firstName, string faceCode)
{
    local MPFaceCodeData newFaceCodeData;
    local int i;
    local int newFaceCodeID;
    
    newFaceCodeID = 0;
    newFaceCodeData.Id = 0;
    newFaceCodeData.faceCode = faceCode;
    newFaceCodeData.firstName = firstName;
    for (i = 0; i < FaceCodes.Length; ++i)
    {
        if (FaceCodes[i].Id >= newFaceCodeID)
        {
            newFaceCodeID = FaceCodes[i].Id + 1;
        }
        if (FaceCodes[i].faceCode == faceCode && FaceCodes[i].firstName == firstName)
        {
            newFaceCodeID = FaceCodes[i].Id;
            FaceCodes.Remove(i, 1);
            break;
        }
    }
    newFaceCodeData.Id = newFaceCodeID;
    FaceCodes.InsertItem(0, newFaceCodeData);
}
public final function AddNewReinforcement(EReinforcementGUICategory Category, string VariableName)
{
    local NewReinforcementData NewData;
    
    if (IsNewReinforcementCategoryValid(Category))
    {
        if (FindNewReinforcementIndex(Category, VariableName) < 0)
        {
            NewData.Category = Category;
            NewData.VariableName = VariableName;
            NewReinforcements.AddItem(NewData);
        }
    }
}
public final function bool AreAnyCharactersDeployed()
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].Deployed)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CanPromoteClass(Name className)
{
    local SFXMPClassRecord ClassRecord;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord != None)
    {
        return ClassRecord.CanPromoteClass();
    }
    return FALSE;
}
public function ClearCurrentModifiableCharacter()
{
    CurrCharacterToModify = None;
}
public function ClearFaceCodes()
{
    FaceCodes.Remove(0, FaceCodes.Length);
}
public final function ClearLocalPRIMatchConsumablesForOfflineTransfer(SFXPRI PRI)
{
    ActiveMatchConsumablesForOfflineTransfer.Length = 0;
}
public final function ClearNewReinforcement(EReinforcementGUICategory Category, string VariableName)
{
    local int nVariableIndex;
    
    nVariableIndex = FindNewReinforcementIndex(Category, VariableName);
    if (nVariableIndex >= 0)
    {
        NewReinforcements.Remove(nVariableIndex, 1);
    }
}
public final function ClearNewReinforcementCategory(EReinforcementGUICategory Category)
{
    local int nCounter;
    
    nCounter = 0;
    while (nCounter < NewReinforcements.Length)
    {
        if (int(NewReinforcements[nCounter].Category) == int(Category))
        {
            NewReinforcements.Remove(nCounter, 1);
            continue;
        }
        nCounter++;
    }
}
public final function DeployCharacter(SFXMPCharacterRecord Character)
{
    local string KitArchetype;
    local SFXPawn_Player PawnArchetype;
    
    KitArchetype = GetKitArchetypeReference(Character.KitName);
    if (KitArchetype == "")
    {
        return;
    }
    PawnArchetype = SFXPawn_Player(Class'SFXEngine'.static.GetSeekFreeObject(KitArchetype, Class'SFXPawn_Player'));
    if (PawnArchetype == None)
    {
        return;
    }
    Character.InitializeFromCharacterClass(PawnArchetype.PlayerClassName);
    Character.Deployed = TRUE;
}
private final function int FindNewReinforcementIndex(EReinforcementGUICategory Category, string VariableName)
{
    local int nVariableIndex;
    
    if (Category != EReinforcementGUICategory.EReinforcementGUICategory_None)
    {
        for (nVariableIndex = 0; nVariableIndex < NewReinforcements.Length; ++nVariableIndex)
        {
            if (int(NewReinforcements[nVariableIndex].Category) == int(Category) && NewReinforcements[nVariableIndex].VariableName == VariableName)
            {
                return nVariableIndex;
            }
        }
    }
    return -1;
}
public function array<SFXMPCharacterRecord> GetAllCharacterRecords()
{
    return Characters;
}
public function array<SFXMPClassRecord> GetAllClassRecords()
{
    return Classes;
}
public function SFXMPCharacterRecord GetCharacterRecord(Name KitName)
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].KitName == KitName)
        {
            return Characters[idx];
        }
    }
    return None;
}
public function array<SFXMPCharacterRecord> GetCharacterRecords(Name className)
{
    local array<SFXMPCharacterRecord> AllClassCharacters;
    local SFXMPClassRecord ClassRecord;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord != None)
    {
        AllClassCharacters = ClassRecord.Characters;
    }
    else
    {
        AllClassCharacters.Length = 0;
    }
    return AllClassCharacters;
}
public function int GetClassLevel(Name className)
{
    local SFXMPClassRecord ClassRecord;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord != None)
    {
        return ClassRecord.Level;
    }
    return -1;
}
public function stringref GetClassPrettyName(Name BaseClassName)
{
    local int ClassDataIndex;
    
    ClassDataIndex = MPClasses.Find('className', BaseClassName);
    if (ClassDataIndex >= 0)
    {
        return MPClasses[ClassDataIndex].srDisplayName;
    }
    return stringref(0);
}
public function SFXMPClassRecord GetClassRecord(Name className)
{
    local int idx;
    
    for (idx = 0; idx < Classes.Length; ++idx)
    {
        if (Classes[idx].className == className)
        {
            return Classes[idx];
        }
    }
    return None;
}
public function int GetCredits()
{
    return AvailableCredits;
}
public function SFXMPCharacterRecord GetCurrentModifiableCharacter()
{
    return CurrCharacterToModify;
}
public function SFXMPCharacterRecord GetCurrentSelectedCharacterRecord()
{
    if (CurrentCharacter == None)
    {
        SwitchToLastSelectedCharacterRecord();
    }
    return CurrentCharacter;
}
public function array<MPFaceCodeData> GetFaceCodes()
{
    return FaceCodes;
}
public function string GetKitArchetypeReference(Name KitName)
{
    local int KitDataIndex;
    
    KitDataIndex = MPKits.Find('KitName', KitName);
    if (KitDataIndex >= 0)
    {
        return MPKits[KitDataIndex].ArchetypeRef;
    }
    return "";
}
public function stringref GetKitBaseClassPrettyName(Name KitName)
{
    local int KitDataIndex;
    
    KitDataIndex = MPKits.Find('KitName', KitName);
    if (KitDataIndex >= 0)
    {
        return GetClassPrettyName(MPKits[KitDataIndex].BaseMPClassName);
    }
    return stringref(0);
}
public function MPKitData GetKitData(Name KitName)
{
    local int KitDataIndex;
    local MPKitData ReturnData;
    
    KitDataIndex = MPKits.Find('KitName', KitName);
    if (KitDataIndex >= 0)
    {
        ReturnData = MPKits[KitDataIndex];
    }
    return ReturnData;
}
public function stringref GetKitDefaultName(Name KitName)
{
    local int KitDataIndex;
    
    KitDataIndex = MPKits.Find('KitName', KitName);
    if (KitDataIndex >= 0)
    {
        return MPKits[KitDataIndex].srDefaultName;
    }
    return stringref(0);
}
public function Name GetLastSelectedCharacterRecordName()
{
    local BioPlayerController PC;
    
    PC = GetPC();
    if (PC != None && PC.ProfileSettings != None)
    {
        return Name(PC.ProfileSettings.GetLastSelectedCharacter());
    }
    return 'None';
}
public function SFXMatchResultsData GetMPMatchResultsData()
{
    if (MPMatchResultsData == None)
    {
        MPMatchResultsData = new Class'SFXMatchResultsData';
    }
    return MPMatchResultsData;
}
public function int GetNextPackToConsume()
{
    return NextPackToConsume;
}
public function int GetNumCopiesToConsume()
{
    return NumCopiesToConsume;
}
public final function SFXOnlineMOTDInfo GetPromotionalMessageData()
{
    local SFXOnlineMOTDInfo ReturnMessageInfo;
    
    if (GetPlayerVariable('LastPromoIDShown') == 0)
    {
        ReturnMessageInfo.Title = string(DefaultTutorialMessage.MessageTitle);
        ReturnMessageInfo.Message = string(DefaultTutorialMessage.MessageText);
        ReturnMessageInfo.Image = DefaultTutorialMessage.ImageURL;
        ReturnMessageInfo.TrackingID = DefaultTutorialMessage.TrackingID;
        ReturnMessageInfo.offerId = DefaultTutorialMessage.offerId;
        return ReturnMessageInfo;
    }
    return Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentNotification().GetMOTDInfo(8);
}
public function string GetUniqueCharacterName(Name KitName)
{
    local int nNameCounter;
    local string IntialCharacterName;
    local string GeneratedCharacterName;
    local ECharacterNameResult eInitialResult;
    
    IntialCharacterName = string(GetKitDefaultName(KitName));
    GeneratedCharacterName = IntialCharacterName;
    nNameCounter = 1;
    eInitialResult = VerifyNameIsValid(GeneratedCharacterName);
    if (eInitialResult != ECharacterNameResult.ECharacterNameResult_AllGood)
    {
        if (eInitialResult == ECharacterNameResult.ECharacterNameResult_NotUnique)
        {
            for (; int(VerifyNameIsValid(GeneratedCharacterName)) == 1; nNameCounter++)
            {
                GeneratedCharacterName = IntialCharacterName $ nNameCounter;
            }
        }
        else
        {
            return "";
        }
    }
    return GeneratedCharacterName;
}
private final function HandlePendingOperations()
{
    local PendingSaveOperation NextPendingSave;
    local PendingLoadOperation NextPendingLoad;
    
    if (PendingSaveOperations.Length > 0)
    {
        NextPendingSave = PendingSaveOperations[0];
        PendingSaveOperations.Remove(0, 1);
        SaveRecordsImpl(NextPendingSave.ForceSaveBase, NextPendingSave.SaveDelegate);
    }
    else if (PendingLoadOperations.Length > 0)
    {
        NextPendingLoad = PendingLoadOperations[0];
        PendingLoadOperations.Remove(0, 1);
        RefreshMPDataFromServerImpl(NextPendingLoad.LoadDelegate);
    }
}
public final function bool HasNewReinforcement(EReinforcementGUICategory Category, string VariableName)
{
    return FindNewReinforcementIndex(Category, VariableName) >= 0;
}
public final function bool HasNewReinforcementCategory(EReinforcementGUICategory Category)
{
    return NewReinforcements.Find('Category', Category) >= 0;
}
public final function bool HasNewReinforcementWithSubstringInName(EReinforcementGUICategory Category, string Substring)
{
    local int idx;
    
    for (idx = 0; idx < NewReinforcements.Length; ++idx)
    {
        if (int(Category) == int(NewReinforcements[idx].Category))
        {
            if (InStr(NewReinforcements[idx].VariableName, Substring, , , ) != -1)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
private final function InitializeCharacterNames()
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].CharacterName == "")
        {
            Characters[idx].CharacterName = GetUniqueCharacterName(Characters[idx].KitName);
        }
    }
}
public function bool IsCurrentSelectedCharacterRecordValid()
{
    return CurrentCharacter != None && CurrentCharacter.Deployed;
}
public function bool IsKitUnlocked(Name KitName)
{
    local int KitDataIndex;
    
    KitDataIndex = MPKits.Find('KitName', KitName);
    if (KitDataIndex >= 0)
    {
        if (MPKits[KitDataIndex].bPermanentlyLocked)
        {
            return FALSE;
        }
        if (MPKits[KitDataIndex].bLockedByDefault)
        {
            return GetPlayerVariable(KitName) > 0;
        }
        return TRUE;
    }
    return FALSE;
}
public final function bool IsNewReinforcementCategoryValid(EReinforcementGUICategory Category)
{
    return ValidNewReinforcementCategories.Find(Category) >= 0;
}
public function LevelUpClass(Name className, float fXP)
{
    local SFXMPClassRecord ClassRecord;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord == None)
    {
        return;
    }
    ClassRecord.LevelUpClass(fXP, GetPC());
}
public final function LoadCharacters()
{
    if (!bInitialized)
    {
        CurrentCharacter = None;
        bInitialized = TRUE;
        OnlineSave.LoadCompleted();
        RefreshMPData();
    }
}
public final function OnTooNewErrorMessageInput(bool bAPressed, int nContext);

public function PackConsumed()
{
    NextPackToConsume = -1;
    NumCopiesToConsume = 0;
}
public function bool PromoteClass(Name className)
{
    local SFXMPClassRecord ClassRecord;
    local bool bResult;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord != None)
    {
        bResult = ClassRecord.PromoteClass();
        if (bResult)
        {
            if (Class'Engine'.static.GetCurrentWorldInfo().Game != None)
            {
                Class'Engine'.static.GetCurrentWorldInfo().Game.WriteOnlineStats();
            }
            if (CurrentCharacter.className == className)
            {
                CurrentCharacter = None;
            }
        }
        return bResult;
    }
    return FALSE;
}
private final function ReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    oEngine.OnlineSubsystem.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum, ReadPlayerStorageComplete);
    if (bWasSuccessful)
    {
        RefreshMPData();
        __OnRefreshMPDataDelegate__Delegate(0);
    }
    else
    {
        __OnRefreshMPDataDelegate__Delegate(-1);
    }
    __OnRefreshMPDataDelegate__Delegate = None;
    m_bLoadInProgress = FALSE;
    HandlePendingOperations();
}
private final function RefreshMPData()
{
    local SFXSaveManagerMP SelfRef;
    
    if (!Class'SFXGameConfig'.static.VerifyPurchasableItems())
    {
    }
    ResetMPData();
    NewReinforcements.Length = 0;
    SelfRef = Self;
    OnlineSave.LoadToSaveManager(SelfRef);
    InitializeCharacterNames();
    SwitchToLastSelectedCharacterRecord();
}
public final function RefreshMPDataFromServer(optional delegate<OnRefreshMPDataDelegate> RefreshDelegate)
{
    local PendingLoadOperation PendingLoad;
    
    if (m_bSaveInProgress || m_bLoadInProgress)
    {
        PendingLoad.LoadDelegate = RefreshDelegate;
        PendingLoadOperations.AddItem(PendingLoad);
    }
    else
    {
        RefreshMPDataFromServerImpl(RefreshDelegate);
    }
}
public final function bool RefreshMPDataFromServerImpl(optional delegate<OnRefreshMPDataDelegate> RefreshDelegate)
{
    local SFXEngine oEngine;
    
    m_bLoadInProgress = TRUE;
    __OnRefreshMPDataDelegate__Delegate = RefreshDelegate;
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        __OnRefreshMPDataDelegate__Delegate(-2);
        __OnRefreshMPDataDelegate__Delegate = None;
        return FALSE;
    }
    if (oEngine.ReadPlayerStorage(ReadPlayerStorageComplete) == FALSE)
    {
        __OnRefreshMPDataDelegate__Delegate(-2);
        __OnRefreshMPDataDelegate__Delegate = None;
        return FALSE;
    }
    return TRUE;
}
public function ResetCharacter(Name KitName)
{
    local SFXMPCharacterRecord CharacterRecord;
    
    CharacterRecord = GetCharacterRecord(KitName);
    if (CharacterRecord == None)
    {
        return;
    }
    CharacterRecord.ResetCharacter();
}
public function ResetClass(Name className)
{
    local SFXMPClassRecord ClassRecord;
    
    ClassRecord = GetClassRecord(className);
    if (ClassRecord == None)
    {
        return;
    }
    ClassRecord.ResetClass();
}
public final function ResetMPData()
{
    SetupInitialMPCharacters();
    SetCredits(0);
    ResetMPPlayerVariables();
}
public final function SaveLocalPRIMatchConsumablesForOfflineTransfer(SFXPRI PRI)
{
    PRI.GetActiveMatchConsumables(ActiveMatchConsumablesForOfflineTransfer);
}
public function SaveRecords(optional bool ForceSaveBase, optional delegate<OnSaveRecordsDelegate> SaveDelegate)
{
    local PendingSaveOperation PendingSave;
    
    if (!bDisableSaving)
    {
        if (m_bSaveInProgress || m_bLoadInProgress)
        {
            PendingSave.ForceSaveBase = ForceSaveBase;
            PendingSave.SaveDelegate = SaveDelegate;
            PendingSaveOperations.AddItem(PendingSave);
        }
        else
        {
            SaveRecordsImpl(ForceSaveBase, SaveDelegate);
        }
    }
}
private final function SaveRecordsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        OnlineSave.SaveComplete();
        OnlineSave.AcknowledgeWriteComplete(LocalUserNum, SaveRecordsComplete);
        if (__OnSaveRecordsDelegate__Delegate != None)
        {
            __OnSaveRecordsDelegate__Delegate(0);
        }
    }
    else if (__OnSaveRecordsDelegate__Delegate != None)
    {
        __OnSaveRecordsDelegate__Delegate(-1);
    }
    m_bSaveInProgress = FALSE;
    HandlePendingOperations();
}
private final function SaveRecordsImpl(optional bool ForceSaveBase, optional delegate<OnSaveRecordsDelegate> SaveDelegate)
{
    local WorldInfo World;
    local int ControllerId;
    local PlayerController pController;
    local SFXSaveManagerMP SelfRef;
    
    if (!bDisableSaving)
    {
        m_bSaveInProgress = TRUE;
        World = Class'Engine'.static.GetCurrentWorldInfo();
        pController = World.GetALocalPlayerController();
        SelfRef = Self;
        OnlineSave.UpdateFromSaveManager(SelfRef, ForceSaveBase);
        ControllerId = LocalPlayer(pController.Player).ControllerId;
        __OnSaveRecordsDelegate__Delegate = SaveDelegate;
        if (!OnlineSave.Write(byte(ControllerId), SaveRecordsComplete))
        {
        }
    }
}
public function SetCredits(int nCreditAmount)
{
    AvailableCredits = Max(0, nCreditAmount);
}
public function bool SetCurrentModifiableCharacter(Name KitName)
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].KitName == KitName)
        {
            CurrCharacterToModify = Characters[idx];
            return TRUE;
        }
    }
    return FALSE;
}
public function bool SetCurrentSelectedCharacterRecord(Name KitName)
{
    local BioPlayerController PC;
    local bool bFoundCharacter;
    local int idx;
    local array<int> RequiredDLC;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].KitName == KitName)
        {
            RequiredDLC = GetKitData(KitName).RequiredDLCModuleIDs;
            if (Class'SFXEngine'.static.HasRequiredDLC(RequiredDLC))
            {
                bFoundCharacter = TRUE;
                if (Characters[idx].Deployed)
                {
                    CurrentCharacter = Characters[idx];
                }
                else
                {
                    CurrentCharacter = None;
                    return FALSE;
                }
                break;
            }
        }
    }
    if (!bFoundCharacter)
    {
        return FALSE;
    }
    PC = GetPC();
    if (PC != None && PC.ProfileSettings != None)
    {
        PC.ProfileSettings.SetLastSelectedCharacter(string(KitName));
        PC.SaveProfile();
    }
    return TRUE;
}
public function SetFaceCodesFromServer(out array<MPFaceCodeData> serverFaceCodes)
{
    FaceCodes = serverFaceCodes;
}
public function bool SetNextPackToConsume(int nID, int nCopies)
{
    if (NextPackToConsume == -1)
    {
        NextPackToConsume = nID;
        NumCopiesToConsume = nCopies;
        return TRUE;
    }
    return FALSE;
}
public function SetSavingDisabled(bool bDisabled)
{
    bDisableSaving = bDisabled;
}
public final function ShowDataTooNewError()
{
    local BioMessageBoxOptionalParams Params;
    
    Params.bModal = TRUE;
    Params.srAText = srTooNewErrorMessageBoxOK;
    Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('TooNewError', 2, srTooNewErrorMessage, Params, OnTooNewErrorMessageInput);
}
public function SubtractCredits(int nCreditAmount, optional string Transaction)
{
    AvailableCredits = Max(0, AvailableCredits - nCreditAmount);
    TotalCreditsSpent += nCreditAmount;
    SessionCreditsSpent += nCreditAmount;
    Class'SFXTelemetryHooks'.static.SendMPCredits(-nCreditAmount, AvailableCredits, SessionCreditsEarned, SessionCreditsSpent, Transaction);
}
private final function bool SwitchToLastSelectedCharacterRecord()
{
    local Name LastSelectedKitName;
    local BioWorldInfo BWI;
    local int KitIdx;
    
    LastSelectedKitName = GetLastSelectedCharacterRecordName();
    BWI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (BWI != None && BWI.GetAutoBotsEnabled() == TRUE)
    {
        if (BWI.m_nAutoBotMPKit >= 0 && BWI.m_nAutoBotMPKit < MPKits.Length)
        {
            KitIdx = BWI.m_nAutoBotMPKit;
        }
        else
        {
            KitIdx = Rand(MPKits.Length);
        }
        LastSelectedKitName = MPKits[KitIdx].KitName;
    }
    return SetCurrentSelectedCharacterRecord(LastSelectedKitName);
}
public final function UnlockAllMPKits()
{
    local int idx;
    
    for (idx = 0; idx < MPKits.Length; ++idx)
    {
        if (GetPlayerVariable(MPKits[idx].KitName) < MPKits[idx].MaxNewUnlockLevel)
        {
            SetPlayerVariable(MPKits[idx].KitName, MPKits[idx].MaxNewUnlockLevel);
        }
    }
}
public function ECharacterNameResult VerifyNameIsValid(string CharacterName, optional SFXMPCharacterRecord RecordToIgnore = None)
{
    local int idx;
    local bool bCharacterNameFound;
    
    bCharacterNameFound = FALSE;
    if (CharacterName == "")
    {
        return ECharacterNameResult.ECharacterNameResult_Empty;
    }
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx] != RecordToIgnore && Characters[idx].CharacterName == CharacterName)
        {
            bCharacterNameFound = TRUE;
            break;
        }
    }
    if (bCharacterNameFound)
    {
        return ECharacterNameResult.ECharacterNameResult_NotUnique;
    }
    return ECharacterNameResult.ECharacterNameResult_AllGood;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultTutorialMessage = {ImageURL = "Promo_n7.dds", TrackingID = 1, offerId = 0, MessageTitle = $723623, MessageText = $723624}
    MPClasses = ({className = 'Adept', srDisplayName = $93954, srDescription = $605057}, 
                 {className = 'Soldier', srDisplayName = $93952, srDescription = $605058}, 
                 {className = 'Engineer', srDisplayName = $93953, srDescription = $605059}, 
                 {className = 'Sentinel', srDisplayName = $93957, srDescription = $605060}, 
                 {className = 'Infiltrator', srDisplayName = $93955, srDescription = $605061}, 
                 {className = 'Vanguard', srDisplayName = $93956, srDescription = $605062}
                )
    MPKits = ({
               KitTextureRef = "GUI_MPImages.Kits.AdeptHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.AdeptHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Adept.HumanMale_Adept", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'AdeptHumanMale', 
               BaseMPClassName = 'Adept', 
               srDisplayName = $599553, 
               srDefaultName = $634915, 
               PowerIconIndex1 = 27, 
               PowerIconIndex2 = 26, 
               PowerIconIndex3 = 50, 
               srPowerName1 = $127058, 
               srPowerName2 = $501005, 
               srPowerName3 = $314056, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.EngineerHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.EngineerHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Engineer.HumanMale_Engineer", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'EngineerHumanMale', 
               BaseMPClassName = 'Engineer', 
               srDisplayName = $599553, 
               srDefaultName = $634919, 
               PowerIconIndex1 = 59, 
               PowerIconIndex2 = 52, 
               PowerIconIndex3 = 42, 
               srPowerName1 = $244472, 
               srPowerName2 = $250696, 
               srPowerName3 = $199784, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.InfiltratorHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.InfiltratorHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanMale_Infiltrator", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'InfiltratorHumanMale', 
               BaseMPClassName = 'Infiltrator', 
               srDisplayName = $599553, 
               srDefaultName = $634923, 
               PowerIconIndex1 = 88, 
               PowerIconIndex2 = 33, 
               PowerIconIndex3 = 60, 
               srPowerName1 = $658546, 
               srPowerName2 = $245248, 
               srPowerName3 = $325479, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.SentinelHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.SentinelHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Sentinel.HumanMale_Sentinel", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SentinelHumanMale', 
               BaseMPClassName = 'Sentinel', 
               srDisplayName = $599553, 
               srDefaultName = $634921, 
               PowerIconIndex1 = 25, 
               PowerIconIndex2 = 26, 
               PowerIconIndex3 = 64, 
               srPowerName1 = $501004, 
               srPowerName2 = $501005, 
               srPowerName3 = $297675, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.SoldierHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.SoldierHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_Soldier", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SoldierHumanMale', 
               BaseMPClassName = 'Soldier', 
               srDisplayName = $599553, 
               srDefaultName = $634917, 
               PowerIconIndex1 = 63, 
               PowerIconIndex2 = 44, 
               PowerIconIndex3 = 78, 
               srPowerName1 = $505301, 
               srPowerName2 = $190258, 
               srPowerName3 = $506269, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.VanguardHumanMale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.VanguardHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Vanguard.HumanMale_Vanguard", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'VanguardHumanMale', 
               BaseMPClassName = 'Vanguard', 
               srDisplayName = $599553, 
               srDefaultName = $634925, 
               PowerIconIndex1 = 65, 
               PowerIconIndex2 = 50, 
               PowerIconIndex3 = 87, 
               srPowerName1 = $634683, 
               srPowerName2 = $314056, 
               srPowerName3 = $663225, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.AdeptHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.AdeptHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Adept.HumanFemale_Adept", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'AdeptHumanFemale', 
               BaseMPClassName = 'Adept', 
               srDisplayName = $599554, 
               srDefaultName = $634916, 
               PowerIconIndex1 = 27, 
               PowerIconIndex2 = 26, 
               PowerIconIndex3 = 50, 
               srPowerName1 = $127058, 
               srPowerName2 = $501005, 
               srPowerName3 = $314056, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.EngineerHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.EngineerHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Engineer.HumanFemale_Engineer", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'EngineerHumanFemale', 
               BaseMPClassName = 'Engineer', 
               srDisplayName = $599554, 
               srDefaultName = $634920, 
               PowerIconIndex1 = 59, 
               PowerIconIndex2 = 52, 
               PowerIconIndex3 = 42, 
               srPowerName1 = $244472, 
               srPowerName2 = $250696, 
               srPowerName3 = $199784, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.InfiltratorHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.InfiltratorHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanFemale_Infiltrator", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'InfiltratorHumanFemale', 
               BaseMPClassName = 'Infiltrator', 
               srDisplayName = $599554, 
               srDefaultName = $634924, 
               PowerIconIndex1 = 88, 
               PowerIconIndex2 = 33, 
               PowerIconIndex3 = 60, 
               srPowerName1 = $658546, 
               srPowerName2 = $245248, 
               srPowerName3 = $325479, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.SentinelHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.SentinelHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Sentinel.HumanFemale_Sentinel", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SentinelHumanFemale', 
               BaseMPClassName = 'Sentinel', 
               srDisplayName = $599554, 
               srDefaultName = $634922, 
               PowerIconIndex1 = 25, 
               PowerIconIndex2 = 26, 
               PowerIconIndex3 = 64, 
               srPowerName1 = $501004, 
               srPowerName2 = $501005, 
               srPowerName3 = $297675, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.SoldierHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.SoldierHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Soldier.HumanFemale_Soldier", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SoldierHumanFemale', 
               BaseMPClassName = 'Soldier', 
               srDisplayName = $599554, 
               srDefaultName = $634918, 
               PowerIconIndex1 = 63, 
               PowerIconIndex2 = 44, 
               PowerIconIndex3 = 78, 
               srPowerName1 = $505301, 
               srPowerName2 = $190258, 
               srPowerName3 = $506269, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.VanguardHumanFemale", 
               LockedKitTextureRef = "GUI_MPImages.Kits.VanguardHumanFemale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Vanguard.HumanFemale_Vanguard", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'VanguardHumanFemale', 
               BaseMPClassName = 'Vanguard', 
               srDisplayName = $599554, 
               srDefaultName = $634926, 
               PowerIconIndex1 = 65, 
               PowerIconIndex2 = 50, 
               PowerIconIndex3 = 87, 
               srPowerName1 = $634683, 
               srPowerName2 = $314056, 
               srPowerName3 = $663225, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = FALSE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Asari0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Asari0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Adept.Asari_Adept", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'AdeptAsari', 
               BaseMPClassName = 'Adept', 
               srDisplayName = $619623, 
               srDefaultName = $634928, 
               PowerIconIndex1 = 76, 
               PowerIconIndex2 = 26, 
               PowerIconIndex3 = 25, 
               srPowerName1 = $127059, 
               srPowerName2 = $501005, 
               srPowerName3 = $501004, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Drell0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Drell0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Adept.Drell_Adept2", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'AdeptDrell', 
               BaseMPClassName = 'Adept', 
               srDisplayName = $619624, 
               srDefaultName = $619624, 
               PowerIconIndex1 = 51, 
               PowerIconIndex2 = 43, 
               PowerIconIndex3 = 96, 
               srPowerName1 = $314878, 
               srPowerName2 = $189298, 
               srPowerName3 = $660491, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Quarian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Quarian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Engineer.Quarian_Engineer", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'EngineerQuarian', 
               BaseMPClassName = 'Engineer', 
               srDisplayName = $696827, 
               srDefaultName = $634920, 
               PowerIconIndex1 = 59, 
               PowerIconIndex2 = 60, 
               PowerIconIndex3 = 81, 
               srPowerName1 = $244472, 
               srPowerName2 = $325479, 
               srPowerName3 = $558975, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Salarian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Salarian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Engineer.Salarian_Engineer2", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'EngineerSalarian', 
               BaseMPClassName = 'Engineer', 
               srDisplayName = $633713, 
               srDefaultName = $633713, 
               PowerIconIndex1 = 59, 
               PowerIconIndex2 = 48, 
               PowerIconIndex3 = 89, 
               srPowerName1 = $244472, 
               srPowerName2 = $205894, 
               srPowerName3 = $674631, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Salarian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Salarian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Infiltrator.Salarian_Infiltrator", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'InfiltratorSalarian', 
               BaseMPClassName = 'Infiltrator', 
               srDisplayName = $633713, 
               srDefaultName = $634930, 
               PowerIconIndex1 = 48, 
               PowerIconIndex2 = 33, 
               PowerIconIndex3 = 83, 
               srPowerName1 = $205894, 
               srPowerName2 = $245248, 
               srPowerName3 = $572665, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Quarian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Quarian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Infiltrator.Quarian_Infiltrator2", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'InfiltratorQuarian', 
               BaseMPClassName = 'Infiltrator', 
               srDisplayName = $696827, 
               srDefaultName = $696827, 
               PowerIconIndex1 = 88, 
               PowerIconIndex2 = 33, 
               PowerIconIndex3 = 6, 
               srPowerName1 = $658546, 
               srPowerName2 = $245248, 
               srPowerName3 = $536448, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Turian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Turian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Sentinel.Turian_Sentinel", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SentinelTurian', 
               BaseMPClassName = 'Sentinel', 
               srDisplayName = $633714, 
               srDefaultName = $634931, 
               PowerIconIndex1 = 26, 
               PowerIconIndex2 = 52, 
               PowerIconIndex3 = 64, 
               srPowerName1 = $501005, 
               srPowerName2 = $250696, 
               srPowerName3 = $297675, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Krogan0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Krogan0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Sentinel.Krogan_Sentinel", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SentinelKrogan', 
               BaseMPClassName = 'Sentinel', 
               srDisplayName = $619625, 
               srDefaultName = $619625, 
               PowerIconIndex1 = 59, 
               PowerIconIndex2 = 85, 
               PowerIconIndex3 = 64, 
               srPowerName1 = $244472, 
               srPowerName2 = $538988, 
               srPowerName3 = $297675, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Krogan0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Krogan0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Soldier.Krogan_Soldier", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SoldierKrogan', 
               BaseMPClassName = 'Soldier', 
               srDisplayName = $619625, 
               srDefaultName = $634927, 
               PowerIconIndex1 = 16, 
               PowerIconIndex2 = 66, 
               PowerIconIndex3 = 49, 
               srPowerName1 = $668831, 
               srPowerName2 = $314036, 
               srPowerName3 = $349055, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Turian0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Turian0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Soldier.Turian_Soldier2", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SoldierTurian', 
               BaseMPClassName = 'Soldier', 
               srDisplayName = $633714, 
               srDefaultName = $633714, 
               PowerIconIndex1 = 82, 
               PowerIconIndex2 = 44, 
               PowerIconIndex3 = 83, 
               srPowerName1 = $572088, 
               srPowerName2 = $190258, 
               srPowerName3 = $572665, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Drell0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Drell0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Vanguard.Drell_Vanguard", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'VanguardDrell', 
               BaseMPClassName = 'Vanguard', 
               srDisplayName = $619624, 
               srDefaultName = $634929, 
               PowerIconIndex1 = 65, 
               PowerIconIndex2 = 43, 
               PowerIconIndex3 = 96, 
               srPowerName1 = $634683, 
               srPowerName2 = $189298, 
               srPowerName3 = $660491, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_Asari0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.MP_Asari0", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Vanguard.Asari_Vanguard2", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'VanguardAsari', 
               BaseMPClassName = 'Vanguard', 
               srDisplayName = $619623, 
               srDefaultName = $619623, 
               PowerIconIndex1 = 65, 
               PowerIconIndex2 = 76, 
               PowerIconIndex3 = 85, 
               srPowerName1 = $634683, 
               srPowerName2 = $127059, 
               srPowerName3 = $538988, 
               MaxNewUnlockLevel = 5, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = TRUE, 
               bUseSecondaryColor = TRUE, 
               bUsePattern = TRUE, 
               bUsePatternColor = TRUE, 
               bUsePhong = TRUE, 
               bUseEmissive = TRUE, 
               bUseSkinTone = TRUE, 
               bHideIfLocked = FALSE
              }, 
              {
               KitTextureRef = "GUI_MPImages.Kits.MP_BF_HMM0", 
               LockedKitTextureRef = "GUI_MPImages.Kits.SoldierHumanMale", 
               SmallKitTextureRef = "", 
               ArchetypeRef = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_SoldierBF3", 
               PowerIconResource = "GUI_SF_PowerIcons.PowerIcons", 
               RequiredDLCModuleIDs = (), 
               KitName = 'SoldierHumanMaleBF3', 
               BaseMPClassName = 'Soldier', 
               srDisplayName = $723304, 
               srDefaultName = $634917, 
               PowerIconIndex1 = 63, 
               PowerIconIndex2 = 16, 
               PowerIconIndex3 = 78, 
               srPowerName1 = $505301, 
               srPowerName2 = $668831, 
               srPowerName3 = $506269, 
               MaxNewUnlockLevel = 4, 
               bLockedByDefault = TRUE, 
               bPermanentlyLocked = FALSE, 
               bUsePrimaryColor = FALSE, 
               bUseSecondaryColor = FALSE, 
               bUsePattern = FALSE, 
               bUsePatternColor = FALSE, 
               bUsePhong = FALSE, 
               bUseEmissive = FALSE, 
               bUseSkinTone = FALSE, 
               bHideIfLocked = TRUE
              }
             )
    DefaultMPPlayerVariables = ({PlayerVariable = "SFXGameContent.SFXWeapon_AssaultRifle_Avenger", Value = 1}, 
                                {PlayerVariable = "SFXGameContent.SFXWeapon_SniperRifle_Mantis", Value = 1}, 
                                {PlayerVariable = "SFXGameContent.SFXWeapon_Shotgun_Katana", Value = 1}, 
                                {PlayerVariable = "SFXGameContent.SFXWeapon_SMG_Shuriken", Value = 1}, 
                                {PlayerVariable = "SFXGameContent.SFXWeapon_Pistol_Predator", Value = 1}, 
                                {PlayerVariable = "MPCapacity_Ammo", Value = 2}, 
                                {PlayerVariable = "MPCapacity_Revive", Value = 2}, 
                                {PlayerVariable = "MPCapacity_Rocket", Value = 2}, 
                                {PlayerVariable = "MPCapacity_Shield", Value = 2}, 
                                {PlayerVariable = "AdeptHumanMale", Value = 1}, 
                                {PlayerVariable = "EngineerHumanMale", Value = 1}, 
                                {PlayerVariable = "InfiltratorHumanMale", Value = 1}, 
                                {PlayerVariable = "SentinelHumanMale", Value = 1}, 
                                {PlayerVariable = "SoldierHumanMale", Value = 1}, 
                                {PlayerVariable = "VanguardHumanMale", Value = 1}, 
                                {PlayerVariable = "AdeptHumanFemale", Value = 1}, 
                                {PlayerVariable = "EngineerHumanFemale", Value = 1}, 
                                {PlayerVariable = "InfiltratorHumanFemale", Value = 1}, 
                                {PlayerVariable = "SentinelHumanFemale", Value = 1}, 
                                {PlayerVariable = "SoldierHumanFemale", Value = 1}, 
                                {PlayerVariable = "VanguardHumanFemale", Value = 1}
                               )
    ValidNewReinforcementCategories = (EReinforcementGUICategory.EReinforcementGUICategory_Mod, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_AssaultRifle, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_SniperRifle, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_Pistol, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_SMG, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_Shotgun, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_Kit, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_KitAppearance, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_MatchConsumableAmmo, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_MatchConsumableWeapon, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_MatchConsumableArmor, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_MatchConsumableGear, 
                                       EReinforcementGUICategory.EReinforcementGUICategory_NewlyAffordableStoreItems
                                      )
    NewlyAffordableStoreItemsPlayerVariableName = "NewlyAffordableStoreItems"
    MaxMPLevelBonus = 10
    NextPackToConsume = -1
    srTooNewErrorMessage = $708440
    srTooNewErrorMessageBoxOK = $708441
}