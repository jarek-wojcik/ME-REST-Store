Class SFXWeaponUseModule extends SFXModule_SavedUse
    native
    editinlinenew;

var(SFXWeaponUseModule) Class<SFXWeapon> WeaponClass;
var editinline export DynamicLightEnvironmentComponent LightEnvironment;
var editinline export SkeletalMeshComponent PickupMesh;
var GFxMovieInfo WeaponSelectionMovieInfo;
var SFXGUI_WeaponSelection GUI_WeaponSelection;
var int UpgradeLevels_Normal;
var int UpgradeLevels_NewGamePlus;
var int NewGamePlusID;
var float LastUpdateTime;
var float UpdateFrequency;
var WwiseEvent PickupSound;
var bool bStopCustomTicking;

public event simulated function HandlePostBeginPlay()
{
    Super(SFXSimpleUseModule).HandlePostBeginPlay();
    if (HasBeenUsed())
    {
        DisableWeaponUseModule();
        return;
    }
    WeaponUseModuleInit();
}
public function OnUsed(Actor User)
{
    Super.OnUsed(User);
    WeaponUseModuleOnUsed(User);
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
    local int WeaponLevel;
    local BioWorldInfo WI;
    
    if (Class'SFXWeapon'.static.IsWeaponAlreadyAwarded(WeaponClass) == TRUE && ClassIsChildOf(WeaponClass, Class'SFXHeavyWeapon') == FALSE)
    {
        DisableWeaponUseModule();
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
            DisableWeaponUseModule();
            return TRUE;
        }
    }
    else if (float(WeaponLevel) >= Class'SFXWeapon'.default.MaxLevel)
    {
        DisableWeaponUseModule();
        return TRUE;
    }
    return FALSE;
}
public function DisableWeaponUseModule()
{
    local SFXWeaponNode WeaponNode;
    
    bStopCustomTicking = TRUE;
    SetTargetable(FALSE);
    WeaponNode = SFXWeaponNode(ModuleOwner);
    if (WeaponNode != None)
    {
        WeaponNode.DisableWeaponNode();
    }
}
public final function StartWeaponSelection()
{
    local SFXGUIInteraction GUI_Handler;
    local BioPlayerController PC;
    local WorldInfo WI;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        return;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    GUI_Handler = Class'SFXGUIInteraction'.static.GetInstance();
    if (GUI_Handler == None)
    {
        return;
    }
    GUI_WeaponSelection = GUI_Handler.CastOpenMovie(Class'SFXGUI_WeaponSelection', PC, GUI_Handler.MovieTag_WeaponSelect, TRUE, FALSE, TRUE);
}
public final function WeaponAwardUIAction(BioSFHandler_MessageBox oUI, int nSelection)
{
    local WorldInfo WI;
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
            WI = Class'WorldInfo'.static.GetWorldInfo();
            if (WI == None)
            {
                return;
            }
            PC = WI.GetALocalPlayerController();
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
}
public function WeaponUseModuleInit()
{
    if (DisabilityCheck() == FALSE)
    {
        m_GameName = WeaponClass.static.GetPrettyName();
    }
}
public function WeaponUseModuleOnUsed(Actor User)
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
    
    DisableWeaponUseModule();
    Player = SFXPawn_Player(User);
    if (Player == None)
    {
        return;
    }
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
        Weapon = ModuleOwner.Spawn(WeaponClass);
        if (Weapon == None)
        {
            return;
        }
        Player.PlaySound(PickupSound, TRUE);
        Player.GiveWeaponToPlayer(Weapon, FALSE);
        Weapon.GiveWeaponCodex();
        return;
    }
    Logger = Class'BioRemoteLogger'.static.GetLogger();
    if (Logger != None && ModuleOwner != None)
    {
        Logger.SendMapEvent(103, ModuleOwner.location, string(WeaponClass.Name), "", "", "", 0, 0, 0, 0);
    }
    Class'BioSFHandler_MessageBox'.static.ShowWeaponPickupUIForWeapon(WeaponClass, WeaponAwardUIAction);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponSelectionMovieInfo = GFxMovieInfo'GUI_SF_WeaponSelect.WeaponSelect'
    UpgradeLevels_Normal = 1
    UpgradeLevels_NewGamePlus = 3
    NewGamePlusID = 1690
    UpdateFrequency = 5.0
    PickupSound = WwiseEvent'Wwise_Generic_GUI.Play_HeavyWeaponEquip'
    m_fMaxSelectionRangeSqr = 640000.0
    m_TargetTipText = ETargetTipText.TargetTipText_PickUp
}