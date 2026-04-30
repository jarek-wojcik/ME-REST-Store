Class SFSPowerManager extends SFSManager within SFXPawn;

var SFSPortalAsyncLoader asyncLoader;
var SFSGenericStringQueue powerLoad_queue;
var BioPlayerController PC;
var BioPlayerInput BPI;
var bool bAppliedBorrowedPower;
var SkeletalMeshSocket FlamerSocket;
var SkeletalMeshSocket FlamerOmniToolSocket;
var SkeletalMeshSocket SnapFreezeSocketRight;
var SkeletalMeshSocket SnapFreezeSocketLeft;

public event simulated function HandlePostAdd()
{
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    powerLoad_queue = new (Self) Class'SFSGenericStringQueue';
    powerLoad_queue.queueEmptyEventString = Class'SFSGenericEventConstants'.default.PowersLoaded_Event;
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
public function LoadPowers(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local int i;
    
    bAppliedBorrowedPower = FALSE;
    if (asyncLoader == None)
    {
        log(Self.Name, "LoadPowers: asyncLoader is None", Outer);
        return;
    }
    log(Self.Name, "LoadPowers: " $ Character.PowerCount $ " regular power(s)", Outer);
    RemoveExistingPowers(SFXPawn_PlayerMP(Pawn));
    //Saturate the queue
    for (i = 0; i < Character.PowerCount; i++)
    {
        powerLoad_queue.addItem(Character.Powers[i].PowerID);
    }
    //Need to update this in the future to also handle henchmen.
    for (i = 0; i < Character.PowerCount; i++)
    {
        if (Character.Powers[i].PowerID == "")
        {
            continue;
        }
        asyncLoader.LoadPowerClassBlocking(Character.Powers[i].PowerID, Character.Powers[i], i, FALSE, OnPowerLoaded);
        log(Self.Name, "Queued power: " $ Character.Powers[i].PowerID $ " at slot " $ i, Outer);
    }
    if (Character.bHasBorrowedPower && Character.BorrowedPower.PowerID != "")
    {
        powerLoad_queue.addItem(Character.BorrowedPower.PowerID);
        asyncLoader.LoadPowerClassBlocking(Character.BorrowedPower.PowerID, Character.BorrowedPower, 3, TRUE, OnBorrowedPowerLoaded);
        log(Self.Name, "Queued borrowed power: " $ Character.BorrowedPower.PowerID, Outer);
    }
}
function RemoveExistingPowers(SFXPawn_PlayerMP Pawn)
{
    local int nIndex;
    local Class<SFXPowerCustomActionBase> powerClass;
    
    Class'SFSCore'.static.printArrayContents(Self.Name, Outer, Pawn.PlayerClass.SquadScreenPowerOrder, " SquadScreenPowerOrder for class $" $ Pawn.PlayerClassName);
    for (nIndex = 0; nIndex < Pawn.PlayerClass.SquadScreenPowerOrder.Length; nIndex++)
    {
        powerClass = Pawn.PlayerClass.SquadScreenPowerOrder[nIndex];
        log(Self.Name, "Removing Power: " $ powerClass, Outer);
        if (powerClass != None)
        {
            Outer.PowerManager.RemovePower(powerClass);
        }
    }
}
function OnPowerLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP Player;
    local Class<SFXPowerCustomActionBase> ExistingClass;
    local SFXPowerCustomActionBase Power;
    
    // Validation of inputs.
    Player = SFXPawn_PlayerMP(Owner);
    if (Player == None)
    {
        log(Self.Name, "OnPowerLoaded: Not a PlayerMP pawn", Outer);
        return;
    }
    if (load.LoadedPowerClass == None)
    {
        log(Self.Name, "OnPowerLoaded: Failed to load: " $ load.AssetToLoad, Outer);
        return;
    }
    if (load.SlotIndex >= Player.PlayerClass.SquadScreenPowerOrder.Length)
    {
        log(Self.Name, "OnPowerLoaded: Slot " $ load.SlotIndex $ " out of bounds (len=" $ Player.PlayerClass.SquadScreenPowerOrder.Length $ ")", Outer);
        return;
    }
    // End of Validation.
    ExistingClass = Player.PlayerClass.SquadScreenPowerOrder[load.SlotIndex];
    log(Self.Name, "OnPowerLoaded: Slot " $ load.SlotIndex $ " existing=" $ ExistingClass $ " new=" $ load.LoadedPowerClass, Outer);
    Player.PlayerClass.SquadScreenPowerOrder.Remove(load.SlotIndex, 1);
    Player.PlayerClass.SquadScreenPowerOrder.InsertItem(load.SlotIndex, load.LoadedPowerClass);
    if (load.SlotIndex < Player.PlayerClass.MappedPowers.Length)
    {
        Player.PlayerClass.MappedPowers.Remove(load.SlotIndex, 1);
        Player.PlayerClass.MappedPowers.InsertItem(load.SlotIndex, load.LoadedPowerClass.Name);
    }
    Power = InstantiatePower(load.LoadedPowerClass, load.SlotIndex);
    if (Power != None)
    {
        SetPowerRankAndEvolutions(Power, load.PowerModel);
    }
    else
    {
        log(Self.Name, "OnPowerLoaded: No power instance found at slot " $ load.SlotIndex, Outer);
    }
    powerLoad_queue.popItem(load.AssetToLoad);
    RemapInputs();
}
function OnBorrowedPowerLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP Player;
    local SFXPowerCustomActionBase FourthPower;
    
    Player = SFXPawn_PlayerMP(Owner);
    // Input Validation
    if (Player == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: Not a PlayerMP pawn", Outer);
        return;
    }
    if (load.LoadedPowerClass == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: Failed to load: " $ load.AssetToLoad, Outer);
        return;
    }
    // We already have the Class<SFXPowerCustomActionBase> from the async load ? use it directly.
    log(Self.Name, "OnBorrowedPowerLoaded: Adding " $ load.LoadedPowerClass $ " to PowerManager", Outer);
    Owner.PowerManager.AddPower(load.LoadedPowerClass);
    FourthPower = Owner.PowerManager.GetPowerByClass(load.LoadedPowerClass);
    if (FourthPower == None)
    {
        log(Self.Name, "OnBorrowedPowerLoaded: FourthPower is None after AddPower", Outer);
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
    powerLoad_queue.popItem(load.AssetToLoad);
    RemapInputs();
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
public final function AddPowerSockets(SFXPawn Pawn)
{
    local SFXPowerCustomActionBase powerI;
    
    foreach Pawn.PowerManager.Powers(powerI, )
    {
        if (InStr(string(powerI.Name), "Flamer", , TRUE, ) != 0)
        {
            log(Self.Name, "Adding Flamer Socket", Outer);
            Pawn.Mesh.SkeletalMesh.Sockets.AddItem(default.FlamerSocket);
            Pawn.Mesh.SkeletalMesh.Sockets.AddItem(default.FlamerOmniToolSocket);
        }
        if (InStr(string(powerI.Name), "SnapFreeze", , TRUE, ) != 0)
        {
            log(Self.Name, "Adding Snap Freeze Socket", Outer);
            Pawn.Mesh.SkeletalMesh.Sockets.AddItem(default.FlamerSocket);
            Pawn.Mesh.SkeletalMesh.Sockets.AddItem(default.FlamerOmniToolSocket);
        }
    }
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
    FlamerSocket = SkeletalMeshSocket'SFSMultiplayer.SFSManagers.FlamerSockets.SkeletalMeshSocket_8'
    FlamerOmniToolSocket = SkeletalMeshSocket'SFSMultiplayer.SFSManagers.FlamerSockets.SkeletalMeshSocket_2'
    SnapFreezeSocketRight = SkeletalMeshSocket'SFSMultiplayer.SFSManagers.SnapFreezeSockets.SkeletalMeshSocket_0'
    SnapFreezeSocketLeft = SkeletalMeshSocket'SFSMultiplayer.SFSManagers.SnapFreezeSockets.SkeletalMeshSocket_1'
}