Class SFSGivePowerInterceptorCommandMP extends SFSConsoleCommand within SFXPawn;

public function Execute(string Arguments)
{
    local SFXPowerCustomActionBase FourthPower;
    local SFXPowerCustomActionBase FifthPower;
    local bool hasFifthPower;
    local int EvolveChoice;
    local int nIndex;
    local BioPlayerController PC;
    local BioPlayerInput BPI;
    local SFXPawn_PlayerMP Player;
    
    Class'SFSCore'.static.log(Self.Name, "SFSGivePowerInterceptorCommandMP arguments: " $ Arguments, Outer);
    PC = BioPlayerController(Outer.Controller);
    BPI = BioPlayerInput(PC.PlayerInput);
    Player = SFXPawn_PlayerMP(Outer);
    if (PC == None || BPI == None || Player == None)
    {
        return;
    }
    FourthPower = Outer.PowerManager.Powers[10];
    FifthPower = Outer.PowerManager.Powers[11];
    if (FifthPower != None)
    {
        Class'SFSCore'.static.log(Self.Name, "Cleaning up previous bonus power " $ FourthPower, Outer);
        //Clean up the previously added power.
        Outer.PowerManager.RemovePower(FourthPower.Class);
        Player.SquadScreenPowerOrder.RemoveItem(FourthPower.Class);
        FourthPower = FifthPower;
    }
    Class'SFSCore'.static.log(Self.Name, "Bonus Power is: " $ FourthPower, Outer);
    if (FourthPower != None)
    {
        Player.PlayerClass.SquadScreenPowerOrder.InsertItem(3, FourthPower.Class);
        FourthPower.Rank = 6.0;
        FourthPower.OnPowerRankIncreased();
        FourthPower.EvolvePower(0);
        FourthPower.EvolvePower(2);
        FourthPower.EvolvePower(4);
        FourthPower.RecalculateAllPowerInfo();
    }
    SFXPawn_PlayerMP(Outer).ApplyWeaponEncumbrance();
    if (BPI.bUsingGamepad)
    {
        Class'SFSCore'.static.log(Self.Name, "Using a Gamepad", Outer);
        Class'SFSInputUtility'.static.MapXboxSpecial(BPI, Player);
    }
    else
    {
        Class'SFSCore'.static.log(Self.Name, "Using KB/M", Outer);
        Class'SFSInputUtility'.static.AutoMapPCSpecial(BioPlayerInput(PC.PlayerInput), SFXPawn_PlayerMP(Outer));
    }
    Super.Execute(Arguments);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    sCommand = "GivePower"
    Description = "This command does nothing by itself, please do not use it. It is a bit of a hack to intercept the vanilla GivePower command, so that you can add a 4th power to the kit!\n\tIt will ONLY work when adding ONE extra power."
}