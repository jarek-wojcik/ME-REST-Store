Class SFXOnlineSaveGameMP
    native
    config(Game);

enum EMPSerializationResult
{
    EMPSerializationResult_Success,
    EMPSerializationResult_Failure,
    EMPSerializationResult_TooOld,
    EMPSerializationResult_TooNew,
    EMPSerializationResult_ForcedWipe,
};
const MAX_NUM_PLAYERVARIABLES = 1350;
const MAX_CLASSES = 8;
const MAX_CHARACTERS = 78;
const MAX_POWER_EVOLUTIONS = 6;
const MAX_PLAYERVARIABLE_VALUE = 255;

var string ServerBaseString;
var string ServerNewReinforcementsString;
var array<string> ServerClassStrings;
var array<string> ServerCharacterStrings;
var string ServerFaceCodesString;
var transient SFXOnlinePlayerStorage CachedOnlinePlayerStorage;
var config int DevelopmentVersionNumber;

public static native function int HexDecodeNumber(string hexToDecode);

public static native function string HexEncodeNumber(int numToEncode);

public function Initialize()
{
    CachedOnlinePlayerStorage = SFXEngine(Class'Engine'.static.GetEngine()).OnlinePlayerStorage;
}
private final function EMPSerializationResult SetBase(out SFXSaveManagerMP MPSaveManager)
{
    local int BaseCursor;
    local int Version;
    local int DevelopmentVersion;
    local array<string> BaseParts;
    
    if (ServerBaseString == "")
    {
        return EMPSerializationResult.EMPSerializationResult_Success;
    }
    ParseStringIntoArray(ServerBaseString, BaseParts, ";", FALSE);
    BaseCursor = 0;
    Version = int(BaseParts[BaseCursor++]);
    if (Version < 13)
    {
        return EMPSerializationResult.EMPSerializationResult_TooOld;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_TooNew;
    }
    DevelopmentVersion = int(BaseParts[BaseCursor++]);
    if (DevelopmentVersion < DevelopmentVersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_ForcedWipe;
    }
    MPSaveManager.SetCredits(int(BaseParts[BaseCursor++]));
    if (Version > 16)
    {
        MPSaveManager.NextPackToConsume = int(BaseParts[BaseCursor++]);
        MPSaveManager.NumCopiesToConsume = int(BaseParts[BaseCursor++]);
    }
    MPSaveManager.TotalCreditsSpent = int(BaseParts[BaseCursor++]);
    MPSaveManager.TotalPlatformCurrencySpent = int(BaseParts[BaseCursor++]);
    MPSaveManager.TotalGamesPlayed = int(BaseParts[BaseCursor++]);
    MPSaveManager.TotalTimePlayed = int(BaseParts[BaseCursor++]);
    MPSaveManager.LastLevelUpTime = int(BaseParts[BaseCursor++]);
    if (Version > 18)
    {
        SetPlayerVariables(BaseParts[BaseCursor++], MPSaveManager);
    }
    else
    {
        SetPlayerVariablesV18(BaseParts[BaseCursor++], MPSaveManager);
    }
    return EMPSerializationResult.EMPSerializationResult_Success;
}
public final function bool Write(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    if (CachedOnlinePlayerStorage == None)
    {
        return FALSE;
    }
    return CachedOnlinePlayerStorage.Write(LocalUserNum, WritePlayerStorageCompleteDelegate);
}
private final function EMPSerializationResult SetCharacter(int CharacterIndex, const out SFXSaveManagerMP MPSaveManager)
{
    local string KitName;
    local SFXMPCharacterRecord CharacterRecord;
    local int CharacterCursor;
    local int Version;
    local int DevelopmentVersion;
    local array<string> CharacterParts;
    
    if (ServerCharacterStrings[CharacterIndex] == "")
    {
        return EMPSerializationResult.EMPSerializationResult_Success;
    }
    ParseStringIntoArray(ServerCharacterStrings[CharacterIndex], CharacterParts, ";", FALSE);
    CharacterCursor = 0;
    Version = int(CharacterParts[CharacterCursor++]);
    if (Version < 13)
    {
        return EMPSerializationResult.EMPSerializationResult_TooOld;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_TooNew;
    }
    DevelopmentVersion = int(CharacterParts[CharacterCursor++]);
    if (DevelopmentVersion < DevelopmentVersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_ForcedWipe;
    }
    KitName = CharacterParts[CharacterCursor++];
    CharacterRecord = MPSaveManager.GetCharacterRecord(Name(KitName));
    if (CharacterRecord == None)
    {
        return EMPSerializationResult.EMPSerializationResult_Failure;
    }
    else if (CharacterRecord.bSerializedFromBlaze)
    {
        return EMPSerializationResult.EMPSerializationResult_Failure;
    }
    CharacterRecord.CharacterName = CharacterParts[CharacterCursor++];
    CharacterRecord.Tint1ID = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.Tint2ID = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.PatternID = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.PatternColorID = int(CharacterParts[CharacterCursor++]);
    if (Version >= 15)
    {
        CharacterRecord.PhongID = int(CharacterParts[CharacterCursor++]);
        CharacterRecord.EmissiveID = int(CharacterParts[CharacterCursor++]);
    }
    CharacterRecord.SkinToneID = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.SecondsPlayed = float(int(CharacterParts[CharacterCursor++]));
    CharacterRecord.TimeStamp.Year = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.TimeStamp.Month = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.TimeStamp.Day = int(CharacterParts[CharacterCursor++]);
    CharacterRecord.TimeStamp.SecondsSinceMidnight = int(CharacterParts[CharacterCursor++]);
    SetPowers(CharacterParts[CharacterCursor++], CharacterRecord.Powers, Version);
    CharacterCursor++;
    SetWeapons(CharacterParts[CharacterCursor++], CharacterRecord.Weapons);
    SetWeaponMods(CharacterParts[CharacterCursor++], CharacterRecord.WeaponMods);
    CharacterRecord.Deployed = bool(CharacterParts[CharacterCursor++]);
    if (Version >= 20)
    {
        CharacterRecord.LeveledUp = bool(CharacterParts[CharacterCursor++]);
    }
    CharacterRecord.bSerializedFromBlaze = TRUE;
    return EMPSerializationResult.EMPSerializationResult_Success;
}
public final function AcknowledgeWriteComplete(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    if (CachedOnlinePlayerStorage == None)
    {
        return;
    }
    CachedOnlinePlayerStorage.AcknowledgeWriteComplete(LocalUserNum, WritePlayerStorageCompleteDelegate);
}
private final function string GetBase(const out SFXSaveManagerMP MPSaveManager)
{
    local string Credits;
    local string TelemetryValues;
    local string PlayerVariables;
    local string ConsumptionValues;
    
    Credits = string(MPSaveManager.GetCredits());
    ConsumptionValues = MPSaveManager.GetNextPackToConsume() $ ";" $ MPSaveManager.GetNumCopiesToConsume();
    TelemetryValues = MPSaveManager.TotalCreditsSpent $ ";" $ MPSaveManager.TotalPlatformCurrencySpent $ ";" $ MPSaveManager.TotalGamesPlayed $ ";" $ MPSaveManager.TotalTimePlayed $ ";" $ MPSaveManager.LastLevelUpTime;
    PlayerVariables = GetPlayerVariables(MPSaveManager);
    return CachedOnlinePlayerStorage.VersionNumber $ ";" $ DevelopmentVersionNumber $ ";" $ Credits $ ";" $ ConsumptionValues $ ";" $ TelemetryValues $ ";" $ PlayerVariables;
}
private final function string GetCharacter(const out SFXMPCharacterRecord CharacterRecord, const out SFXSaveManagerMP MPSaveManager, int nCharacterIndex)
{
    local string KitName;
    local string CharacterName;
    local string Tint1ID;
    local string Tint2ID;
    local string PatternID;
    local string PatternColorID;
    local string PhongID;
    local string EmissiveID;
    local string SkinToneID;
    local string SecondsPlayed;
    local string TimeStamp;
    local string Powers;
    local string HotKeys;
    local string Weapons;
    local string WeaponMods;
    local string Deployed;
    local string LeveledUp;
    local int KitDataIndex;
    local array<int> RequiredDLC;
    local array<string> ServerCharacterDataParts;
    
    KitName = string(CharacterRecord.KitName);
    KitDataIndex = MPSaveManager.MPKits.Find('KitName', CharacterRecord.KitName);
    if (KitDataIndex < 0)
    {
        return "";
    }
    RequiredDLC = MPSaveManager.MPKits[KitDataIndex].RequiredDLCModuleIDs;
    if (!Class'SFXEngine'.static.HasRequiredDLC(RequiredDLC))
    {
        ParseStringIntoArray(ServerCharacterStrings[nCharacterIndex], ServerCharacterDataParts, ";", FALSE);
        if (ServerCharacterDataParts[2] == KitName)
        {
            return "";
        }
    }
    CharacterName = Repl(CharacterRecord.CharacterName, ";", "", TRUE);
    Tint1ID = string(CharacterRecord.Tint1ID);
    Tint2ID = string(CharacterRecord.Tint2ID);
    PatternID = string(CharacterRecord.PatternID);
    PatternColorID = string(CharacterRecord.PatternColorID);
    PhongID = string(CharacterRecord.PhongID);
    EmissiveID = string(CharacterRecord.EmissiveID);
    SkinToneID = string(CharacterRecord.SkinToneID);
    SecondsPlayed = string(int(CharacterRecord.SecondsPlayed));
    TimeStamp = CharacterRecord.TimeStamp.Year $ ";" $ CharacterRecord.TimeStamp.Month $ ";" $ CharacterRecord.TimeStamp.Day $ ";" $ CharacterRecord.TimeStamp.SecondsSinceMidnight;
    Powers = GetPowers(CharacterRecord.Powers);
    HotKeys = "";
    Weapons = GetWeapons(CharacterRecord.Weapons);
    WeaponMods = GetWeaponMods(CharacterRecord.WeaponMods);
    Deployed = string(CharacterRecord.Deployed);
    LeveledUp = string(CharacterRecord.LeveledUp);
    return CachedOnlinePlayerStorage.VersionNumber $ ";" $ DevelopmentVersionNumber $ ";" $ KitName $ ";" $ CharacterName $ ";" $ Tint1ID $ ";" $ Tint2ID $ ";" $ PatternID $ ";" $ PatternColorID $ ";" $ PhongID $ ";" $ EmissiveID $ ";" $ SkinToneID $ ";" $ SecondsPlayed $ ";" $ TimeStamp $ ";" $ Powers $ ";" $ HotKeys $ ";" $ Weapons $ ";" $ WeaponMods $ ";" $ Deployed $ ";" $ LeveledUp;
}
private final function string GetClass(const out SFXMPClassRecord ClassRecord)
{
    local string className;
    local string Level;
    local string ExperienceOffset;
    local string NumPromotions;
    
    className = string(ClassRecord.className);
    Level = string(ClassRecord.Level);
    ExperienceOffset = string(ClassRecord.XPOffset);
    NumPromotions = string(ClassRecord.NumPromotions);
    return CachedOnlinePlayerStorage.VersionNumber $ ";" $ DevelopmentVersionNumber $ ";" $ className $ ";" $ Level $ ";" $ ExperienceOffset $ ";" $ NumPromotions;
}
private final function string GetFaceCodes(const out SFXSaveManagerMP MPSaveManager)
{
    local int i;
    local array<MPFaceCodeData> FaceCodes;
    local string faceCodesString;
    local string tempFaceCodeString;
    local string CharacterName;
    local string VersionNumber;
    
    VersionNumber = CachedOnlinePlayerStorage.VersionNumber $ ";";
    tempFaceCodeString = "";
    faceCodesString = VersionNumber;
    FaceCodes = MPSaveManager.GetFaceCodes();
    for (i = 0; i < FaceCodes.Length; ++i)
    {
        CharacterName = Repl(FaceCodes[i].firstName, ",", "", );
        tempFaceCodeString = faceCodesString $ FaceCodes[i].Id $ "," $ CharacterName $ "," $ FaceCodes[i].faceCode $ ";";
        if (Len(tempFaceCodeString) > CachedOnlinePlayerStorage.iMaxBytesPerStorage)
        {
            break;
        }
        faceCodesString = tempFaceCodeString;
    }
    return faceCodesString;
}
private final function string GetNewReinforcements(const out SFXSaveManagerMP MPSaveManager)
{
    local array<EReinforcementGUICategory> Categories;
    local array<string> CategoryData;
    local int nCurrCategoryIndex;
    local int idx;
    local int nCurrVariableID;
    local string NewReinforcementsString;
    
    Categories.Length = 0;
    for (idx = 0; idx < MPSaveManager.NewReinforcements.Length; ++idx)
    {
        nCurrCategoryIndex = Categories.Find(MPSaveManager.NewReinforcements[idx].Category);
        if (nCurrCategoryIndex < 0)
        {
            nCurrCategoryIndex = Categories.AddItem(MPSaveManager.NewReinforcements[idx].Category);
            CategoryData[nCurrCategoryIndex] = string(int(MPSaveManager.NewReinforcements[idx].Category));
        }
        nCurrVariableID = Class'SFXGameConfig'.static.GetPurchasableItemID(MPSaveManager.NewReinforcements[idx].VariableName);
        if (nCurrVariableID >= 0)
        {
            CategoryData[nCurrCategoryIndex] $= " " $ nCurrVariableID;
        }
    }
    NewReinforcementsString = "";
    JoinArray(CategoryData, NewReinforcementsString, ",", TRUE);
    return CachedOnlinePlayerStorage.VersionNumber $ ";" $ DevelopmentVersionNumber $ ";" $ NewReinforcementsString;
}
private final function string GetPlayerVariables(const out SFXSaveManagerMP MPSaveManager)
{
    local string PlayerVariableString;
    local string AmountString;
    local int idx;
    local int nAmount;
    local int CurrVariableID;
    local array<int> PlayerVariableAmounts;
    local array<Name> VariableIDs;
    local array<int> VariableValues;
    
    PlayerVariableAmounts.Length = Class'SFXGameConfig'.static.GetMaxPurchasableItemID() + 1;
    if (PlayerVariableAmounts.Length > 1350)
    {
    }
    PlayerVariableString = "";
    MPSaveManager.GetAllPlayerVariableIDsAndValues(VariableIDs, VariableValues);
    for (idx = 0; idx < VariableIDs.Length; ++idx)
    {
        nAmount = VariableValues[idx];
        nAmount = Min(nAmount, 255);
        if (MPSaveManager.m_bDebugPlayerVariables)
        {
        }
        CurrVariableID = int(string(VariableIDs[idx]));
        if (CurrVariableID >= 0 && CurrVariableID < PlayerVariableAmounts.Length)
        {
            PlayerVariableAmounts[CurrVariableID] = nAmount;
        }
    }
    for (idx = 0; idx < PlayerVariableAmounts.Length; ++idx)
    {
        if (idx < 1350)
        {
            nAmount = PlayerVariableAmounts[idx];
            AmountString = HexEncodeNumber(nAmount);
            PlayerVariableString $= AmountString;
            continue;
        }
        break;
    }
    return PlayerVariableString;
}
private final function string GetPowers(out array<PowerRecord> Powers)
{
    local string PowerString;
    local int idx;
    
    for (idx = 0; idx < Powers.Length; ++idx)
    {
        if (idx > 0)
        {
            PowerString $= ",";
        }
        PowerString $= GetPowerString(Powers[idx]);
    }
    return PowerString;
}
private static final function string GetPowerString(const PowerRecord Power)
{
    local string PowName;
    local string PowClassName;
    local string PowRank;
    local string PowEvolutions;
    local string PowHotkey;
    local string PowUsesTalentPoints;
    local int choice;
    local int PowerClassID;
    local bool FirstEvolution;
    
    FirstEvolution = TRUE;
    PowName = string(Power.PowerName);
    PowClassName = string(Power.PowerClassName);
    PowerClassID = Class'SFXGameConfig'.static.GetPurchasableItemID(PowClassName);
    if (PowerClassID == -1)
    {
        return "";
    }
    PowRank = string(Power.CurrentRank);
    for (choice = 0; choice < 6; ++choice)
    {
        if (FirstEvolution)
        {
            PowEvolutions $= Power.EvolvedChoices[choice];
            FirstEvolution = FALSE;
            continue;
        }
        PowEvolutions $= " " $ Power.EvolvedChoices[choice];
    }
    PowHotkey = string(Power.WheelDisplayIndex);
    PowUsesTalentPoints = string(Power.bUsesTalentPoints);
    return PowName $ " " $ PowerClassID $ " " $ PowRank $ " " $ PowEvolutions $ " " $ PowHotkey $ " " $ PowUsesTalentPoints;
}
private final function string GetWeaponMods(out array<WeaponModRecord> WeaponMods)
{
    local string WeaponModString;
    local string IDString;
    local string CurrentModString;
    local int idx;
    local int Idx2;
    local int nID;
    
    for (idx = 0; idx < WeaponMods.Length; ++idx)
    {
        IDString = "";
        nID = Class'SFXGameConfig'.static.GetPurchasableItemID(string(WeaponMods[idx].WeaponClassName));
        if (nID < 0)
        {
            continue;
        }
        IDString = string(nID);
        CurrentModString = IDString;
        for (Idx2 = 0; Idx2 < WeaponMods[idx].WeaponModClassNames.Length; ++Idx2)
        {
            IDString = "";
            nID = Class'SFXGameConfig'.static.GetPurchasableItemID(string(WeaponMods[idx].WeaponModClassNames[Idx2]));
            if (nID < 0)
            {
                continue;
            }
            IDString = string(nID);
            CurrentModString $= " " $ IDString;
        }
        if (WeaponModString != "")
        {
            WeaponModString $= ",";
        }
        WeaponModString $= CurrentModString;
    }
    return WeaponModString;
}
private final function string GetWeapons(out array<WeaponRecord> WeaponRecords)
{
    local string WeaponString;
    local string IDString;
    local int idx;
    local int nID;
    
    for (idx = 0; idx < WeaponRecords.Length; ++idx)
    {
        nID = Class'SFXGameConfig'.static.GetPurchasableItemID(string(WeaponRecords[idx].WeaponClassName));
        if (nID < 0)
        {
            continue;
        }
        IDString = string(nID);
        if (WeaponString != "")
        {
            WeaponString $= ",";
        }
        WeaponString $= IDString;
    }
    return WeaponString;
}
public function LoadCompleted()
{
    UpdateServerValues();
}
public function LoadToSaveManager(out SFXSaveManagerMP MPSaveManager)
{
    local int idx;
    local bool bNewerVersionDetected;
    local array<SFXMPCharacterRecord> AllCharacters;
    
    bNewerVersionDetected = FALSE;
    if (int(SetBase(MPSaveManager)) == 3)
    {
        bNewerVersionDetected = TRUE;
    }
    SetFaceCodes(MPSaveManager);
    if (int(SetNewReinforcements(MPSaveManager)) == 3)
    {
        bNewerVersionDetected = TRUE;
    }
    for (idx = 0; idx < ServerClassStrings.Length; ++idx)
    {
        if (int(SetClass(idx, MPSaveManager)) == 3)
        {
            bNewerVersionDetected = TRUE;
        }
    }
    AllCharacters = MPSaveManager.GetAllCharacterRecords();
    for (idx = 0; idx < AllCharacters.Length; ++idx)
    {
        AllCharacters[idx].bSerializedFromBlaze = FALSE;
    }
    for (idx = 0; idx < ServerCharacterStrings.Length; ++idx)
    {
        if (int(SetCharacter(idx, MPSaveManager)) == 3)
        {
            bNewerVersionDetected = TRUE;
        }
    }
    if (bNewerVersionDetected)
    {
        MPSaveManager.SetSavingDisabled(TRUE);
        MPSaveManager.ShowDataTooNewError();
    }
}
public function SaveComplete()
{
    UpdateServerValues();
}
private final function EMPSerializationResult SetClass(int ClassIndex, const out SFXSaveManagerMP MPSaveManager)
{
    local int ClassCursor;
    local int Version;
    local int DevelopmentVersion;
    local array<string> ClassParts;
    local string className;
    local SFXMPClassRecord ClassRecord;
    
    if (ServerClassStrings[ClassIndex] == "")
    {
        return EMPSerializationResult.EMPSerializationResult_Success;
    }
    ParseStringIntoArray(ServerClassStrings[ClassIndex], ClassParts, ";", FALSE);
    ClassCursor = 0;
    Version = int(ClassParts[ClassCursor++]);
    if (Version < 13)
    {
        return EMPSerializationResult.EMPSerializationResult_TooOld;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_TooNew;
    }
    DevelopmentVersion = int(ClassParts[ClassCursor++]);
    if (DevelopmentVersion < DevelopmentVersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_ForcedWipe;
    }
    className = ClassParts[ClassCursor++];
    ClassRecord = MPSaveManager.GetClassRecord(Name(className));
    if (ClassRecord == None)
    {
        return EMPSerializationResult.EMPSerializationResult_Failure;
    }
    ClassRecord.Level = int(ClassParts[ClassCursor++]);
    ClassRecord.XPOffset = float(int(ClassParts[ClassCursor++]));
    ClassRecord.NumPromotions = int(ClassParts[ClassCursor++]);
    return EMPSerializationResult.EMPSerializationResult_Success;
}
private final function EMPSerializationResult SetFaceCodes(out SFXSaveManagerMP MPSaveManager)
{
    local int i;
    local array<string> FaceCodes;
    local array<string> FaceCodeParts;
    local array<MPFaceCodeData> faceCodeDataArray;
    local MPFaceCodeData faceCodeData;
    
    if (ServerFaceCodesString == "")
    {
        return EMPSerializationResult.EMPSerializationResult_Success;
    }
    ParseStringIntoArray(ServerFaceCodesString, FaceCodes, ";", TRUE);
    if (int(FaceCodes[0]) < 17)
    {
        return EMPSerializationResult.EMPSerializationResult_TooOld;
    }
    for (i = 1; i < FaceCodes.Length; ++i)
    {
        ParseStringIntoArray(FaceCodes[i], FaceCodeParts, ",", FALSE);
        if (FaceCodeParts.Length != 3)
        {
            return EMPSerializationResult.EMPSerializationResult_Failure;
        }
        faceCodeData.Id = Asc(FaceCodeParts[0]);
        faceCodeData.firstName = FaceCodeParts[1];
        faceCodeData.faceCode = FaceCodeParts[2];
        faceCodeDataArray.InsertItem(0, faceCodeData);
    }
    MPSaveManager.SetFaceCodesFromServer(faceCodeDataArray);
    return EMPSerializationResult.EMPSerializationResult_Success;
}
private final function EMPSerializationResult SetNewReinforcements(const out SFXSaveManagerMP MPSaveManager)
{
    local int NewReinforcementsCursor;
    local int Version;
    local int DevelopmentVersion;
    local int idx;
    local int Idx2;
    local array<string> NewReinforcementsParts;
    local array<string> CategoryData;
    local array<string> CurrCategoryData;
    local string CurrVariableName;
    local EReinforcementGUICategory eCurrCategory;
    
    if (ServerNewReinforcementsString == "")
    {
        MPSaveManager.AddNewReinforcement(12, MPSaveManager.NewlyAffordableStoreItemsPlayerVariableName);
        return EMPSerializationResult.EMPSerializationResult_Success;
    }
    ParseStringIntoArray(ServerNewReinforcementsString, NewReinforcementsParts, ";", FALSE);
    NewReinforcementsCursor = 0;
    Version = int(NewReinforcementsParts[NewReinforcementsCursor++]);
    if (Version < 14)
    {
        return EMPSerializationResult.EMPSerializationResult_TooOld;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_TooNew;
    }
    DevelopmentVersion = int(NewReinforcementsParts[NewReinforcementsCursor++]);
    if (DevelopmentVersion < DevelopmentVersionNumber)
    {
        return EMPSerializationResult.EMPSerializationResult_ForcedWipe;
    }
    ParseStringIntoArray(NewReinforcementsParts[NewReinforcementsCursor++], CategoryData, ",", TRUE);
    for (idx = 0; idx < CategoryData.Length; ++idx)
    {
        ParseStringIntoArray(CategoryData[idx], CurrCategoryData, " ", TRUE);
        if (CurrCategoryData.Length > 1)
        {
            eCurrCategory = byte(int(CurrCategoryData[0]));
            for (Idx2 = 1; Idx2 < CurrCategoryData.Length; ++Idx2)
            {
                CurrVariableName = Class'SFXGameConfig'.static.GetPurchasableItemClassName(int(CurrCategoryData[Idx2]));
                if (CurrVariableName != "")
                {
                    MPSaveManager.AddNewReinforcement(eCurrCategory, CurrVariableName);
                }
            }
        }
    }
    return EMPSerializationResult.EMPSerializationResult_Success;
}
private static final function bool SetPlayerVariables(const out string PlayerVariableString, out SFXSaveManagerMP MPSaveManager)
{
    local string AmountString;
    local int idx;
    local int nAmount;
    local int VariableID;
    local SFXGameConfig gameconfig;
    
    gameconfig = SFXGRI(Class'Engine'.static.GetCurrentWorldInfo().GRI).gameconfig;
    if (gameconfig == None)
    {
        return FALSE;
    }
    idx = 0;
    while (idx < Len(PlayerVariableString))
    {
        AmountString = Mid(PlayerVariableString, idx, 2);
        nAmount = HexDecodeNumber(AmountString);
        VariableID = idx / 2;
        MPSaveManager.SetPlayerVariableFromID(Name(string(VariableID)), nAmount);
        idx += 2;
    }
    return TRUE;
}
private static final function bool SetPlayerVariablesV18(const out string PlayerVariableString, out SFXSaveManagerMP MPSaveManager)
{
    local string AmountString;
    local string PlayerVariableName;
    local int idx;
    local int nAmount;
    local SFXGameConfig gameconfig;
    
    gameconfig = SFXGRI(Class'Engine'.static.GetCurrentWorldInfo().GRI).gameconfig;
    if (gameconfig == None)
    {
        return FALSE;
    }
    for (idx = 0; idx < Len(PlayerVariableString); ++idx)
    {
        AmountString = Mid(PlayerVariableString, idx, 1);
        nAmount = Asc(AmountString);
        nAmount -= 1;
        PlayerVariableName = Class'SFXGameConfig'.static.GetPurchasableItemClassName(idx);
        if (PlayerVariableName != "")
        {
            MPSaveManager.SetPlayerVariable(Name(PlayerVariableName), nAmount);
            if (MPSaveManager.m_bDebugPlayerVariables)
            {
            }
            continue;
        }
        if (MPSaveManager.m_bDebugPlayerVariables)
        {
        }
    }
    return TRUE;
}
private static final function bool SetPowers(const out string PowerString, out array<PowerRecord> Powers, int Version)
{
    local int PowerCursor;
    local array<string> PowerParts;
    local array<string> PowerInternalParts;
    local int PowerNum;
    local int PowerID;
    local int nExistingPowerIndex;
    local int EvolutionNum;
    local PowerRecord Power;
    
    ParseStringIntoArray(PowerString, PowerParts, ",", FALSE);
    Powers.Length = 0;
    for (PowerNum = 0; PowerNum < PowerParts.Length; ++PowerNum)
    {
        if (PowerParts[PowerNum] == "")
        {
            continue;
        }
        PowerCursor = 0;
        ParseStringIntoArray(PowerParts[PowerNum], PowerInternalParts, " ", FALSE);
        Power.PowerName = Name(PowerInternalParts[PowerCursor++]);
        nExistingPowerIndex = Powers.Find('PowerName', Power.PowerName);
        if (nExistingPowerIndex >= 0)
        {
            continue;
        }
        PowerID = int(PowerInternalParts[PowerCursor++]);
        Power.PowerClassName = Name(Class'SFXGameConfig'.static.GetPurchasableItemClassName(PowerID));
        Power.CurrentRank = float(PowerInternalParts[PowerCursor++]);
        for (EvolutionNum = 0; EvolutionNum < 6; ++EvolutionNum)
        {
            Power.EvolvedChoices[EvolutionNum] = int(PowerInternalParts[PowerCursor++]);
        }
        Power.WheelDisplayIndex = int(PowerInternalParts[PowerCursor++]);
        if (Version >= 16)
        {
            Power.bUsesTalentPoints = bool(PowerInternalParts[PowerCursor++]);
        }
        Powers.AddItem(Power);
    }
    return PowerNum > 0;
}
private static final function bool SetWeaponMods(const out string WeaponModString, out array<WeaponModRecord> WeaponMods)
{
    local array<string> WeaponModParts;
    local array<string> WeaponModData;
    local int idx;
    local int Idx2;
    local int nID;
    local WeaponModRecord WeaponModRec;
    local string WeaponClassName;
    local string WeaponModClassName;
    
    ParseStringIntoArray(WeaponModString, WeaponModParts, ",", FALSE);
    WeaponMods.Length = 0;
    for (idx = 0; idx < WeaponModParts.Length; ++idx)
    {
        ParseStringIntoArray(WeaponModParts[idx], WeaponModData, " ", FALSE);
        if (WeaponModData.Length > 0)
        {
            nID = int(WeaponModData[0]);
            WeaponClassName = Class'SFXGameConfig'.static.GetPurchasableItemClassName(nID);
            if (WeaponClassName == "")
            {
                continue;
            }
            WeaponModRec.WeaponClassName = Name(WeaponClassName);
            WeaponModRec.WeaponModClassNames.Length = 0;
            for (Idx2 = 1; Idx2 < WeaponModData.Length; ++Idx2)
            {
                nID = int(WeaponModData[Idx2]);
                WeaponModClassName = Class'SFXGameConfig'.static.GetPurchasableItemClassName(nID);
                if (WeaponModClassName == "")
                {
                    continue;
                }
                WeaponModRec.WeaponModClassNames.AddItem(Name(WeaponModClassName));
            }
            WeaponMods.AddItem(WeaponModRec);
        }
    }
    return TRUE;
}
private static final function bool SetWeapons(const out string WeaponString, out array<WeaponRecord> Weapons)
{
    local array<string> WeaponParts;
    local int WeaponNum;
    local int nID;
    local WeaponRecord WeaponRec;
    local string WeaponClassName;
    
    ParseStringIntoArray(WeaponString, WeaponParts, ",", FALSE);
    Weapons.Length = 0;
    for (WeaponNum = 0; WeaponNum < WeaponParts.Length; ++WeaponNum)
    {
        nID = int(WeaponParts[WeaponNum]);
        WeaponClassName = Class'SFXGameConfig'.static.GetPurchasableItemClassName(nID);
        if (WeaponClassName == "")
        {
            continue;
        }
        WeaponRec.WeaponClassName = Name(WeaponClassName);
        Weapons.AddItem(WeaponRec);
    }
    return TRUE;
}
private final function UpdateBaseServerValue()
{
    local string SettingString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(0, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerBaseString = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(0, BlankString);
        }
    }
}
private final function UpdateBaseValues(const out SFXSaveManagerMP MPSaveManager, bool ForceResaveBase)
{
    local string NewString;
    
    NewString = GetBase(MPSaveManager);
    if (!ForceResaveBase && NewString == ServerBaseString)
    {
        NewString = "";
    }
    CachedOnlinePlayerStorage.SetProfileSettingValue(0, NewString);
}
private final function UpdateCharacterServerValue(int nCharacterIndex)
{
    local string SettingString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(9 + nCharacterIndex, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerCharacterStrings[nCharacterIndex] = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(9 + nCharacterIndex, BlankString);
        }
    }
}
private final function UpdateCharacterValues(const out SFXSaveManagerMP MPSaveManager)
{
    local string NewString;
    local int idx;
    local array<SFXMPCharacterRecord> CharacterRecords;
    
    CharacterRecords = MPSaveManager.GetAllCharacterRecords();
    for (idx = 0; idx < CharacterRecords.Length; ++idx)
    {
        if (idx < 78)
        {
            NewString = GetCharacter(CharacterRecords[idx], MPSaveManager, idx);
            if (NewString == ServerCharacterStrings[idx])
            {
                NewString = "";
            }
            CachedOnlinePlayerStorage.SetProfileSettingValue(9 + idx, NewString);
            continue;
        }
        break;
    }
}
private final function UpdateClassServerValue(int nClassIndex)
{
    local string SettingString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(1 + nClassIndex, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerClassStrings[nClassIndex] = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(1 + nClassIndex, BlankString);
        }
    }
}
private final function UpdateClassValues(const out SFXSaveManagerMP MPSaveManager)
{
    local string NewString;
    local int idx;
    local array<SFXMPClassRecord> ClassRecords;
    
    ClassRecords = MPSaveManager.GetAllClassRecords();
    for (idx = 0; idx < ClassRecords.Length; ++idx)
    {
        if (idx < 8)
        {
            NewString = GetClass(ClassRecords[idx]);
            if (NewString == ServerClassStrings[idx])
            {
                NewString = "";
            }
            CachedOnlinePlayerStorage.SetProfileSettingValue(1 + idx, NewString);
            continue;
        }
        break;
    }
}
private final function UpdateFaceCodesServerValue()
{
    local string faceCodesString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(87, faceCodesString);
        if (Len(faceCodesString) > 0)
        {
            ServerFaceCodesString = faceCodesString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(87, BlankString);
        }
    }
}
private final function UpdateFaceCodeValues(const out SFXSaveManagerMP MPSaveManager)
{
    local string NewString;
    
    NewString = GetFaceCodes(MPSaveManager);
    if (NewString == ServerFaceCodesString)
    {
        NewString = "";
    }
    CachedOnlinePlayerStorage.SetProfileSettingValue(87, NewString);
}
public function UpdateFromSaveManager(const out SFXSaveManagerMP MPSaveManager, optional bool ForceResaveBase)
{
    UpdateBaseValues(MPSaveManager, ForceResaveBase);
    UpdateNewReinforcementsValues(MPSaveManager);
    UpdateClassValues(MPSaveManager);
    UpdateCharacterValues(MPSaveManager);
    UpdateFaceCodeValues(MPSaveManager);
}
private final function UpdateNewReinforcementsServerValue()
{
    local string SettingString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(88, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerNewReinforcementsString = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(88, BlankString);
        }
    }
}
private final function UpdateNewReinforcementsValues(const out SFXSaveManagerMP MPSaveManager)
{
    local string NewString;
    
    NewString = GetNewReinforcements(MPSaveManager);
    if (NewString == ServerNewReinforcementsString)
    {
        NewString = "";
    }
    CachedOnlinePlayerStorage.SetProfileSettingValue(88, NewString);
}
private final function UpdateServerValues()
{
    local int idx;
    
    UpdateBaseServerValue();
    UpdateNewReinforcementsServerValue();
    UpdateFaceCodesServerValue();
    for (idx = 0; idx < 8; ++idx)
    {
        UpdateClassServerValue(idx);
    }
    for (idx = 0; idx < 79; ++idx)
    {
        UpdateCharacterServerValue(idx);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DevelopmentVersionNumber = 4
}