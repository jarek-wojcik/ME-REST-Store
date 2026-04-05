Class SFSPowerManager extends SFSManager within SFXPawn;

var SFSPortalAsyncLoader asyncLoader;
var BioPlayerController PC;
var BioPlayerInput BPI;
var int PendingLoadCount;
var bool bAppliedBorrowedPower;

public event simulated function HandlePostAdd()
{
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    PC = BioPlayerController(Outer.Controller);
    if (PC == None)
    {
        log(Self.Name, "HandlePostAdd: No PlayerController found", Outer);
        return;
    }
    BPI = BioPlayerInput(PC.PlayerInput);
    if (BPI == None)
    {
        log(Self.Name, "HandlePostAdd: No BioPlayerInput found", Outer);
    }
}
public function HandleEvent(SFSEvent E)
{
}
public function LoadPowers(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local int i;
    
    PendingLoadCount = 0;
    bAppliedBorrowedPower = FALSE;
    if (asyncLoader == None)
    {
        log(Self.Name, "LoadPowers: asyncLoader is None", Outer);
        return;
    }
    log(Self.Name, "LoadPowers: " $ Character.PowerCount $ " regular power(s)", Outer);
    for (i = 0; i < Character.PowerCount; i++)
    {
        if (Character.Powers[i].PowerID == "")
        {
            continue;
        }
        PendingLoadCount++;
        asyncLoader.LoadPowerClassAsync(Character.Powers[i].PowerID, Character.Powers[i], i, FALSE, OnPowerLoaded);
        log(Self.Name, "Queued power: " $ Character.Powers[i].PowerID $ " at slot " $ i, Outer);
    }
    if (Character.bHasBorrowedPower && Character.BorrowedPower.PowerID != "")
    {
        PendingLoadCount++;
        asyncLoader.LoadPowerClassAsync(Character.BorrowedPower.PowerID, Character.BorrowedPower, 3, TRUE, OnBorrowedPowerLoaded);
        log(Self.Name, "Queued borrowed power: " $ Character.BorrowedPower.PowerID, Outer);
    }
}
function OnPowerLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP Player;
    local Class<SFXPowerCustomActionBase> ExistingClass;
    local SFXPowerCustomActionBase Power;
    
    if (load.LoadedPowerClass == None)
    {
        log(Self.Name, "OnPowerLoaded: Failed to load: " $ load.AssetToLoad, Outer);
        DecrementAndCheckDone();
        return;
    }
    Player = SFXPawn_PlayerMP(Owner);
    if (Player == None)
    {
        log(Self.Name, "OnPowerLoaded: Not a PlayerMP pawn", Outer);
        DecrementAndCheckDone();
        return;
    }
    if (load.SlotIndex >= Player.PlayerClass.SquadScreenPowerOrder.Length)
    {
        log(Self.Name, "OnPowerLoaded: Slot " $ load.SlotIndex $ " out of bounds (len=" $ Player.PlayerClass.SquadScreenPowerOrder.Length $ ")", Outer);
        DecrementAndCheckDone();
        return;
    }
    ExistingClass = Player.PlayerClass.SquadScreenPowerOrder[load.SlotIndex];
    log(Self.Name, "OnPowerLoaded: Slot " $ load.SlotIndex $ " existing=" $ ExistingClass $ " new=" $ load.LoadedPowerClass, Outer);
    if (ExistingClass != load.LoadedPowerClass)
    {
        Power = Owner.PowerManager.GetPowerByClass(ExistingClass);
        if (Power != None)
        {
            Owner.PowerManager.RemovePower(ExistingClass);
        }
        Player.PlayerClass.SquadScreenPowerOrder.Remove(load.SlotIndex, 1);
        Player.PlayerClass.SquadScreenPowerOrder.InsertItem(load.SlotIndex, load.LoadedPowerClass);
        if (load.SlotIndex < Player.PlayerClass.MappedPowers.Length)
        {
            Player.PlayerClass.MappedPowers.Remove(load.SlotIndex, 1);
            Player.PlayerClass.MappedPowers.InsertItem(load.SlotIndex, load.LoadedPowerClass.Name);
        }
        Power = InstantiatePower(load.LoadedPowerClass, load.SlotIndex);
    }
    else
    {
        Power = Owner.PowerManager.GetPowerByClass(load.LoadedPowerClass);
        log(Self.Name, "OnPowerLoaded: Same class at slot " $ load.SlotIndex $ ", refreshing rank/evo", Outer);
    }
    if (Power != None)
    {
        SetPowerRankAndEvolutions(Power, load.PowerModel);
    }
    else
    {
        log(Self.Name, "OnPowerLoaded: No power instance found at slot " $ load.SlotIndex, Outer);
    }
    DecrementAndCheckDone();
}
function OnBorrowedPowerLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP Player;
    local SFXPowerCustomActionBase FourthPower;
    local SFXPowerCustomActionBase FifthPower;
    
    if (load.LoadedPowerClass == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: Failed to load: " $ load.AssetToLoad, Outer);
        DecrementAndCheckDone();
        return;
    }
    Player = SFXPawn_PlayerMP(Owner);
    if (Player == None || PC == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: Not a PlayerMP pawn or no PC", Outer);
        DecrementAndCheckDone();
        return;
    }
    // Class is in memory; call GivePower to properly instantiate it in the bonus slot.
    log(Self.Name, "OnBorrowedPowerLoaded: Calling GivePower for " $ load.AssetToLoad, Outer);
    BioCheatManager(PC.CheatManager).GivePower("self", load.AssetToLoad);
    FourthPower = Owner.PowerManager.Powers[10];
    FifthPower = Owner.PowerManager.Powers[11];
    if (FifthPower != None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: Evicting overflow power " $ FourthPower, Outer);
        Owner.PowerManager.RemovePower(FourthPower.Class);
        Player.SquadScreenPowerOrder.RemoveItem(FourthPower.Class);
        FourthPower = FifthPower;
    }
    if (FourthPower == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: FourthPower is None after GivePower", Outer);
        DecrementAndCheckDone();
        return;
    }
    log(Self.Name, "OnBorrowedPowerLoaded: Placing " $ FourthPower $ " at slot 3", Outer);
    Player.PlayerClass.SquadScreenPowerOrder.InsertItem(3, FourthPower.Class);
    FourthPower.Rank = float(load.PowerModel.Rank);
    FourthPower.OnPowerRankIncreased();
    ApplyEvolutions(FourthPower, load.PowerModel);
    FourthPower.RecalculateAllPowerInfo();
    SFXPawn_PlayerMP(Owner).ApplyWeaponEncumbrance();
    bAppliedBorrowedPower = TRUE;
    log(Self.Name, "OnBorrowedPowerLoaded: Done", Outer);
    DecrementAndCheckDone();
}
private final function SFXPowerCustomActionBase InstantiatePower(Class<SFXPowerCustomActionBase> powerClass, int SlotIndex)
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase PowerInList;
    local int PowerID;
    local int nIndex;
    
    if (powerClass == None)
    {
        return None;
    }
    PowerID = powerClass.default.PowerCustomActionID;
    if (PowerID == 0)
    {
        log(Self.Name, "InstantiatePower: PowerCustomActionID is 0 for " $ powerClass, Outer);
        return None;
    }
    for (nIndex = 0; nIndex < Outer.PowerManager.Powers.Length; nIndex++)
    {
        PowerInList = Outer.PowerManager.Powers[nIndex];
        if (PowerInList != None && PowerInList.Class == powerClass)
        {
            log(Self.Name, "InstantiatePower: Already instanced: " $ powerClass, Outer);
            return None;
        }
    }
    Outer.PowerCustomActionClasses[PowerID] = powerClass;
    Outer.VerifyCAHasBeenInstanced(132, PowerID);
    Power = SFXPowerCustomActionBase(Outer.PowerCustomActions[PowerID]);
    if (Power != None)
    {
        Outer.PowerManager.Powers.InsertItem(SlotIndex, Power);
        for (nIndex = 0; nIndex < Outer.PowerManager.Powers.Length; nIndex++)
        {
            PowerInList = Outer.PowerManager.Powers[nIndex];
            if (PowerInList != None)
            {
                PowerInList.OnPowerAdded(Power);
            }
        }
        log(Self.Name, "InstantiatePower: Instanced " $ Power $ " at slot " $ SlotIndex, Outer);
    }
    return Power;
}
private final function ApplyEvolutions(SFXPowerCustomActionBase Power, SFSPowerModelStruct Model)
{
    Power.EvolvePower(Model.Evo0 == "B" ? 1 : 0);
    // tier 0: A=0, B=1
    Power.EvolvePower(Model.Evo1 == "B" ? 3 : 2);
    // tier 1: A=2, B=3
    Power.EvolvePower(Model.Evo2 == "B" ? 5 : 4);
    // tier 2: A=4, B=5
    log(Self.Name, "ApplyEvolutions: " $ Power $ " Evo=" $ Model.Evo0 $ "/" $ Model.Evo1 $ "/" $ Model.Evo2, Outer);
}
private final function SetPowerRankAndEvolutions(SFXPowerCustomActionBase Power, SFSPowerModelStruct Model)
{
    Power.ResetPower();
    Power.Rank = float(Model.Rank);
    ApplyEvolutions(Power, Model);
    Power.RecalculateAllPowerInfo(TRUE);
    SFXPawn_PlayerMP(Outer).ApplyWeaponEncumbrance();
    log(Self.Name, "SetPowerRankAndEvolutions: " $ Power $ " Rank=" $ Model.Rank, Outer);
}
private final function DecrementAndCheckDone()
{
    PendingLoadCount--;
    log(Self.Name, "DecrementAndCheckDone: " $ PendingLoadCount $ " remaining", Outer);
    if (PendingLoadCount <= 0)
    {
        PendingLoadCount = 0;
        RemapInputs();
    }
}
private final function RemapInputs()
{
    local SFXPawn_PlayerMP Player;
    
    Player = SFXPawn_PlayerMP(Outer);
    if (Player == None || PC == None || BPI == None)
    {
        log(Self.Name, "RemapInputs: Missing required references", Outer);
        return;
    }
    if (bAppliedBorrowedPower)
    {
        if (BPI.bUsingGamepad)
        {
            Class'SFSInputUtility'.static.MapXboxSpecial(BPI, Player);
        }
        else
        {
            Class'SFSInputUtility'.static.AutoMapPCSpecial(BPI, Player);
        }
    }
    else if (BPI.bUsingGamepad)
    {
        Class'SFSInputUtility'.static.AutoMapXbox(BPI, Player);
    }
    else
    {
        Player.AutoMapPC();
    }
    log(Self.Name, "RemapInputs: Done (borrowedPower=" $ bAppliedBorrowedPower $ ", gamepad=" $ BPI.bUsingGamepad $ ")", Outer);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}