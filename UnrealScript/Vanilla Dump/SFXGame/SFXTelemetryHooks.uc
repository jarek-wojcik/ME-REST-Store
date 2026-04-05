Class SFXTelemetryHooks extends SFXTelemetry
    transient
    config(Game);

public static final function SendServerMPSessionEnd(int CreditsGained, int XPGained, int LastWave, bool Success, int NumPlayers, int numExtracted, int NumSupplyDropsRecd)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "crdg", , CreditsGained);
    AddAttributeToArray(Attributes, 2, "scrg", , XPGained);
    AddAttributeToArray(Attributes, 2, "wave", , LastWave);
    AddAttributeToArray(Attributes, 4, "succ", , , , Success);
    AddAttributeToArray(Attributes, 2, "nump", , NumPlayers);
    AddAttributeToArray(Attributes, 2, "extp", , numExtracted);
    AddAttributeToArray(Attributes, 2, "sply", , NumSupplyDropsRecd);
    SendArray('TelemetryHook_MPHOST_MatchResults', Attributes);
}
public static final function SendServerMPSessionStart(int NumPlayers, bool bRandomMap, bool bRandomEnemy, bool bPrivateGame)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "nump", , NumPlayers);
    AddAttributeToArray(Attributes, 4, "rmap", , , , bRandomMap);
    AddAttributeToArray(Attributes, 4, "renm", , , , bRandomEnemy);
    AddAttributeToArray(Attributes, 4, "prvt", , , , bPrivateGame);
    SendArray('TelemetryHook_MPHOST_MatchSettings', Attributes);
}
public static final function SendEndGameOptions(int FinalScore, int MilitaryScore, int ExternalScore, int SecurityLevel)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "fins", , FinalScore);
    AddAttributeToArray(Attributes, 2, "mils", , MilitaryScore);
    AddAttributeToArray(Attributes, 2, "exts", , ExternalScore);
    AddAttributeToArray(Attributes, 2, "secl", , SecurityLevel);
    SendArray('TelemetryHook_GAW_EndGameOptions', Attributes);
}
public static final function SendIncrementMPAsset(int AssetID, int IncValue)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "asst", , AssetID);
    AddAttributeToArray(Attributes, 2, "incv", , IncValue);
    SendArray('TelemetryHook_GAW_IncrementAsset', Attributes);
}
public static final function SendLeaderboardClosed(float Duration)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "dura", , int(Duration));
    SendArray('TelemetryHook_LeaderboardClosed', Attributes);
}
public static final function SendLeaderboardOpened()
{
    SendVoid('TelemetryHook_LeaderboardOpened');
}
public static final function SendMPCredits(int Delta, int NewBalance, int SessionEarned, int SessionSpent, string Transaction)
{
    local array<TelemetryAttribute> Attributes;
    
    if (Delta == 0)
    {
        return;
    }
    AddAttributeToArray(Attributes, 2, "cchg", , Delta);
    AddAttributeToArray(Attributes, 2, "cred", , NewBalance);
    AddAttributeToArray(Attributes, 2, "sece", , SessionEarned);
    AddAttributeToArray(Attributes, 2, "secr", , SessionSpent);
    AddAttributeToArray(Attributes, 1, "tran", Transaction);
    SendArray('TelemetryHook_MP_Credits', Attributes);
}
public static final function SendMPLevelUp(int PrevLevel, int newLevel)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "levl", , newLevel);
    AddAttributeToArray(Attributes, 2, "delt", , newLevel - PrevLevel);
    SendArray('TelemetryHook_MP_LevelUp', Attributes);
}
public static final function SendNewGameData(int NewGameType, bool bFemale, string firstName, bool bCustomShepard, string faceCode, int Origin, int Notoriety, Name BonusTalentClass, Class<Object> CharacterClass, Guid CharacterGUID, bool HasME1PlotData, bool HasME2PlotData, int PlotChoice)
{
    local array<TelemetryAttribute> aTelAttribs;
    local string sTelAttVal;
    local string EncodedGUID;
    local string BonusTalentAsString;
    
    aTelAttribs.Add(13);
    sTelAttVal = "impt";
    aTelAttribs[0].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[0].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[0].nData = NewGameType;
    sTelAttVal = "gend";
    aTelAttribs[1].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[1].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[1].sData = bFemale ? "F" : "M";
    sTelAttVal = "char";
    aTelAttribs[2].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[2].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[2].sData = firstName;
    sTelAttVal = "mcsh";
    aTelAttribs[3].Type = ETelemetryAttributeType.AttributeType_Bool;
    aTelAttribs[3].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[3].bData = bCustomShepard;
    sTelAttVal = "shfc";
    aTelAttribs[4].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[4].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[4].sData = faceCode;
    sTelAttVal = "pers";
    aTelAttribs[5].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[5].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[5].nData = Origin;
    sTelAttVal = "psyc";
    aTelAttribs[6].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[6].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[6].nData = Notoriety;
    sTelAttVal = "tlnt";
    aTelAttribs[7].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[7].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    BonusTalentAsString = string(BonusTalentClass);
    aTelAttribs[7].sData = Class'SFXTelemetry'.static.GenerateUniqueClassIdFromString(BonusTalentAsString);
    sTelAttVal = "clas";
    aTelAttribs[8].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[8].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[8].sData = Class'SFXTelemetry'.static.GenerateUniqueClassId(CharacterClass);
    Class'SFXTelemetryGameSession'.static.Encode64_GUID(CharacterGUID, EncodedGUID);
    sTelAttVal = "chid";
    aTelAttribs[9].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[9].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[9].sData = EncodedGUID;
    sTelAttVal = "fme1";
    aTelAttribs[10].Type = ETelemetryAttributeType.AttributeType_Bool;
    aTelAttribs[10].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[10].bData = HasME1PlotData;
    sTelAttVal = "fme2";
    aTelAttribs[11].Type = ETelemetryAttributeType.AttributeType_Bool;
    aTelAttribs[11].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[11].bData = HasME2PlotData;
    sTelAttVal = "plch";
    aTelAttribs[12].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[12].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[12].nData = PlotChoice;
    Class'SFXTelemetry'.static.SendArray('TelemetryHook_NewGame', aTelAttribs);
}
public static final function SendPlayersMuted()
{
    local SFXOnlineSubsystem OnlineSub;
    local SFXOnlineComponentVoiceInterface VoiceInterface;
    local BioWorldInfo WorldInfo;
    local BioPlayerController PC;
    local LocalPlayer LP;
    local SFXGRI GRI;
    local PlayerReplicationInfo PRI;
    local string UniqueId;
    local array<TelemetryAttribute> Attributes;
    
    OnlineSub = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        VoiceInterface = OnlineSub.GetComponentVoiceInterface();
        WorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
        if (VoiceInterface != None && WorldInfo != None)
        {
            PC = WorldInfo.GetLocalPlayerController();
            GRI = SFXGRI(WorldInfo.GRI);
            if (PC != None && GRI != None)
            {
                LP = LocalPlayer(PC.Player);
                if (LP != None)
                {
                    foreach GRI.PRIArray(PRI, )
                    {
                        if (PRI != None && PRI.PlayerID != 0 && !PRI.IsLocalPlayerPRI())
                        {
                            if (VoiceInterface.IsRemoteTalkerMuted(byte(LP.ControllerId), PRI.UniqueId))
                            {
                                UniqueId = Class'OnlineSubsystem'.static.UniqueNetIdToString(PRI.UniqueId);
                                Attributes.Length = 0;
                                AddAttributeToArray(Attributes, 1, "plyr", UniqueId);
                                SendArray('TelemetryHook_MP_Mute', Attributes);
                            }
                        }
                    }
                }
            }
        }
    }
}
public static final function SendReinforcementCardGranted(const string sPackName, const string sPoolName, int nDropType, string sCardID, int nVersionIdx, int nIncrementBonus, int nCategory)
{
    local array<TelemetryAttribute> Attributes;
    
    sCardID = GenerateUniqueClassIdFromString(sCardID);
    AddAttributeToArray(Attributes, 1, "pack", sPackName);
    AddAttributeToArray(Attributes, 1, "pool", sPoolName);
    AddAttributeToArray(Attributes, 2, "dtyp", , nDropType);
    AddAttributeToArray(Attributes, 1, "card", sCardID);
    AddAttributeToArray(Attributes, 2, "cavs", , nVersionIdx);
    AddAttributeToArray(Attributes, 2, "caib", , nIncrementBonus);
    AddAttributeToArray(Attributes, 2, "caca", , nCategory);
    SendArray('TelemetryHook_RP_CardDrop', Attributes);
}
public static final function SendUnlockGAWAsset(int AssetID, EGAWAssetType AssetType, EGAWAssetSubType SubType, int CurrentStrength)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "asst", , AssetID);
    AddAttributeToArray(Attributes, 2, "type", , int(AssetType));
    AddAttributeToArray(Attributes, 2, "sbtp", , int(SubType));
    AddAttributeToArray(Attributes, 2, "stre", , CurrentStrength);
    SendArray('TelemetryHook_GAW_UnlockAsset', Attributes);
}
public static final function SendUpdateSecurityRatings(int ZoneID, float Increase, float GlobalIncrease)
{
    local array<TelemetryAttribute> Attributes;
    
    AddAttributeToArray(Attributes, 2, "zone", , ZoneID);
    AddAttributeToArray(Attributes, 3, "zinc", , , Increase);
    AddAttributeToArray(Attributes, 3, "ginc", , , GlobalIncrease);
    SendArray('TelemetryHook_GAW_ZoneIncrease', Attributes);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}