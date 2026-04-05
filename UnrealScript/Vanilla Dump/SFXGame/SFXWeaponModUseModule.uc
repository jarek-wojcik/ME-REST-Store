Class SFXWeaponModUseModule extends SFXModule_SavedUse
    editinlinenew;

var(SFXWeaponModUseModule) Class<SFXWeaponMod> WeaponModClass;
var float LastUpdateTime;
var float UpdateFrequency;
var bool bStopCustomTicking;

public event simulated function HandlePostBeginPlay()
{
    Super(SFXSimpleUseModule).HandlePostBeginPlay();
    if (HasBeenUsed())
    {
        DisableWeaponModUseModule();
        return;
    }
    if (DisabilityCheck() == FALSE)
    {
        m_GameName = WeaponModClass.static.GetModName(0);
    }
}
public function OnUsed(Actor User)
{
    local SFXPawn_Player Player;
    local SFXTreasureData TREASURE;
    local BioRemoteLogger Logger;
    local WorldInfo WI;
    local BioPlayerController PC;
    local SFXGame Game;
    local BioHintSystem HintSystem;
    local SFXPawn_Player pPawn;
    
    Super.OnUsed(User);
    DisableWeaponModUseModule();
    Player = SFXPawn_Player(User);
    if (Player == None)
    {
        return;
    }
    WI = Player.WorldInfo;
    if (WI == None)
    {
        return;
    }
    PC = BioPlayerController(Player.Controller);
    if (PC == None)
    {
        return;
    }
    Game = SFXGame(WI.Game);
    if (Game == None)
    {
        return;
    }
    TREASURE = Game.TREASURE;
    if (TREASURE == None)
    {
        return;
    }
    HintSystem = BioHintSystem(PC.HintSystem);
    if (HintSystem == None)
    {
        return;
    }
    pPawn = SFXPawn_Player(User);
    if (pPawn != None)
    {
        pPawn.StartCustomAction(4);
    }
    if (TREASURE.HasTreasure(PathName(WeaponModClass)) == FALSE)
    {
        return;
    }
    if (!Game.AwardItem(Name(PathName(WeaponModClass))))
    {
        return;
    }
    if (!WeaponModClass.static.Upgrade(Player))
    {
        return;
    }
    Logger = Class'BioRemoteLogger'.static.GetLogger();
    if (Logger != None && ModuleOwner != None)
    {
        Logger.SendMapEvent(103, ModuleOwner.location, string(WeaponModClass.Name), "", "", "", 0, 0, 0, 0);
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
public function bool DisabilityCheck()
{
    local SFXEngine Engine;
    local int ModLevel;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return FALSE;
    }
    ModLevel = Engine.GetPlayerVariable(Name(PathName(WeaponModClass)));
    if (ModLevel >= Class'SFXWeaponMod'.default.MAX_RANK)
    {
        DisableWeaponModUseModule();
        return TRUE;
    }
    return FALSE;
}
public function DisableWeaponModUseModule()
{
    local SFXWeaponModNode WeaponModNode;
    
    SetTargetable(FALSE);
    WeaponModNode = SFXWeaponModNode(ModuleOwner);
    if (WeaponModNode != None)
    {
        WeaponModNode.DisableWeaponModNode();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    UpdateFrequency = 5.0
    m_fMaxSelectionRangeSqr = 640000.0
}