Class SFXWeaponUseModule_BonusWeapon extends SFXWeaponUseModule
    editinlinenew;

public function bool DisabilityCheck()
{
    local SFXEngine Engine;
    local int WeaponLevel;
    local BioWorldInfo WI;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (Engine == None || WI == None)
    {
        return FALSE;
    }
    WeaponLevel = Engine.GetPlayerVariable(Name(PathName(WeaponClass)));
    if (float(WeaponLevel) >= Class'SFXWeapon'.default.MaxLevel)
    {
        DisableWeaponUseModule();
        return TRUE;
    }
    return FALSE;
}
public function WeaponUseModuleOnUsed(Actor User)
{
    local SFXPawn_Player Player;
    local BioPlayerController MyPC;
    local BioRemoteLogger Logger;
    local bool bUpgradeSuccess;
    local BioHintSystem HintSystem;
    
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
    HintSystem = BioHintSystem(MyPC.HintSystem);
    if (HintSystem == None)
    {
        return;
    }
    bUpgradeSuccess = WeaponClass.static.Upgrade(Player, WeaponClass);
    if (!bUpgradeSuccess)
    {
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
    bStopCustomTicking = TRUE
}