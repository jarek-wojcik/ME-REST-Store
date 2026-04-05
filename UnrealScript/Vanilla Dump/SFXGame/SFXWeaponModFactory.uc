Class SFXWeaponModFactory extends SFXRpgPickupFactory
    native
    placeable;

var(SFXWeaponModFactory) Class<SFXWeaponMod> WeaponModClass;
var float LastUpdateTime;
var float UpdateFrequency;
var bool bStopCustomTicking;

public function Tick(float DeltaTime)
{
    local WorldInfo WI;
    
    Super(Actor).Tick(DeltaTime);
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
public simulated function InitializePickup()
{
    Super.InitializePickup();
    DisabilityCheck();
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
        HideDrop();
        return TRUE;
    }
    return FALSE;
}
public simulated function PrimitiveComponent GetPickupMesh()
{
    local PrimitiveComponent PMesh;
    
    if (WeaponModClass != None && WeaponModClass.default.PickupFactoryMesh != None)
    {
        PMesh = new (Self) WeaponModClass.default.PickupFactoryMesh.Class (WeaponModClass.default.PickupFactoryMesh);
        return PMesh;
    }
    return None;
}
public simulated function bool HasPickup()
{
    return WeaponModClass != None;
}
public final function HideDrop()
{
    local SFXModule_SavedUse UseModule;
    
    UseModule = GetModule(Class'SFXModule_SavedUse');
    if (UseModule != None)
    {
        UseModule.m_bTargetable = FALSE;
    }
    SetPickupHidden();
}
public simulated function SetTooltips()
{
    if (!HasPickup())
    {
        return;
    }
    GetModule(Class'SFXSimpleUseModule').m_GameName = WeaponModClass.static.GetModName(0);
    GetModule(Class'SFXSimpleUseModule').m_TargetTipText = WeaponModClass.default.ToolTipText;
}
public function Used(Actor User)
{
    local SFXPawn_Player Player;
    local SFXTreasureData TREASURE;
    local BioRemoteLogger Logger;
    local BioPlayerController PC;
    local SFXGame Game;
    local BioHintSystem HintSystem;
    
    Super(SFXPickupFactory).Used(User);
    Player = SFXPawn_Player(User);
    if (Player == None)
    {
        return;
    }
    Player.StartCustomAction(4);
    GotoState('Disabled', , , );
    PickedUpBy(Player);
    if (WorldInfo == None)
    {
        return;
    }
    PC = BioPlayerController(Player.Controller);
    if (PC == None)
    {
        return;
    }
    Game = SFXGame(WorldInfo.Game);
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
    if (Logger != None)
    {
        Logger.SendMapEvent(103, location, string(WeaponModClass.Name), "", "", "", 0, 0, 0, 0);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=PickupFactoryLightEnvironment
    End Template
    Begin Template Class=SFXModule_SavedUse Name=SavedSelMod1
        __OnUsed__Delegate = class'SFXWeaponModFactory'.Used
        m_TargetOffset = {X = 0.0, Y = 0.0, Z = 20.0}
    End Template
    UpdateFrequency = 5.0
    LightEnvironment = PickupFactoryLightEnvironment
    Components = (None, None, None, None, PickupFactoryLightEnvironment)
    Modules = (SavedSelMod1)
}