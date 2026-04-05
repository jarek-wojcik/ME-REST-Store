Class SFXGameInfoSP extends SFXGame
    config(Game);

public event simulated function PostBeginPlay()
{
    local Engine oEngine;
    local Class<SFXTreasureData> TreasureClass;
    local Object DynamicLoadedClassObject;
    
    Super.PostBeginPlay();
    DynamicLoadedClassObject = Class'SFXEngine'.static.GetSeekFreeObject(TreasureClassName, Class'Class');
    TreasureClass = Class<SFXTreasureData>(DynamicLoadedClassObject);
    TREASURE = new (Self) TreasureClass;
    PlayerSquad = Spawn(Class'BioPlayerSquad');
    oEngine = Class'Engine'.static.GetEngine();
    if (oEngine.GamePlayers.Length > 1)
    {
        oEngine.GamePlayers.Remove(1, oEngine.GamePlayers.Length - 1);
    }
}
public function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local SFXEngine Engine;
    local Name ATStart;
    local Actor ChkActor;
    local BioStartLocation ChkBioStartLocation;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None)
    {
        ATStart = Engine.m_DesiredStartPoint;
        if (ATStart != 'None')
        {
            foreach WorldInfo.AllActors(Class'Actor', ChkActor, )
            {
                if (ChkActor.Tag == ATStart)
                {
                    if (BioStartLocation(ChkActor) != None)
                    {
                        return Spawn(Class'DynamicAnchor', , ATStart, ChkActor.location, ChkActor.Rotation);
                    }
                }
            }
        }
    }
    foreach WorldInfo.AllActors(Class'BioStartLocation', ChkBioStartLocation, )
    {
        return Spawn(Class'DynamicAnchor', , ATStart, ChkBioStartLocation.location, ChkBioStartLocation.Rotation);
    }
    return Super(GameInfo).FindPlayerStart(Player, InTeam, IncomingName);
}
public function bool AwardCreditPercent(float fAmount, optional string Level = "", optional bool bShowNotifications = TRUE)
{
    local SFXEngine oEngine;
    local TD TreasureData;
    local bool bFoundData;
    local int CreditBudget;
    local SFXInventoryManager Inventory;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    Inventory = SFXInventoryManager(BioWorldInfo(WorldInfo).GetLocalPlayerController().Pawn.InvManager);
    if (oEngine == None || Inventory == None || fAmount < 0.0)
    {
        return FALSE;
    }
    Level = Level == "" ? oEngine.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundData = TREASURE.GetLevelData(TreasureData, Level);
    if (!bFoundData)
    {
        return FALSE;
    }
    CreditBudget = TreasureData.Credits;
    CreditBudget = CreditBudget > 0 ? CreditBudget : 1;
    fAmount = FClamp(fAmount, 0.0, 1.0);
    return AwardCredits(int(float(CreditBudget) * fAmount), Level, bShowNotifications);
}
public function bool AwardCredits(int Amount, optional string Level = "", optional bool bShowNotification = TRUE)
{
    local SFXEngine oEngine;
    local TD TreasureData;
    local bool bFoundData;
    local int CreditBudget;
    local int CreditsSoFar;
    local int idx;
    local SFXInventoryManager Inventory;
    local LevelTreasureSaveRecord NewTreasureRecord;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    Inventory = SFXInventoryManager(BioWorldInfo(WorldInfo).GetLocalPlayerController().Pawn.InvManager);
    if (oEngine == None || Inventory == None || Amount < 1)
    {
        return FALSE;
    }
    Level = Level == "" ? oEngine.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundData = TREASURE.GetLevelData(TreasureData, Level);
    if (!bFoundData)
    {
        return FALSE;
    }
    CreditBudget = TreasureData.Credits;
    CreditBudget = CreditBudget > 0 ? CreditBudget : 1;
    for (idx = 0; idx < oEngine.SavedTreasure.Length; idx++)
    {
        if (oEngine.SavedTreasure[idx].LevelName == Name(Level))
        {
            CreditsSoFar = oEngine.SavedTreasure[idx].nCredits;
            Amount = Clamp(Amount, 1, CreditBudget - CreditsSoFar);
            Amount = Amount > 0 ? Amount : 1;
            Inventory.AdjustResource(0, Amount, bShowNotification, TRUE);
            oEngine.SavedTreasure[idx].nCredits += Amount;
            return TRUE;
        }
    }
    Amount = Clamp(Amount, 1, CreditBudget);
    Amount = Amount > 0 ? Amount : 1;
    Inventory.AdjustResource(0, Amount, bShowNotification);
    NewTreasureRecord.LevelName = Name(Level);
    NewTreasureRecord.nCredits = Amount;
    NewTreasureRecord.nXP = 0;
    oEngine.SavedTreasure[oEngine.SavedTreasure.Length] = NewTreasureRecord;
    return TRUE;
}
public function bool AwardItem(Name ItemName, optional string Level = "")
{
    local SFXEngine oEngine;
    local TD TreasureData;
    local bool bFoundData;
    local LevelTreasureSaveRecord NewTreasureRecord;
    local int idx;
    local string S;
    local Name N;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return FALSE;
    }
    Level = Level == "" ? oEngine.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundData = TREASURE.GetLevelData(TreasureData, Level);
    if (!bFoundData)
    {
        return FALSE;
    }
    bFoundData = FALSE;
    foreach TreasureData.TREASURE(S, )
    {
        if (S == string(ItemName))
        {
            bFoundData = TRUE;
        }
    }
    if (!bFoundData)
    {
        return FALSE;
    }
    bFoundData = FALSE;
    for (idx = 0; idx < oEngine.SavedTreasure.Length; idx++)
    {
        if (oEngine.SavedTreasure[idx].LevelName == Name(Level))
        {
            foreach oEngine.SavedTreasure[idx].Items(N, )
            {
                if (ItemName == N)
                {
                    bFoundData = TRUE;
                }
            }
        }
    }
    if (bFoundData)
    {
        return FALSE;
    }
    bFoundData = FALSE;
    for (idx = 0; idx < oEngine.SavedTreasure.Length; idx++)
    {
        if (oEngine.SavedTreasure[idx].LevelName == Name(Level))
        {
            oEngine.SavedTreasure[idx].Items.AddItem(ItemName);
            bFoundData = TRUE;
        }
    }
    if (!bFoundData)
    {
        NewTreasureRecord.LevelName = Name(Level);
        NewTreasureRecord.Items.AddItem(ItemName);
        oEngine.SavedTreasure.AddItem(NewTreasureRecord);
    }
    return TRUE;
}
public function bool AwardXP(int Amount, optional string Level = "", optional bool bShowNotifications = TRUE)
{
    local SFXEngine oEngine;
    local TD TreasureData;
    local bool bFoundData;
    local int XPBudget;
    local int XPSoFar;
    local int idx;
    local BioPlayerController PC;
    local LevelTreasureSaveRecord NewTreasureRecord;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    PC = BioWorldInfo(WorldInfo).GetLocalPlayerController();
    if (oEngine == None || PC == None || Amount < 1)
    {
        return FALSE;
    }
    Level = Level == "" ? oEngine.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundData = TREASURE.GetLevelData(TreasureData, Level);
    if (!bFoundData)
    {
        return FALSE;
    }
    XPBudget = TreasureData.XP;
    for (idx = 0; idx < oEngine.SavedTreasure.Length; idx++)
    {
        if (oEngine.SavedTreasure[idx].LevelName == Name(Level))
        {
            XPSoFar = oEngine.SavedTreasure[idx].nXP;
            Amount = Clamp(Amount, 1, XPBudget - XPSoFar);
            Amount = Amount > 0 ? Amount : 1;
            PC.GrantXP(float(Amount), !bShowNotifications);
            oEngine.SavedTreasure[idx].nXP += Amount;
            return TRUE;
        }
    }
    Amount = Clamp(Amount, 1, XPBudget);
    Amount = Amount > 0 ? Amount : 1;
    PC.GrantXP(float(Amount), !bShowNotifications);
    NewTreasureRecord.LevelName = Name(Level);
    NewTreasureRecord.nCredits = 0;
    NewTreasureRecord.nXP = Amount;
    oEngine.SavedTreasure[oEngine.SavedTreasure.Length] = NewTreasureRecord;
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GameReplicationInfoClass = Class'SFXGRISP'
}