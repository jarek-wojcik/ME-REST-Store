Class SFXWeaponFactory extends SFXPickupFactory
    native
    placeable;

var(SFXWeaponFactory) Class<SFXWeapon> WeaponClass;
var clearcrosslevel SFXWeapon LastWeaponPickedUp;
var(SFXWeaponFactory) float RespawnTime;
var(SFXWeaponFactory) int AmmoInClip;
var(SFXWeaponFactory) int ReserveAmmo;
var GFxMovieInfo WeaponSelectionMovieInfo;
var SFXGUI_WeaponSelection GUI_WeaponSelection;
var int UpgradeLevels_Normal;
var int UpgradeLevels_NewGamePlus;
var int NewGamePlusID;
var float LastUpdateTime;
var float UpdateFrequency;
var WwiseEvent PickupSound;
var(SFXWeaponFactory) bool ForceRespawn;
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
public function bool DelayRespawn()
{
    local bool bDelay;
    
    bDelay = FALSE;
    if (LastWeaponPickedUp != None)
    {
        bDelay = SFXHeavyWeapon(LastWeaponPickedUp) != None && !LastWeaponPickedUp.OutOfAmmo();
    }
    return bDelay;
}
public function float GetRespawnTime()
{
    if (RespawnTime == 0.0)
    {
        return InventoryType.default.RespawnTime;
    }
    else
    {
        return RespawnTime;
    }
}
public simulated function InitializePickup()
{
    if (DisabilityCheck() == FALSE)
    {
        InventoryType = WeaponClass;
        GetModule(Class'SFXSimpleUseModule').m_GameName = WeaponClass.static.GetPrettyName();
        GetModule(Class'SFXSimpleUseModule').m_TargetTipText = Class'SFXDroppedPickup'.default.EquipWeaponToolTip;
        GetModule(Class'SFXSimpleUseModule').m_bTargetable = TRUE;
    }
    Super(PickupFactory).InitializePickup();
}
public function bool DisabilityCheck()
{
    local SFXEngine Engine;
    local int WeaponLevel;
    local BioWorldInfo WI;
    
    if (Class'SFXWeapon'.static.IsWeaponAlreadyAwarded(WeaponClass) == TRUE && ClassIsChildOf(WeaponClass, Class'SFXHeavyWeapon') == FALSE)
    {
        HideDrop();
        return TRUE;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (Engine == None || WI == None)
    {
        return FALSE;
    }
    WeaponLevel = Engine.GetPlayerVariable(Name(PathName(WeaponClass)));
    if (WI.CheckConditional(NewGamePlusID) == FALSE)
    {
        if (WeaponLevel > 0)
        {
            HideDrop();
            return TRUE;
        }
    }
    else if (float(WeaponLevel) >= Class'SFXWeapon'.default.MaxLevel)
    {
        HideDrop();
        return TRUE;
    }
    return FALSE;
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
public final function StartWeaponSelection()
{
    local SFXGUIInteraction GUI_Handler;
    local BioPlayerController PC;
    
    PC = BioPlayerController(WorldInfo.GetALocalPlayerController());
    GUI_Handler = Class'SFXGUIInteraction'.static.GetInstance();
    GUI_WeaponSelection = GUI_Handler.CastOpenMovie(Class'SFXGUI_WeaponSelection', PC, GUI_Handler.MovieTag_WeaponSelect, TRUE, FALSE, TRUE);
}
public function Used(Actor User)
{
    local SFXPawn_Player Player;
    local BioPlayerController MyPC;
    local SFXWeapon Weapon;
    local BioRemoteLogger Logger;
    local SFXEngine MyEngine;
    local bool bIsHeavyWeapon;
    local bool bNewGamePlus;
    local bool bUpgradeSuccess;
    local SFXInventoryManager InvManager;
    local BioHintSystem HintSystem;
    local SFXTreasureData TREASURE;
    local SFXGame Game;
    local BioWorldInfo WI;
    local int idx;
    
    Super.Used(User);
    Player = SFXPawn_Player(User);
    if (Player == None)
    {
        return;
    }
    PickedUpBy(Player);
    GotoState('Disabled', , , );
    MyPC = BioPlayerController(Player.Controller);
    if (MyPC == None)
    {
        return;
    }
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(Player.InvManager);
    if (InvManager == None)
    {
        return;
    }
    HintSystem = BioHintSystem(MyPC.HintSystem);
    if (HintSystem == None)
    {
        return;
    }
    WI = BioWorldInfo(Player.WorldInfo);
    if (WI == None)
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
    bIsHeavyWeapon = ClassIsChildOf(WeaponClass, Class'SFXHeavyWeapon');
    if (!bIsHeavyWeapon)
    {
        if (TREASURE.HasTreasure(PathName(WeaponClass)) == FALSE)
        {
        }
        if (!Game.AwardItem(Name(PathName(WeaponClass))))
        {
        }
        bNewGamePlus = WI.CheckConditional(NewGamePlusID);
        if (bNewGamePlus)
        {
            bUpgradeSuccess = TRUE;
            for (idx = 0; idx < UpgradeLevels_NewGamePlus; idx++)
            {
                bUpgradeSuccess = bUpgradeSuccess && WeaponClass.static.Upgrade(Player, WeaponClass);
            }
        }
        else
        {
            bUpgradeSuccess = WeaponClass.static.Upgrade(Player, WeaponClass);
        }
        if (!bUpgradeSuccess)
        {
        }
    }
    else
    {
        Weapon = Spawn(WeaponClass);
        if (Weapon == None)
        {
            return;
        }
        Player.PlaySound(PickupSound, TRUE);
        Player.GiveWeaponToPlayer(Weapon, FALSE);
        LastWeaponPickedUp = Weapon;
        Weapon.GiveWeaponCodex();
        return;
    }
    Logger = Class'BioRemoteLogger'.static.GetLogger();
    if (Logger != None)
    {
        Logger.SendMapEvent(103, location, string(WeaponClass.Name), "", "", "", 0, 0, 0, 0);
    }
    if (bIsHeavyWeapon)
    {
        return;
    }
    if (PathName(WeaponClass) == "SFXGameContent.SFXWeapon_AssaultRifle_Avenger")
    {
        Weapon = Spawn(WeaponClass);
        if (Weapon == None)
        {
            return;
        }
        Player.GiveWeaponToPlayer(Weapon, FALSE);
        LastWeaponPickedUp = Weapon;
        return;
    }
    Class'SFXGUIInteraction'.static.GetInstance().QueueWeaponBox('WeaponPickupUI', 4, string(WeaponClass.Name), WeaponPickupUIAction);
}
public final function WeaponPickupUIAction(BioSFHandler_MessageBox oUI, int nSelection)
{
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    
    switch (nSelection)
    {
        case 0:
            break;
        case 1:
            StartWeaponSelection();
            break;
        case 2:
            if (WorldInfo == None)
            {
                return;
            }
            PC = WorldInfo.GetALocalPlayerController();
            if (PC == None)
            {
                return;
            }
            pPawn = SFXPawn_Player(PC.Pawn);
            if (pPawn == None)
            {
                return;
            }
            pPawn.EquipWeaponToPlayerAndSquad(WeaponClass);
            break;
        default:
    }
    HideDrop();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=PickupFactoryLightEnvironment
    End Template
    Begin Template Class=SFXModule_SavedUse Name=SavedSelMod1
        __OnUsed__Delegate = class'SFXWeaponFactory'.Used
    End Template
    AmmoInClip = -1
    ReserveAmmo = -1
    WeaponSelectionMovieInfo = GFxMovieInfo'GUI_SF_WeaponSelect.WeaponSelect'
    UpgradeLevels_Normal = 1
    UpgradeLevels_NewGamePlus = 3
    NewGamePlusID = 1690
    UpdateFrequency = 5.0
    PickupSound = WwiseEvent'Wwise_Generic_GUI.Play_HeavyWeaponEquip'
    LightEnvironment = PickupFactoryLightEnvironment
    Components = (None, None, None, None, PickupFactoryLightEnvironment)
    Modules = (SavedSelMod1)
}