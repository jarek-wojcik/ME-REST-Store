Class SFXArmorUseModule extends SFXModule_SavedUse
    editinlinenew;

var float LastUpdateTime;
var float UpdateFrequency;
var bool bStopCustomTicking;
var(SFXArmorUseModule) EArmorTreasurePiece ArmorPiece;

public event simulated function HandlePostBeginPlay()
{
    Super(SFXSimpleUseModule).HandlePostBeginPlay();
    if (HasBeenUsed())
    {
        DisableArmorUseModule();
        return;
    }
    DisabilityCheck(m_srGameName);
}
public function OnUsed(Actor User)
{
    local int idx;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    local BioPlayerController PC;
    local BioHintSystem HintSystem;
    local SFXGame Game;
    local BioRemoteLogger Logger;
    local SFXPawn_Player pPawn;
    
    Super.OnUsed(User);
    DisableArmorUseModule();
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    VarTable = WI.GetGlobalVariables();
    if (VarTable == None)
    {
        return;
    }
    PC = BioPlayerController(SFXPawn(User).Controller);
    if (PC == None)
    {
        return;
    }
    HintSystem = BioHintSystem(PC.HintSystem);
    if (HintSystem == None)
    {
        return;
    }
    Game = SFXGame(WI.Game);
    if (Game == None || Game.TREASURE == None)
    {
        return;
    }
    idx = Game.TREASURE.ArmorTreasure.Find('ArmorPiece', ArmorPiece);
    if (idx == -1)
    {
        return;
    }
    pPawn = SFXPawn_Player(User);
    if (pPawn != None)
    {
        pPawn.StartCustomAction(4);
    }
    if (Game.TREASURE.HasTreasure(Game.TREASURE.ArmorTreasure[idx].ArmorString) == FALSE)
    {
    }
    if (Game.AwardItem(Name(Game.TREASURE.ArmorTreasure[idx].ArmorString)) == FALSE)
    {
    }
    VarTable.SetBool(Game.TREASURE.ArmorTreasure[idx].ArmorPlotState, TRUE);
    HintSystem.AddNotification_ArmorTreasureUnlocked(string(Game.TREASURE.ArmorTreasure[idx].srDisplayName));
    Logger = Class'BioRemoteLogger'.static.GetLogger();
    if (Logger != None && ModuleOwner != None)
    {
        Logger.SendMapEvent(103, ModuleOwner.location, Game.TREASURE.ArmorTreasure[idx].ArmorString, "", "", "", 0, 0, 0, 0);
    }
}
public function Tick(float DeltaTime)
{
    local WorldInfo WI;
    
    Super(SFXModule).Tick(DeltaTime);
    if (bStopCustomTicking)
    {
        return;
    }
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        return;
    }
    if (WI.TimeSeconds - LastUpdateTime > UpdateFrequency)
    {
        LastUpdateTime = WI.TimeSeconds;
        DisabilityCheck();
    }
}
public function bool DisabilityCheck(optional out stringref GameName)
{
    local BioWorldInfo WI;
    local SFXGame Game;
    local int idx;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return FALSE;
    }
    Game = SFXGame(WI.Game);
    if (Game == None || Game.TREASURE == None)
    {
        return FALSE;
    }
    idx = Game.TREASURE.ArmorTreasure.Find('ArmorPiece', ArmorPiece);
    if (idx == -1)
    {
        DisableArmorUseModule();
        return TRUE;
    }
    if (WI.CheckConditional(Game.TREASURE.ArmorTreasure[idx].Conditional) == FALSE)
    {
        DisableArmorUseModule();
        return TRUE;
    }
    GameName = Game.TREASURE.ArmorTreasure[idx].srDisplayName;
    return FALSE;
}
public function DisableArmorUseModule()
{
    local SFXArmorNode ArmorNode;
    
    SetTargetable(FALSE);
    ArmorNode = SFXArmorNode(ModuleOwner);
    if (ArmorNode != None)
    {
        ArmorNode.DisableArmorNode();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    UpdateFrequency = 5.0
    m_fMaxSelectionRangeSqr = 640000.0
    m_TargetTipText = ETargetTipText.TargetTipText_PickUp
}